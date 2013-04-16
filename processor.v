// The main code for the processor
module processor (
   input en,
   input clk,                       // Clock
   output halt,
   output [15:0] cc
);
    // For simulation
    initial begin
        #1 r0_multiplexer_en=0;r0_state=0; pc=0; cc=0;ir=0; fetch_ready=0;execute_ready=0;temp_pc=0; halt=0;val3=0;
        #1 memory_controller_en=0;mem_state=0;input_data=0;input_reserve=0;input_data=0; address_data=0; address_reserve=0; address3=0;
        #1 read_ir=0;read_data=0;read_reserve=0;read3=0; write_data=0;write_reserve=0; write3=0; halt=0;
        #1 r2=8'd12; r3=8'd11; r0=8'd0; r1=8'd1;
    end

    reg [3:0] count;
    reg [8:0] sleep_count;

    // For the r0 multiplexer
    reg r0_multiplexer_en;
    reg [1:0] r0_state;

    // Program counter
    reg [7:0] pc;

    // Program efficiency monitor
    reg [15:0] cc;

    // Instruction Register
    wire [7:0] fetch_ir;
    reg [7:0] ir;

    // Intermediate Registers
    wire [7:0] r0_output1, r0_output2;
    reg [7:0] val1, val2;

    // Registers available to the user
    reg [7:0] r0,r1,r2,r3;
    reg [1:0] val3;

    // For manipulating the memory
    reg memory_controller_en;
    reg [1:0] mem_state;
    reg [7:0] input_data, input_reserve, input_data3;              //The read data
    wire [7:0] output_data, output_reserve, output_data3;          //The read data
    reg [7:0] address_data, address_reserve,address3; //The address
    reg read_ir,read_data,read_reserve,read3;                      //Read signals
    reg write_data, write_reserve,write3;                          //Write Signals
    reg [7:0] temp_address, temp_pc;

    //Control Signals
    reg halt;       //Signal to indicate end of computation
    wire r0_multiplexer_ready, memory_controller_ready;
    reg execute_ready, fetch_ready;

    // Constants
    // The registers
    localparam R0=2'd0;
    localparam R1=2'd1;
    localparam R2=2'd2;
    localparam R3=2'd3;

    // Memory states
    localparam IR=2'd0;
    localparam RESERVE=2'd2;
    localparam DATA=2'd1;
    localparam OTHER=2'd3;

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
    localparam STORE=4'b1011;
    localparam LOAD=4'b1100;
    localparam LOADi=4'b1101;
    localparam JUMP=4'b1110;
    localparam IN=4'b0001;
    localparam OUT=4'b0010;
    localparam SLEEP=4'b0011;
    localparam HALT=4'b1111;

    // Functions
    // Function to assign value 1
    function [7:0] value1;
        input reg [7:0] instruction;

        // Selecting value based on the ir
        case (instruction[3:2])
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
        case (instruction[1:0])
            R0: value2=r0;
            R1: value2=r1;
            R2: value2=r2;
            R3: value2=r3;
        endcase
    endfunction

    //Perform computation
    always @(posedge clk) begin
        if(halt==1) begin

        end
        else begin
            // Fetch Cycle
            if(execute_ready==1 | en==1) begin
                if(cc==0) begin
                    fetch_ready=1;
                    execute_ready=0;
                    count=0;
                end
                else if(execute_ready==1) begin
                    count=0;
                    mem_state=IR;
                    memory_controller_en=1;
                    read_ir=1;
                    if(memory_controller_ready==1) begin
                        ir=fetch_ir;
                        memory_controller_en=0;
                        val1=value1(ir);
                        val2=value2(ir);
                        fetch_ready=1;
                        execute_ready=0;
                        $display("Fetch:\tval1=%d\tval2=%d",val1,val2);
                end
            end

            // Execute Cycle
            if(fetch_ready==1 & execute_ready==0) begin
                // At zeroth cycle, we set pc
                if(cc==0) begin
                    pc=8'd33;
                    cc=cc+1;
                    execute_ready=1;
                    fetch_ready=0;
                end
                else begin
                        cc=cc+1;
                        case(ir[7:4])
                            NOP: begin
                                    $display("\nNOP");
                                    case (ir[3:0])
                                        NOP: begin
                                                if(count==0) begin
                                                    pc=pc+1;
                                                    count=count+1;
                                                    fetch_ready=0;
                                                    execute_ready=1;
                                                end
                                                else if(count==2) begin
                                                    count=0;
                                                end
                                                else
                                                    count=count+1;
                                            end
                                        IN: begin
                                            end
                                        OUT: begin
                                            end
                                        SLEEP:begin
                                                $display("\nSLEEP\tcount=%d",sleep_count);
                                                if(sleep_count<=r0) begin
                                                    sleep_count=sleep_count+1;
                                                end
                                                else begin
                                                    pc=pc+1;
                                                    fetch_ready=0;
                                                    execute_ready=1;
                                                end
                                            end
                                        HALT: begin
                                                halt=1;
                                                fetch_ready=0;
                                                execute_ready=1;
                                            end
                                       default : begin
                                                    pc=pc+1;
                                                end
                                    endcase
                                end
                            ADD: begin
                                    $display("\nADD");                        // Display mem_state
                                    $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
                                    r0_state=R0_ADD;                          // Set multiplexer
                                    r0_multiplexer_en=1;                      // Start multiplexer
                                    if(r0_multiplexer_ready==1) begin
                                        r0=r0_output1;                        // Latch r0
                                        r0_multiplexer_en=0;                  // Stop multiplexer
                                        pc=pc+1;                              // Increment PC
                                        execute_ready=1;                      // Change to fetch Cycle
                                        fetch_ready=0;
                                    end
                                end
                            ADDi: begin
                                    if(count!=2) begin
                                        count=count+1;
                                    end
                                    else begin
                                        $display("\nADDi");
                                        $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
                                        //Selecting the register on the basis of the select value
                                        val3=ir[1:0];
                                        case (ir[3:2])
                                            R0: r0=r0+val2;
                                            R1: r1=r1+val2;
                                            R2: r2=r2+val2;
                                            R3: r3=r3+val2;
                                        endcase
                                        execute_ready=1;                      // Change to fetch Cycle
                                        fetch_ready=0;
                                        pc=pc+1;
                                    end                                       // Increment PC
                                end
                            SUB: begin
                                    $display("\nSUB");                        // Display mem_state
                                    $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
                                    r0_state=R0_SUB;                          // Set multiplexer
                                    r0_multiplexer_en=1;                      // Start multiplexer
                                    if(r0_multiplexer_ready==1) begin
                                        r0=r0_output1;                        // Latch r0
                                        r0_multiplexer_en=0;                  // Stop multiplexer
                                        pc=pc+1;                              // Increment PC
                                        execute_ready=1;                      // Change to fetch Cycle
                                        fetch_ready=0;
                                    end
                                end
                            MUL: begin
                                    // r0, r1
                                end
                            NEG: begin
                                    $display("\nNEG");                        // Display mem_state
                                    $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
                                    r0_state=R0_NEG;                          // Set multiplexer
                                    r0_multiplexer_en=1;                      // Start multiplexer
                                    if(r0_multiplexer_ready==1) begin
                                        r0=r0_output1;                        // Latch r0
                                        r0_multiplexer_en=0;                  // Stop multiplexer
                                        pc=pc+1;                              // Increment PC
                                        execute_ready=1;                      // Change to fetch Cycle
                                        fetch_ready=0;
                                    end
                                end
                            BGEZ0: begin
                                    if(r0>=0) begin
                                        if(count<=7) begin
                                            count=count+1;
                                            temp_address={3'b000,ir[3:0],1'b0};
                                        end
                                        else if(count<=12) begin
                                            $display("\nBRANCH\taddress_data=%b",temp_address);
                                            $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
                                            pc=temp_address;
                                            count=count+1;
                                        end
                                        else begin
                                            execute_ready=1;
                                            fetch_ready=0;
                                        end
                                    end
                                end
                            BGEZ1: begin
                                    if(r0>=0) begin
                                        if(count<=7) begin
                                            count=count+1;
                                            temp_address={3'b001,ir[3:0],1'b0};
                                        end
                                        else if(count<=12) begin
                                            $display("\nBRANCH\taddress_data=%b",temp_address);
                                            $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
                                            pc=temp_address;
                                            count=count+1;
                                        end
                                        else begin
                                            execute_ready=1;
                                            fetch_ready=0;
                                        end
                                    end
                                end
                            MOVE: begin
                                    if(count!=2) begin
                                        count=count+1;
                                    end
                                    else begin
                                        $display("\nMOVE");                    // Display mem_state
                                        $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
                                        case (ir[3:2])
                                            R0: r0=val2;
                                            R1: r1=val2;
                                            R2: r2=val2;
                                            R3: r3=val2;
                                        endcase
                                        execute_ready=1;                        // Change to fetch Cycle
                                        fetch_ready=0;
                                        pc=pc+1;
                                    end                                         // Incrementing PC
                                end
                            STORE: begin
                                    if(count<=5) begin
                                        count=count+1;
                                        memory_controller_en=0;
                                        read_data=0;
                                        write_data=1;
                                        temp_address=val1;
                                        mem_state=DATA;
                                    end
                                    else if (count<=8) begin
                                        $display("\nSTORE\taddress_data=%b",address_data);
                                        $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
                                        address_data=temp_address;
                                        memory_controller_en=1;
                                        input_data=val2;
                                        if(memory_controller_ready==1) begin
                                            memory_controller_en=0;
                                            count=count+1;
                                        end
                                    end
                                    else begin
                                        pc=pc+1;
                                        execute_ready=1;
                                        fetch_ready=0;
                                    end
                                end
                            LOAD: begin
                                    if(count<=1) begin
                                        count=count+1;
                                        memory_controller_en=0;
                                        read_data=1;
                                        write_data=0;
                                        mem_state=DATA;
                                        temp_address={2'b00,r3[1:0],ir[3:0]};
                                    end
                                    else if (count<=3) begin
                                        $display("\nLOAD\taddress_data=%b",address_data);
                                        $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
                                        address_data=temp_address;
                                        memory_controller_en=1;
                                        if(memory_controller_ready==1) begin
                                            r0=output_data;
                                            memory_controller_en=0;
                                            count=count+1;
                                        end
                                    end
                                    else begin
                                        pc=pc+1;
                                        execute_ready=1;
                                        fetch_ready=0;
                                    end
                                end
                            LOADi: begin
                                    $display("\nLOADi");                    // Display mem_state
                                    $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
                                    if(count<=4) begin
                                        count=count+1;
                                        val3=ir[1:0];
                                    end
                                    else if(count==5) begin
                                        pc=pc+1;
                                        count=count+1;
                                    end
                                    else begin
                                        case (ir[3:2])
                                            R0: r0=val3;
                                            R1: r1=val3;
                                            R2: r2=val3;
                                            R3: r3=val3;
                                        endcase                                // Incrementing PC
                                        execute_ready=1;                         // Change to fetch Cycle
                                        fetch_ready=0;
                                    end
                                end
                            JUMP: begin
                                    if(count<=7) begin
                                        count=count+1;
                                        case (ir[3:2])
                                            R0: temp_pc=r0;
                                            R1: temp_pc=r1;
                                            R2: temp_pc=r2;
                                        endcase
                                        r3=pc+1;
                                    end
                                    else if (count<=12) begin
                                        $display("\nJUMP");                       // Display mem_state
                                        $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
                                        pc=temp_pc;
                                        count=count+1;
                                    end
                                    else begin
                                        execute_ready=1;                           // Change to fetch Cycle
                                        fetch_ready=0;
                                    end
                                end
                            default: begin
                                        r0_multiplexer_en=0;
                                    end
                        endcase
                    end
                end
            end
            else begin
                r0_multiplexer_en=0;
            end
            $display("Processor:\ten=%d\tpc=%d\tir=%b\tcc=%d\n\t\t\tr0=%d\tr1=%d\tr2=%d\tr3=%d",en,pc,ir,cc,r0,r1,r2,r3);
        end
    end

    // Multiplexer for r0
    r0_multiplexer R0_MUX(
       .clk(clk),
       .en(r0_multiplexer_en),
       .state(r0_state),
       .value1(val1), .value2(val2),
       .Output1(r0_output1), .Output2(r0_output2),
       .ready(r0_multiplexer_ready)
    );

    // Memory Multiplexer
    memory_controller MC1(
        .clk(clk),
        .state(mem_state),
        .en(memory_controller_en),
        .read0(read_ir),.read1(read_data),.read2(read_reserve),.read3(read3),
        .write0(0),.write1(write_data),.write2(write_reserve),.write3(write3),
        .address0(pc),.address1(address_data),.address2(address_reserve),.address3(address3),
        .input_data0(0), .input_data1(input_data), .input_data2(input_reserve),.input_data3(input_data3),
        .output_data0(fetch_ir), .output_data1(output_data), .output_data2(output_reserve), .output_data3(output_data3),
        .ready(memory_controller_ready)
    );

    // // Display module
    // module display_module (
    //     .clk(clk),
    //     .en(display_en),
    //     .b1(b1),.b2(b2), .b3(b3), .b4(b4),
    //     .o1(o1),.o2(o2),.o3(o3),.o4(o4),
    //     .bcd(bcd)
    // );
endmodule