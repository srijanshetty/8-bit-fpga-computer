module test;
    // Registers
    reg clk;
    reg en;
    reg [1:0] r0_state;
    reg [7:0] value1, value2;
    wire [7:0] Output1, Output2;
    wire ready;

    // Initialize varibles
    initial begin
        #1 r0_state=1; en=1; value1=8'd1; value2=8'd2;clk=0;
        #20 $finish;
    end

    // Monitoring the output
    always begin
        #1 $display("\ntime=%8d\tclk=%d\ten=%d",$time,clk,en);
    end

    // Some module
    r0_multiplexer MUX1(
	   .ready(ready),
       .clk(clk),
       .en(en),
       .state(r0_state),
       .value1(value1), .value2(value2),
       .Output1(Output1), .Output2(Output2)
    );

    //For the clock
    always begin
        #1 clk=!clk;
    end
endmodule
