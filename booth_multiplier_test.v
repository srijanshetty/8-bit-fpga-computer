module test;
    // Registers
    reg clk;
    reg en;
    reg [7:0] A, B;
    wire [15:0] Output;         // The read data
    wire ready;

    // Initialize varibles
    initial begin
        #1 en=0; clk=0; A=8'd129; B=8'd1;
        #2 en=1;
        #15 en=0;
        #12 $finish;
    end

    // Monitoring the output
    always @(clk) begin
        if($time%2!=0) begin
            $display("\ntime=%8d\ten=%d\tclk=%d",$time,en,clk);
        end
    end

    // Some module
    booth_multiplier BOOTH1(
        .en(en),
        .clk(clk),
        .A(A), .B(B),
        .Output(Output),
        .ready(ready)
    );

    //For the clock
    always begin
        #1 clk=!clk;
    end
endmodule
