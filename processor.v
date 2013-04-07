// The main code for the processor
module processor (
   input clk,                       // Clock
   input start,                     // Start Signal
   output output_halt,
   output output_cc
);

    // Program counter
    reg [7:0] pc;

    // Program efficiency monitor
    reg [7:0] cc;

    // Instruction Register
    wire [7:0] ir;

    // Registers available to the user
    reg [7:0] r0,r1,r2,r3;

    // For manipulating the memory
    reg memory_en, memory_read;
    reg [7:0] read_data;                     //The read data
    reg [6:0] address;                       //The address

    //Control Signals
    reg halt;       //Signal to indicate end of computation

    // Constants
    // The location of the display system call
    localparam DISP0=2'd0;
    localparam DISP1=2'd1;
    localparam DISP2=2'd2;
    localparam DISP3=2'd3;

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

    //Flag to indicate whether the exectution has just started or not
    always @(start or halt)
    begin
        if(halt==0)
            start_flag=1;
        else
            start_flag=0;
    end

    //Load the program efficieny into output cc counter
    assign output_cc=cc;

    //Perform computation
    always @(posedge clk)
       if(start_flag)
       begin
           // pc=
       end

       if(start)
       begin
            cc=cc+1;
            opcode=ir[7:4];
            case(opcode)
                NOP:
                    begin
                    end
                ADD:
                    begin
                    end
                ADDi:
                    begin
                    end
                SUB:
                    begin
                    end
                MUL:
                    begin
                    end
                NEG:
                    begin
                    end
                BGEZ0:
                    begin
                    end
                BGEZ1:
                    begin
                    end
                MOVE:
                    begin
                    end
                ST:
                    begin
                    end
                LD:
                    begin
                    end
                LI:
                    begin
                    end
                J:
                    begin
                    end
            endcase
       end
    end

endmodule