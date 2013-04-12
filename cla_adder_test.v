module test;
    reg en;
    reg c_in;
    reg [3:0] A, B;	
    wire [3:0] Output;         // The read data
    wire c_out,ready;

    initial
    begin
	#1 en=0;
        #2 A=4'd15; B=4'd15;c_in=0;
	#2 en=1;
        #50 $finish;
    end

    cla_adder CLA1(.en(en),.c_in(c_in), .A(A), .B(B), .ready(ready), .Output(Output),.c_out(c_out));

endmodule
