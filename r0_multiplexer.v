// module for multiplexing r0
module r0_multiplexer (
   input clk,                                               // Clock
   input en,                                                // Clock Enable
   input [1:0] state,                                       // Multiplexer State
   input [7:0] value1, value2,                              // Input Values
   output [7:0] Output1, Output2,                           // Outputs
   output ready
);
    // For simulation only
    initial begin
        #1 Output1=0; Output2=0; ready=0;
    end

    reg ready;                                              // Ready signal

    // Other variables
    wire c_out_add, c_out_sub;
    wire booth_ready,twos_compliment_ready,ripple_add_ready,ripple_sub_ready;  // Different outputs
    wire [15:0] multiplier_output;
    wire [7:0] add_output, sub_output, complement_output;
    reg [7:0] Output1, Output2;
    reg ripple_add_en, ripple_sub_en, booth_en, twos_compliment_en;

    // Parameters
    localparam ADD=2'd0;
    localparam SUB=2'd1;
    localparam MUL=2'd2;
    localparam NEG=2'd3;

    always @(clk) begin
        if(en==1) begin
            case(state)
                ADD: begin
                        ripple_add_en=1;
                        ripple_sub_en=0;
                        booth_en=0;
                        twos_compliment_en=0;
                        if(ripple_add_ready==1)	begin
                            Output1=add_output;
				            ready=1;
                        end
                        else
                            ready=0;                // Still calculating
                    end
                SUB: begin
                        ripple_add_en=0;
                        ripple_sub_en=1;
                        booth_en=0;
                        twos_compliment_en=0;
                        if(ripple_sub_ready==1) begin
                            Output1=sub_output;
                            ready=1;
                        end
                        else
                            ready=0;//calculating
                        end
                MUL: begin
                        ripple_add_en=0;
                        ripple_sub_en=0;
                        booth_en=1;
                        twos_compliment_en=0;
                        if(booth_ready==1) begin
                            Output1=multiplier_output[15:8];
                            Output2=multiplier_output[7:0];
                            ready=1;
                        end
                        else
                            ready=0;            //calculating
                        end
                NEG: begin
                        ripple_add_en=0;
                        ripple_sub_en=0;
                        booth_en=0;
                        twos_compliment_en=1;
                        if(twos_compliment_ready==1) begin
                            Output1=complement_output;
                            ready=1;
                        end
                        else
                            ready=0;
                    end
            endcase
            // Displaying the important parameters
        end
        $display("R0 MULTIPLEXER:\tstate=%d\tenable=%d\tvalue1=%d\tvalue2=%d\tOutput1=%d\tOutput2=%d\tready=%d", state, en,value1,value2,Output1,Output2,multiplier_output,ready);
    end

    // Adder
    ripple_cla8 CLA_add(
	    .clk(clk),
        .en(ripple_add_en),
        .c_in(0),
        .A(value1), .B(value2),
        .Output(add_output),
        .c_out(c_out_add),
	    .ready(ripple_add_ready)
    );

    // Subtractor
    ripple_cla8 CLA_sub(
	    .clk(clk),
        .en(ripple_sub_en),
        .c_in(1),
        .A(value1), .B(value2),
        .Output(sub_output),
        .c_out(c_out_sub),
        .ready(ripple_sub_ready)
    );

    // // Multiplier
    // booth_multiplier Booth(
    //     .clk(clk),
        // .en(booth_en),
    //     .A(value1),.B(value2),
    //     .Output(multiplier_output),.ready(booth_ready)
    // );

    // Compliment
    twos_compliment Compliment(
        .clk(clk),
        .en(twos_compliment_en),
        .A(value1),
        .Output(complement_output),
        .ready(twos_compliment_ready)
    );
endmodule
