module test;
    // Registers
    reg clk;
    reg en;
    reg [7:0] A;
    wire [7:0] Output;         // The read data
    wire ready;

    // Initialize varibles
    initial begin
        #1 en=0; A=8'd12; clk=0;
        #2 en=1;
        #10 en=0;
        #15 $finish;
    end

    // Monitoring the output
    always @(clk) begin
        if($time%2!=0) begin
            $display("\ntime=%8d\ten=%d\tclk=%d",$time,en,clk);
        end
    end

    // Some module
    // Calling the module
    twos_compliment TWO(
        .clk(clk),
        .en(en),
        .A(A),
        .ready(ready),
        .Output(Output)
    );

    //For the clock
    always begin
        #1 clk=!clk;
    end
endmodule

