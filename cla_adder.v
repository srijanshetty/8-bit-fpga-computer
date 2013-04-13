module cla_adder(
    input clk,
    input en,
    input [3:0] A, B,
    output [3:0] Output,
    output c_out,
    input c_in,
    output ready
);

    // For computing the temp_ready signal
    reg [16:0] count;
    reg temp_ready;

    assign ready=temp_ready;

    always @(clk) begin
    	if(en==1 && count!=2) begin		//Actual number of counts taken =1
    		temp_ready=0;
    		count=count+1;
    	end
    	else begin
        	if(en==1)
        		temp_ready=1;
            else begin
                temp_ready=0;
                count=0;
            end
        end
        $display("\nCLA Adder: A=%d\tB=%d\tOutput=%d\tc_out=%d\tcount=%d\tready=%d",A,B,Output,c_out,count, temp_ready);
    end

    //The generate and propogate signal
    wire [3:0] prop,gen,carry;
    assign carry[0]=c_in;

    //First Digit
    assign gen[0]=A[0]&B[0];
    assign prop[0]=A[0]|B[0];
    assign carry[1]=(carry[0]&prop[0])|gen[0];
    assign Output[0]=A[0]^B[0]^carry[0];

    //Second Digit
    assign gen[1]=A[1]&B[1];
    assign prop[1]=A[1]|B[1];
    assign carry[2]=(carry[1]&prop[1])|gen[1];
    assign Output[1]=A[1]^B[1]^carry[1];

    //Third Digit
    assign gen[2]=A[2]&B[2];
    assign prop[2]=A[2]|B[2];
    assign carry[3]=(carry[2]&prop[2])|gen[2];
    assign Output[2]=A[2]^B[2]^carry[2];

    //Fourth Digit
    assign gen[3]=A[3]&B[3];
    assign prop[3]=A[3]|B[3];
    assign c_out=(carry[3]&prop[3])|gen[3];
    assign Output[3]=A[3]^B[3]^carry[3];

endmodule
