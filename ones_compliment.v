module ones_compliment (
    input [7:0] A, //input element
    output [7:0] Output
   );

assign Output[0]=A[0]^1;
assign Output[1]=A[1]^1;
assign Output[2]=A[2]^1;
assign Output[3]=A[3]^1;
assign Output[4]=A[4]^1;
assign Output[5]=A[5]^1;
assign Output[6]=A[6]^1;
assign Output[7]=A[7]^1;

endmodule









