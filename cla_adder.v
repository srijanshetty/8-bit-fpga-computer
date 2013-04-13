module cla_adder(
    input clk,
    input en,
    input [3:0] A, B,
    output [3:0] Output,
    output c_out,
    input c_in,
    output ready
);
    // For simulation only
    initial begin
        #1 count=4'd0; ready=0;
    end

    reg ready;                          // Redefine the output ready as reg
    reg [3:0] Output;                   // Redefing the output

    // For computing the ready signal
    reg [3:0] count;

    // Ready Signal
    always @(posedge clk) begin
    	if(en==1 && count!=2) begin		//Actual number of counts taken =1
    		ready=0;
    		count=count+1;
    	end
    	else begin
        	if(en==1)
        		ready=1;
            else begin
                ready=0;
                count=0;
                Output=4'dx;
            end
        end
        // $display("CLA Adder:\ten=%d\tA=%d\tB=%d\tOutput=%d\tc_out=%d\tcount=%d\tready=%d",en, A,B,Output,c_out,count, ready);
    end

    //The generate and propogate signal
    wire [3:0] prop,gen,carry;
    assign carry[0]=c_in;

    //First Digit
    assign gen[0]=A[0]&B[0];
    assign prop[0]=A[0]|B[0];
    assign carry[1]=(carry[0]&prop[0])|gen[0];

    //Second Digit
    assign gen[1]=A[1]&B[1];
    assign prop[1]=A[1]|B[1];
    assign carry[2]=(carry[1]&prop[1])|gen[1];

    //Third Digit
    assign gen[2]=A[2]&B[2];
    assign prop[2]=A[2]|B[2];
    assign carry[3]=(carry[2]&prop[2])|gen[2];

    //Fourth Digit
    assign gen[3]=A[3]&B[3];
    assign prop[3]=A[3]|B[3];
    assign c_out=(carry[3]&prop[3])|gen[3];

    always @(posedge clk) begin
        Output[0]=A[0]^B[0]^carry[0];
        Output[1]=A[1]^B[1]^carry[1];
        Output[2]=A[2]^B[2]^carry[2];
        Output[3]=A[3]^B[3]^carry[3];
    end

endmodule
