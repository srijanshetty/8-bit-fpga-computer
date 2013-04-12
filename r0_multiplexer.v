module r0_multiplexer (
   input clk,                                               // Clock
   input en,                                                // Clock Enable
   input [1:0] state,                                       // Multiplexer State
   input [7:0] value1, value2,                              // Input Values
   output [7:0] Output1, Output2,                            // Outputs
   output ready
);
    initial begin
        #1 multiplexer_output1=0; multiplexer_output2=0;
    end

	
    // Other variables
    wire c_out_add, c_out_sub;
    wire booth_ready,twos_compliment_ready,ripple_add_ready,ripple_sub_ready;
    // Different outputs
    wire [15:0] multiplier_output;
    wire [7:0] add_output, sub_output, complement_output;
    reg [7:0] multiplexer_output1, multiplexer_output2;
    reg ready;

    // Parameters
    localparam ADD=2'd0;
    localparam SUB=2'd1;
    localparam MUL=2'd2;
    localparam NEG=2'd3;

    // Linking the Output and multiplexer Output
    assign Output1=multiplexer_output1;
    assign Output2=multiplexer_output2;

    always @(*) begin
        if(en==1) begin
            case(state)
                ADD: begin
			if(ripple_add_ready==1)
			begin
                        	multiplexer_output1=add_output;
				ready=1;
			end
			else
				ready=0;//calculating
                    end
                SUB: begin
			if(ripple_sub_ready==1)
			begin
                        	multiplexer_output1=sub_output;
				ready=1;
			end
			else
				ready=0;//calculating
                    end
                MUL: begin
			if(booth_ready==1)
			begin
                        	multiplexer_output1=multiplier_output[15:8];
                       		multiplexer_output2=multiplier_output[7:0];
				ready=1;
			end
			else
				ready=0;//calculating
                    end
                NEG: begin
                        multiplexer_output1=complement_output;
                    end
            endcase
            // Displaying the important parameters
            $monitor("booth_ready=%d time=%4d\tR0 Multiplier:\tstate=%d\tenable=%d\tvalue1=%d\tvalue2=%d\tmultiplexer_output1=%d\tmuliplexer_output2=%d,m=%d", booth_ready,$time,state, en,value1,value2,multiplexer_output1,multiplexer_output2,multiplier_output);
        end
    end

    // Adder
    ripple_cla CLA_add(
	.en(en),
        .c_in(0),
        .A(value1), .B(value2),
        .Output(add_output),
        .c_out(c_out_add),
	.ready(ripple_add_ready)
    );

    // Subtractor
    ripple_cla CLA_sub(
	.en(en),
        .c_in(1),
        .A(value1), .B(value2),
        .Output(sub_output),
        .c_out(c_out_sub),
	.ready(ripple_sub_ready)
    );

    // Multiplier
    booth_multiplier Booth(
        .clk(clk),
        .en(1),
        .A(value1),.B(value2),
        .Output(multiplier_output),.ready(booth_ready)
    );

    // Compliment
    twos_compliment Compliment(
	.en(en),
        .A(value1),
        .Output(complement_output),
	.ready(twos_compliment_ready)
    );
endmodule
