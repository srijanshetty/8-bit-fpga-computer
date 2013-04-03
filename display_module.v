module display_module (
	input clk, // Clock
	input en, //Enable
  	input [6:0] b1,b2,b3,b4, //For storing the bcd display
  	output output_o1,output_o2,output_o3,output_o4,
  	output [0:6] output_bcd
);

//Required values
reg o1,o2,o3,o4;
reg [0:6] bcd;
reg [63:0] display_count;//Clock counts

//Assigning values to the wires
assign output_o1=o1;
assign output_o2=o2;
assign output_o3=o3;
assign output_o4=o4;
assign output_bcd=bcd;

always @(posedge clk)
begin
	if(en==1)
	begin
		//Counter for the display
		display_count=display_count+1;
		if(display_count%131072<=30000)
		begin
			o1=1;
			o2=1;
			o3=1;
			o4=0;
			bcd=b4;
		end

		else if(display_count%131072>30000 & display_count%131072<=60000)
		begin
			o1=1;
			o2=1;
			o3=0;
			o4=1;
			bcd=b3;
		end

		else if(display_count%131072>60000 & display_count%131072<=90000 )
		begin
			o1=1;
			o2=0;
			o3=1;
			o4=1;
			bcd=b2;
		end

		else if(display_count%131072>90000 & display_count%131072<=120000 )
		begin
			o1=0;
			o2=1;
			o3=1;
			o4=1;
			bcd=b1;
		end

		//Reset the display_count on 120000 ticks
		else if(display_count==120000)
		begin
			display_count=0;
		end
	end
	else
	begin
		o1=1;
		o2=1;
		o3=1;
		o4=1;
	end
end
endmodule