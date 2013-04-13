module booth_multiplier (
	input clk, // Clock
	input en, //Enable Signal
	input [7:0] A,B,
	output [15:0] Output,
	output ready
);

  // For simulation only
  initial begin
    #1 count=0;
  end

  reg ready;                            //Ready signal for the module

  //required variables
  reg [15:0] posA, negA;
  reg [7:0] tempB;
  wire [7:0] compA;
  reg prev;
  wire c_out1, c_out2;
  wire [15:0] posOutput, negOutput;
  reg [15:0] temp_Output;
  reg [16:0] count;
  wire[1:0] ripple_ready;

  function [7:0] sign;                    //Function to check sign
    input [7:0] A;
    input [7:0] B;

    if(A[7]==B[7])
      sign=0;
    else
      sign=1;
  endfunction

  function [7:0] absolute_value;          //Function to convert to absolute value
    input [7:0] input_value;

    if(input_value>8'd127)
      absolute_value=9'd256-input_value;
    else
      absolute_value=input_value;
  endfunction

  //Assigning the internal Output to the wire
  assign Output=(sign(A,B)==1)?(17'd65536-temp_Output):temp_Output;

  // Ready signal
  always @(clk) begin
    if(en==1) begin
      if(count!=8) begin
          count=count+1;
          ready=0;
        end
        else
          ready=1;
    end
    else begin
      count=0;
      ready=0;
    end
    $display("\nBOOTH: A=%d\tB=%d\tOutput=%d\tReady=%d",A,B,Output,ready);
  end

  always @(posedge clk) begin
    if(en==1) begin
      if(tempB[0]==1 & prev==0)
        temp_Output=posOutput;
      else if(tempB[0]==0 & prev==1)
        temp_Output=negOutput;
      prev=tempB[0];
      posA=(posA<<1); //Right shift of posA
      negA=(negA<<1); //Right shift of negA
      tempB=(tempB>>1); //Left shift of B
    end
    else begin
        posA={8'd0,absolute_value(A)};
        negA={8'b11111111,compA};
        tempB=absolute_value(B);
        prev=1'b0;
        temp_Output=16'd0;
      end
  end

  //taking the negative of A
  twos_compliment COMPLIMENT1(
    .clk(clk),
    .A(absolute_value(A)),
    .Output(compA)
  );

  ripple_cla16 CLA1(
    .clk(clk),
    .c_in(0),
    .A(temp_Output),
    .en(en),
    .B(negA),
    .Output(posOutput),
    .c_out(c_out1),
    .ready(ripple_ready[0])
  );
  ripple_cla16 CLA2(
    .c_in(0),
    .A(temp_Output),
    .en(en),
    .B(posA),
    .Output(negOutput),
    .c_out(c_out2),
    .ready(ripple_ready[1])
  );
endmodule
