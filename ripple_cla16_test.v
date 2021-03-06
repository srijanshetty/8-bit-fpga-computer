module test;
    // Registers
    reg clk;
    reg en;
    reg c_in;
    wire c_out;
    reg [15:0] A, B;
    wire [15:0] Output;         // The read data
    wire ready;

    // Initialize varibles
    initial begin
        #1 en=0; A=8'd127; B=8'd127; c_in=0;clk=0;
        #2 en=1;
        #10 en=0;
        #5 en=1;
        #2 $finish;
    end

    // Monitoring the output
    always @(clk) begin
        if($time%2!=0) begin
            $display("\ntime=%8d\ten=%d\tclk=%d",$time,en,clk);
        end
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

