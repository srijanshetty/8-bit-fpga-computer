// The main code for the processor
module processor (
   input clk,                       // Clock
   input start,                     // Start Signal
   output output_halt,
   output [15:0] cc
);
    // For simulation
    initial begin
        #1 r0_multiplexer_en=0;r0_state=0; pc=0; cc=0;ir=0;r0=0;r1=0;r2=0;r3=0;r0_output1=0;r0_output2=0;
        #1 memory_controller_en=0;state=0;input_data=0;input_reserve=0;input_data=0; address_data=0; address_reserve=0; address3=0;
        #1 read_ir=0;read_data=0;read_reserve=0;read3=0; write_data=0;write_reserve=0; write3=0; halt=0;
    end

    // For the r0 multiplexer
    reg r0_multiplexer_en;
    reg [1:0] r0_state;

    // Program counter
    reg [6:0] pc;

    // Program efficiency monitor
    reg [15:0] cc;

    // Instruction Register
    wire [7:0] ir;

    // Intermediate Registers
    wire [7:0] r0_output1, r0_output2;

    // Registers available to the user
    reg [7:0] r0,r1,r2,r3;

    // For manipulating the memory
    reg memory_controller_en;
    reg [1:0] state;
    reg [7:0] input_data, input_reserve, input_data3;              //The read data
    wire [7:0] output_data, output_reserve, output_data3;          //The read data
    reg [6:0] address_data, address_reserve,address3;              //The address
    reg read_ir,read_data,read_reserve,read3;                      //Read signals
    reg write_data, write_reserve,write3;                          //Write Signals

    //Control Signals
    reg halt;       //Signal to indicate end of computation
    wire r0_multiplexer_ready, memory_controller_ready;

    // Constants
    // The registers
    localparam R0=2'd0;
    localparam R1=2'd1;
    localparam R2=2'd2;
    localparam R3=2'd3;

    // Parameters
    localparam R0_ADD=2'd0;
    localparam R0_SUB=2'd1;
    localparam R0_MUL=2'd2;
    localparam R0_NEG=2'd3;

    // The location of the display system call
    localparam DISP0=7'd28;
    localparam DISP1=7'd29;
    localparam DISP2=7'd30;
    localparam DISP3=7'd31;

    // Instruction Set
    localparam NOP=4'b0000;
    localparam ADD=4'b0001;
    localparam ADDi=4'b0010;
    localparam SUB=4'b0011;
    localparam MUL=4'b0100;
    localparam NEG=4'b0110;
    localparam BGEZ0=4'b1000;
    localparam BGEZ1=4'b1001;
    localparam MOVE=4'b1010;
    localparam ST=4'b1011;
    localparam LD=4'b1100;
    localparam LI=4'b1101;
    localparam J=4'b1110;
    localparam IN=4'b0001;
    localparam OUT=4'b0010;
    localparam SLEEP=4'b0011;
    localparam HALT=4'b1111;

    // Functions
    // Function to assign value 1
    function [7:0] value1;
        input reg [7:0] instruction;

        // Selecting value based on the ir
        case (ir[3:2])
            R0: value1=r0;
            R1: value1=r1;
            R2: value1=r2;
            R3: value1=r3;
        endcase
    endfunction

    // Function to assign value2
    function [7:0] value2;
        input reg [7:0] instruction;

        // Selecting value based on the ir
        case (ir[1:0])
            R0: value2=r0;
            R1: value2=r1;
            R2: value2=r2;
            R3: value2=r3;
        endcase
    endfunction

    //Perform computation
    always @(posedge clk) begin
       if(en==1) begin
           // At zeroth cycle, we set pc
           if(cc==0)
           begin
               pc=7'd32;
               state=2'd1;
               read_ir=1;
           end

           if(start) begin
                cc=cc+1;
                case(ir[7:4])
                    NOP: begin
                            case (ir[3:0])
                                IN: begin
                                    end
                                OUT: begin
                                    end
                                SLEEP:begin
                                    end
                                HALT: begin
                                    end
                               default : /* default */;
                            endcase
                        end
                    ADD: begin
                            r0_state=R0_ADD;
                            r0_multiplexer_en=1;
                            if(r0_multiplexer_ready==1) begin
                                r0=r0_output1;
                                pc=pc+1;
                            end
                        end
                    ADDi: begin
                            //Selecting the register on the basis of the select value
                            case (ir[3:2])
                                R0: r0=r0+ir[1:0];
                                R1: r1=r1+ir[1:0];
                                R2: r2=r2+ir[1:0];
                                R3: r3=r3+ir[1:0];
                            endcase
                            pc=pc+1;                                // Incrementing PC
                        end
                    SUB: begin
                            r0_state=R0_SUB;
                            r0_multiplexer_en=1;
                            if(r0_multiplexer_ready==1) begin
                                r0=r0_output1;
                                pc=pc+1;
                            end
                        end
                    MUL: begin
                            // r0, r1
                        end
                    NEG: begin
                            r0_state=R0_NEG;
                            r0_multiplexer_en=1;
                            if(r0_multiplexer_ready==1) begin
                                r0=r0_output1;
                                pc=pc+1;
                            end
                        end
                    BGEZ0: begin
                        end
                    BGEZ1: begin
                        end
                    MOVE: begin
                            case (ir[3:2])
                                R0: r0=value2(ir);
                                R1: r1=value2(ir);
                                R2: r2=value2(ir);
                                R3: r3=value2(ir);
                            endcase
                            pc=pc+1;                                // Incrementing PC
                        end
                    ST: begin
                        end
                    LD: begin
                        end
                    LI: begin
                            case (ir[3:2])
                                R0: r0=ir[1:0];
                                R1: r1=ir[1:0];
                                R2: r2=ir[1:0];
                                R3: r3=ir[1:0];
                            endcase
                            pc=pc+1;                                 // Incrementing PC
                        end
                    J: begin
                            r3=pc+1;
                            case (ir[3:2])
                                R0: pc=r0;
                                R1: pc=r1;
                                R2: pc=r2;
                            endcase
                        end
                    default: begin
                                r0_multiplexer_en=0;
                            end
                endcase
           end
        end
        else begin
            r0_multiplexer_en=0;
        end
    end

    // Multiplexer for r0
    r0_multiplexer R0_MUX(
       .clk(clk),
       .en(r0_multiplexer_en),
       .state(r0_state),
       .value1(value1(ir)), .value2(value1(ir)),
       .Output1(r0_output1), .Output2(r0_output2),
       .ready(r0_multiplexer_ready)
    );

    // Memory Multiplexer
    memory_controller MC1(
        .clk(clk),
        .state(state),
        .en(memory_controller_en),
        .read0(read_ir),.read1(read_data),.read2(read_reserve),.read3(read3),
        .write0(0),.write1(write_data),.write2(write_reserve),.write3(write3),
        .address0(pc),.address1(address_data),.address2(address_reserve),.address3(address3),
        .input_data0(0), .input_data1(input_data), .input_data2(input_reserve),.input_data3(input_data3),
        .output_data0(ir), .output_data1(output_data), .output_data2(output_reserve), .output_data3(output_data3),
        .ready(memory_controller_ready)
    );
endmodule