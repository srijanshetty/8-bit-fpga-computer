module test;
    // Registers
    reg clk;
    reg en;
    reg c_in;
    wire c_out;
    reg [3:0] A, B;
    wire [3:0] Output;         // The read data
    wire ready;

    // Initialize varibles
    initial begin
        #1 en=0; A=4'd1; B=4'd2;c_in=0;clk=0;
        #2 en=1;
        #5 en=0;
        #2 $finish;
    end

    // Monitoring the output
    always begin
        #1 $display("\ntime=%d\tclk=%d\ten=%d",$time,clk,en);
    end

    // Some module
    cla_adder CLA1(
        .clk(clk),
        .en(en),
        .c_in(c_in),
        .A(A), .B(B),
        .ready(ready),
        .Output(Output),
        .c_out(c_out)
    );

    //For the clock
    always begin
        #1 clk=!clk;
    end
endmodule