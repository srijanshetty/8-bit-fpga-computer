module test;
    reg clk;
    reg en;
    // More registers

    // Initialize varibles
    initial
    begin
        #1 en=1;
        #20 en=0;
        #40 \$finish;
    end

    // Monitoring the output
    initial
    begin
        #1 \$monitor("\ntime=%d\tclk=%d",,clk);

    end

    // Some module

    //For the clock
    always
    begin
        #1 clk=!clk;
    end
endmodule