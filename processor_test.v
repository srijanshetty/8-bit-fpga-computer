module test;
    // Registers
    reg clk;
    reg en;
    wire halt;
    wire [15:0] cc;

    // Initialize varibles
    initial begin
        #1 en=0; clk=0;
        #5 en=1;
        #100 en=0;
        #12 $finish;
    end

    // Monitoring the output
    always @(clk) begin
        if($time%2!=0) begin
            $display("\ntime=%8d\ten=%d\tclk=%d",$time,en,clk);
        end
    end

    // Some module
    processor y11_220(
       .en(en),
       .clk(clk),
       .halt(halt),
       .cc(cc)
    );

    //For the clock
    always begin
        #1 clk=!clk;
    end
endmodule