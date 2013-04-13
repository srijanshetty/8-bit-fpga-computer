module test;
    // Registers
    reg clk;
    reg en;
    reg c_in;
    reg [15:0] A, B;
    wire [15:0] Output;         // The read data
    wire ready;

    // Initialize varibles
    initial begin
        #1 en=0; A=8'd127; B=8'd127; c_in=0;clk=0;
        #2 en=1;
        #15 $finish;
    end

    // Monitoring the output
    always begin
        #1 $display("\ntime=%d\tclk=%d",$time,clk);
    end

    // Some module
    // Calling the module
    ripple_cla16 RIP1(
        .clk(clk),
        .en(en),
        .A(A), .B(B),
        .ready(ready),
        .Output(Output),
        .c_out(c_out),
        .c_in(c_in)
    );

    //For the clock
    always begin
        #1 clk=!clk;
    end
endmodule

