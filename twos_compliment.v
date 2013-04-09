module twos_compliment (
    input [7:0] A,  //Input
    output [7:0] Output //Output
   );

//Wires and other control signals
wire c_out,c_out2;
wire [7:0] temp_value;

ones_compliment COMPLIMENT1(.A(A),.Output(temp_value));
cla_adder ADDER1(.c_in(0), .A(temp_value[3:0]), .B(4'd1), .Output(Output[3:0]), .c_out(c_out));
cla_adder ADDER2(.c_in(0), .A(temp_value[7:4]), .B({3'd0,c_out}), .Output(Output[7:4]), .c_out(c_out2));
endmodule