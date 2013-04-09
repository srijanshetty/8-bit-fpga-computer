module ripple_cla16(input c_in, input [15:0] A, B, output [15:0] Output, output c_out);

//Connecting wires
wire temp1_c,temp2_c,temp3_c;
wire [15:0] D;

//Xoring the values
assign D[0]=B[0]^c_in;
assign D[1]=B[1]^c_in;
assign D[2]=B[2]^c_in;
assign D[3]=B[3]^c_in;
assign D[4]=B[4]^c_in;
assign D[5]=B[5]^c_in;
assign D[6]=B[6]^c_in;
assign D[7]=B[7]^c_in;
assign D[8]=B[8]^c_in;
assign D[9]=B[9]^c_in;
assign D[10]=B[10]^c_in;
assign D[11]=B[11]^c_in;
assign D[12]=B[12]^c_in;
assign D[13]=B[13]^c_in;
assign D[14]=B[14]^c_in;
assign D[15]=B[15]^c_in;

//Calling other CLA module for computation
cla_adder CLA1(.c_in(c_in),.c_out(temp1_c),.A(A[3:0]),.B(D[3:0]),.Output(Output[3:0]));
cla_adder CLA2(.c_in(temp1_c),.c_out(temp2_c),.A(A[7:4]),.B(D[7:4]),.Output(Output[7:4]));
cla_adder CLA3(.c_in(temp2_c),.c_out(temp3_c),.A(A[11:8]),.B(D[11:8]),.Output(Output[11:8]));
cla_adder CLA4(.c_in(temp3_c),.c_out(c_out),.A(A[15:12]),.B(D[15:12]),.Output(Output[15:12]));
endmodule
