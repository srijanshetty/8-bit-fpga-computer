module test;
    reg clk;
    reg [6:0] b1,b2,b3,b4;
    wire output_o1,output_o2,output_o3,output_o4;
    wire [0:6] output_bcd;
    reg en;

    initial
    begin
        #1 b1=1;
        #1 b2=1;
        #1 b3=1;
        #1 b4=1;
        #1 clk=0;
        #1 en=1;
        #10 en=0;
        #20 $finish;
    end

    display_module DISPLAY1(.en(en),.clk(clk), .b1(b1), .b4(b4), .b2(b2), .b3(b3), .output_o1(output_o1) ,.output_o2(output_o2), .output_o3(output_o3), .output_o4(output_o4), .output_bcd(output_bcd));

    always
    begin
        #1 clk=!clk;
    end
endmodule
