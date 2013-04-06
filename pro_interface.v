//The order of digits are 4321
module alu(input read,write,dig1,dig2,dig3,dig4,rst,clk,rev,exec,sign, output o1,o2,o3,o4, output [0:6] bcd);

//Constants
localparam RESET=4'd0;
localparam IDLE=4'd1;
localparam ADDRESS=4'd2;
localparam DISPLAY=4'd3;
localparam WRITE=4'd4;
localparam EXECUTE=4'd5;
localparam DEBOUNCER_CONSTANT=32'b0111_1111_1111_1111_1111_1111_1111_1111;
localparam DEBOUNCER_CLOCK=5000;
localparam OPERATOR=4'd1;
localparam OPERAND1=4'd2;
localparam OPERAND2=4'd3;
localparam ADD=4'd0;
localparam SUB=4'd1;
localparam MUL=4'd2;
localparam DIV=4'd3;

//Variables and Control Signals
reg [3:0] state, location_state; //For storing states of the FSM and of the read
reg [3:0] di1,di2,di3,di4,di5,add1,add2,add4; //For storing the input values
reg [6:0] b1,b2,b3,b4; //for the bcd
reg [63:0] main_count;//Clock counts
reg [31:0] debouncer4,debouncer3,debouncer2,debouncer1; //Debouncers
reg [7:0] value, address; //Value and address
reg [31:0] temp_register; //Extrating memroy
reg [31:0] memory[0:31]; //Memory
reg [7:0] temp_value,temp_display1,temp_display2; //To store the converted value of the number
reg idle,address_read,mul_en; //Control Signals
reg sign_1, sign_2;//For the sign bit
wire temp_c_sub,temp_c_add; //To connect the CLAS's
wire [7:0] add_output,sub_output; //Storing the outputs of the various calculations
wire [15:0] mul_output, div_output;

//Functions
function [6:0] bcd_number; //Function for converting a digit into equivalent bcd
	input reg [3:0] d;

	//Converting the input into an equivalent bcd
	case (d)
		4'd0:bcd_number=7'b0000001;
		4'd1:bcd_number=7'b1001111;
		4'd2:bcd_number=7'b0010010;
		4'd3:bcd_number=7'b0000110;
		4'd4:bcd_number=7'b1001100;
		4'd5:bcd_number=7'b0100100;
		4'd6:bcd_number=7'b0100000;
		4'd7:bcd_number=7'b0001111;
		4'd8:bcd_number=7'b0000000;
		4'd9:bcd_number=7'b0001100;
		4'd10:bcd_number=7'b0001000;
		4'd11:bcd_number=7'b1100000;
		4'd12:bcd_number=7'b0110001;
		4'd13:bcd_number=7'b1000010;
		4'd14:bcd_number=7'b0110000;
		4'd15:bcd_number=7'b0111000;
		default:bcd_number=7'b1111111;
	endcase
endfunction

function [6:0] bcd_operator; //Function to convert a number into an operator
	input reg [3:0] d;

	//Converting the input into an equivalent bcd
	case (d)
		ADD:bcd_operator=7'b0001000;
		SUB:bcd_operator=7'b0100100;
		MUL:bcd_operator=7'b0011000;
		DIV:bcd_operator=7'b1000010;
		default:bcd_operator=7'b1111111;
	endcase
endfunction

