module test;
    reg en;
    reg c_in;
    reg [15:0] A, B;	
    wire [15:0] Output;         // The read data
    wire ready;

    initial
    begin
	#1 en=0;
        #2 A=8'd127; B=8'd127;c_in=0;
	#10 en=1;
	if(ready==0)
        	$finish;
    end
    ripple_cla16 RIP1(.en(en),.A(A), .B(B), .ready2(ready), .Output(Output), .c_out(c_out),.c_in(c_in));
endmodule
