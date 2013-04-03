module processor (
   input clk, // Clock
   input start,
   output halt
);

// Program counter
reg [7:0] pc;

// Program efficiency monitor
reg [7:0] cc;

// Instruction Register
reg [7:0] ir;

// Registers available to the user
reg [7:0] r0,r1,r2,r3;

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

always @(posedge clk)
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

// Load the instruction from memory according to the pc
endmodule