function [7:0] absolute_value; //Function to convert to absolute value
	input [7:0] input_value;

	if(input_value>8'd127)
		absolute_value=9'd256-input_value;
	else
		absolute_value=input_value;
endfunction

//Allotment of states
always @(*)
begin
	if (rst==1)
		state=RESET;
	else if(idle==1)
		state=IDLE;
	else if(address_read==1 & exec==1)
		state=EXECUTE;
	else if(address_read==1 & read==1)
		state=DISPLAY;
	else if (address_read==1 & write==1)
		state=WRITE;
	else if (read==1 | write==1 | exec==1)
		state=ADDRESS;
	else
		state=IDLE;
end

//Setting idle
always @(posedge clk)
begin
	if(read==1 | write==1 | rst==1 | exec==1)
		idle=0;
	else
		idle=1;
end

//States of the machine
always @(posedge clk)
begin
	case(state)
		RESET:
			begin
				mul_en=0;address_read=0;
				location_state=RESET;
				address=0;value=0; //Values
				di1=0;di2=0;di3=0;di4=0;di5=0;add1=0;add2=0;add4=0; //Debouncer variables
				b4=7'b0110001;	//C
				b3=7'b1110001;	//L
				b2=7'b0110000;	//E
				b1=7'b1101010;	//n
			end

		IDLE:
			begin
				mul_en=0;address_read=0;
				location_state=RESET;
				b4=7'b1001111;	//I
				b3=7'b1000010;	//d
				b2=7'b1110001;	//L
				b1=7'b0110000;	//E
			end

		ADDRESS:
			begin
				//Debouncing the input
				main_count=main_count+1;
				if(main_count==DEBOUNCER_CLOCK)
				begin
					debouncer1=(debouncer1<<1)+dig1;
					debouncer2=(debouncer2<<1)+dig2;
					debouncer4=(debouncer4<<1)+dig4;

					if(debouncer4==DEBOUNCER_CONSTANT)
					begin
						address_read=1;
						address={add2,add1}; //Appending the two different values together
					end
					else
					begin
						if(debouncer1==DEBOUNCER_CONSTANT)
						begin
							if(rev==0)//Going reverse
								add1=(add1+1)%16;
							else
								add1=(add1-1)%16;
						end

						if(debouncer2==DEBOUNCER_CONSTANT)
						begin
							if(rev==0)//Going reverse
								add2=(add2+1)%2;
							else
								add2=(add2-1)%2;
						end
					end

					main_count=0;
					b4=7'b0001000;	//A
					b3=7'b1000010;	//d
					b2=bcd_number(add2);
					b1=bcd_number(add1);
				end
			end

		EXECUTE:
			begin
				temp_register=memory[address];
				case(temp_register[3:0])
					ADD:
						begin
							temp_value=absolute_value(add_output);

							//Overflow Underflow
							if(temp_register[15]==0 & temp_register[23]==0 & add_output[7]==1)
							begin
								b3=7'b1111111; //
								b2=7'b1111111; //
								b1=7'b1100010; //o
							end
							else if(temp_register[15]==1 & temp_register[23]==1 & add_output[7]==0)
							begin
								b3=7'b1111111; //
								b2=7'b1111111; //
								b1=7'b1100011; //u
							end
							else
							begin
								//Sign of the number
								if(temp_value!=add_output)
									b3=7'b1111110; //-
								else
									b3=7'b1111111; //
								
								b4=7'b1110110; //=
								b2=bcd_number(temp_value[7:4]);
								b1=bcd_number(temp_value[3:0]);
							end
						end
					SUB:
						begin
							temp_value=absolute_value(sub_output);

							//Overflow Underflow
							if(temp_register[15]==0 & temp_register[23]==1 & sub_output[7]==1)
							begin
								b3=7'b1111111; //
								b2=7'b1111111; //
								b1=7'b1100010; //o
							end
							else if(temp_register[15]==1 & temp_register[23]==0 & sub_output[7]==0)
							begin
								b3=7'b1111111; //
								b2=7'b1111111; //
								b1=7'b1100011; //u
							end
							else
							begin
								//Sign of the number
								if(temp_value!=sub_output)
									b3=7'b1111110; //-
								else
									b3=7'b1111111; //

								b4=7'b1110110; //=
								b2=bcd_number(temp_value[7:4]);
								b1=bcd_number(temp_value[3:0]);
							end
						end
					MUL:
						begin
							mul_en=1;
							b4=bcd_number(mul_output[15:12]);
							b3=bcd_number(mul_output[11:8]);
							b2=bcd_number(mul_output[7:4]);
							b1=bcd_number(mul_output[3:0]);
						end
					DIV:
						begin
							b2=bcd_number(div_output[7:4]);
							b1=bcd_number(div_output[3:0]);
						end
					default:
						begin
							b4=7'b1110110; //=
							b2=7'b1111110; //-
							b1=7'b1111110; //-
						end
				endcase
			end

		WRITE:
			begin
				//Debouncing the input
				main_count=main_count+1;
				if(main_count==DEBOUNCER_CLOCK)
				begin
					debouncer1=(debouncer1<<1)+dig1;
					debouncer2=(debouncer2<<1)+dig2;
					debouncer3=(debouncer3<<1)+dig3;
					debouncer4=(debouncer4<<1)+dig4;

					//Setting to take in values
					if(location_state==RESET)
						location_state=OPERATOR;

					if(debouncer4==DEBOUNCER_CONSTANT)
					begin
						location_state=location_state+1;
						if(location_state>=4)
						begin
							//Logic for sign
							if(sign_1==0)
								temp_display1 = 9'd256-{di3,di2};
							else
								temp_display1={di3,di2};

							if(sign_2==0)
								temp_display2 = 9'd256-{di5,di4};
							else
								temp_display2={di5,di4};

							//Storing the address on the basis of the of the address
							memory[address]={8'd0,temp_display2,temp_display1,4'd0,di1};
							address_read=0;
							location_state=RESET;
						end
					end
					else
					begin
						//For operators
						if (location_state==OPERATOR)
						begin
							if(debouncer1==DEBOUNCER_CONSTANT)
							begin
								if(rev==0)//Going reverse
									di1=(di1+1)%4;
								else
									di1=(di1-1)%4;
							end
						end
						else if(location_state==OPERAND1)
						begin
							sign_1=sign;
							if(debouncer1==DEBOUNCER_CONSTANT)
							begin
								if(rev==0)//Going reverse
									di2=(di2+1)%16;
								else
									di2=(di2-1)%16;
							end

							if(debouncer2==DEBOUNCER_CONSTANT)
							begin
								sign_1=sign;
								if(rev==0)//Going Reverse
									di3=(di3+1)%8;
								else
									di3=(di3-1)%8;
							end
						end
						else if(location_state==OPERAND2)
						begin
							if(debouncer1==DEBOUNCER_CONSTANT)
							begin
								sign_2=sign;
								if(rev==0)//Going reverse
									di4=(di4+1)%16;
								else
									di4=(di4-1)%16;
							end

							if(debouncer2==DEBOUNCER_CONSTANT)
							begin
								sign_2=sign;
								if(rev==0)//Going Reverse
									di5=(di5+1)%8;
								else
									di5=(di5-1)%8;
							end
						end
					end

					main_count=0;
					//To indicate the value being stored
					if(location_state==OPERATOR)
					begin
						b4=7'b1100010; //o
						b3=7'b0011000; //P
						b2=7'b1111111; //
						b1=bcd_operator(di1);
					end
					else if (location_state==OPERAND1)
					begin
						b4=7'b1001111; //1

						//Sign Bit
						if(sign)
							b3=7'b1111111; //+
						else
							b3=7'b1111110; //-
						b2=bcd_number(di3);
						b1=bcd_number(di2);

					end
					else if (location_state==OPERAND2)
					begin
						b4=7'b0010010; //2

						//Sign Bit
						if(sign)
							b3=7'b1111111; //+
						else
							b3=7'b1111110; //-
						b2=bcd_number(di5);
						b1=bcd_number(di4);
					end
					else
					begin
						b4=7'b1111110; //-
						b3=7'b1111110; //-
						b2=7'b1111110; //-
						b1=7'b1111110; //-
					end
				end
			end

		DISPLAY:
			begin
				main_count=main_count+1;
				if(main_count==DEBOUNCER_CLOCK)
				begin
					debouncer1=(debouncer1<<1)+dig1;
					debouncer2=(debouncer2<<1)+dig2;
					debouncer3=(debouncer3<<1)+dig3;
					debouncer4=(debouncer4<<1)+dig4;

					//Exiting the display menu
					if(debouncer4==DEBOUNCER_CONSTANT)
					begin
						address_read=0;
						location_state=RESET;
					end
					else
					begin
						//Displaying the operator
						if(debouncer1==DEBOUNCER_CONSTANT)
							location_state=OPERATOR;

						//Displaying the operand1
						if(debouncer2==DEBOUNCER_CONSTANT)
							location_state=OPERAND1;

						//Displaying operand2
						if(debouncer3==DEBOUNCER_CONSTANT)
							location_state=OPERAND2;
					end

					main_count=0;
					temp_register=memory[address];
					if(location_state==OPERATOR)
					begin
						b4=7'b1100010; //o
						b3=7'b0011000; //P
						b2=7'b1111111; //
						b1=bcd_operator(temp_register[3:0]);
					end
					else if (location_state==OPERAND1)
					begin
						temp_value=absolute_value(temp_register[15:8]);
						b4=7'b1001111; //1

						//Sign of the number
						if(temp_value!=temp_register[15:8])
							b3=7'b1111110; //-
						else
							b3=7'b1111111; //

						b2=bcd_number(temp_value[7:4]);
						b1=bcd_number(temp_value[3:0]);
					end
					else if (location_state==OPERAND2)
					begin
						temp_value=absolute_value(temp_register[23:16]);
						b4=7'b0010010; //2

						//Sign of the number
						if(temp_value!=temp_register[23:16])
							b3=7'b1111110; //-
						else
							b3=7'b1111111; //

						b2=bcd_number(temp_value[7:4]);
						b1=bcd_number(temp_value[3:0]);
					end
					else
					begin
						b4=7'b1000010;	//d
						b3=7'b1001111;	//I
						b2=7'b0100100;	//S
						b1=7'b0011000;	//P
					end
				end
			end
	endcase
end

//Performing the different Computations
ripple_cla RIPPLE_CLA1(.c_in(0), .c_out(temp_c_add), .A(temp_register[15:8]), .B(temp_register[23:16]), .Output(add_output));
ripple_cla RIPPLE_CLA2(.c_in(1), .c_out(temp_c_sub), .A(temp_register[15:8]), .B(temp_register[23:16]), .Output(sub_output));
booth_multiplier BOOTH(.clk(clk), .A(temp_register[15:8]), .B(temp_register[23:16]), .en(mul_en), .Output(mul_output));

//Display Block
display_module DISPLAY1(.clk(clk), .b1(b1), .b2(b2), .b3(b3), .b4(b4), .output_bcd(bcd), .output_o1(o1), .output_o2(o2), .output_o3(o3), .output_o4(o4));
endmodule
