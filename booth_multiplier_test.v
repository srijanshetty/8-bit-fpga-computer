module test;
    reg en;
    reg clk;
    reg [7:0] A, B;	
    wire [15:0] Output;         // The read data
    wire ready;

    initial
    begin
	#0 clk=0;
	#1 en=0;
        #2 A=8'd129; B=8'd1;
	#10 en=1;
    end
    always
    begin
	#1 clk=!clk;
	if(ready==1)
		$finish;
    end	
    booth_multiplier BOOTH1(.en(en),.clk(clk), .A(A), .B(B), .Output(Output), .ready(ready));
endmodule
