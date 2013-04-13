module ripple_cla8(
    input clk,
    input c_in,
    input [7:0] A, B,
    input en,
    output [7:0] Output,
    output c_out,
    output ready
);

    // For simulation only
    initial begin
        #1 ready=0; cla_adder_en=0;
    end

    reg ready;                              // Redefine the output ready as reg
    wire [7:0] temp_output;                 // To store the output temporarily
    reg [7:0] Output;

    //Connecting wires
    wire temp_c;
    wire [7:0] D;
    wire [1:0] temp_ready;
    reg cla_adder_en;

    // For computing the ready signal
    always @(posedge clk) begin
    	if(en==1) begin
            cla_adder_en=1;
            if(temp_ready==2'b11) begin
    		  ready=1;
              Output=temp_output;
            end
        end
    	else begin
    		ready=0;
            cla_adder_en=0;
            Output=8'dx;
        end
        // $display("Ripple CLA8:\ten=%d\tA=%d\tB=%d\tOutput=%d\tReady=%d",en,A,B,Output,ready);
    end

    //Computing for subtraction
    assign D[0]=B[0]^c_in;
    assign D[1]=B[1]^c_in;
    assign D[2]=B[2]^c_in;
    assign D[3]=B[3]^c_in;
    assign D[4]=B[4]^c_in;
    assign D[5]=B[5]^c_in;
    assign D[6]=B[6]^c_in;
    assign D[7]=B[7]^c_in;

    //Calling other CLA module for computation
    cla_adder CLA1(
        .clk(clk),
        .en(cla_adder_en),
        .c_in(c_in),
        .c_out(temp_c),
        .A(A[3:0]),
        .B(D[3:0]),
        .Output(temp_output[3:0]),
        .ready(temp_ready[0])
    );

    cla_adder CLA2(
        .clk(clk),
        .en(cla_adder_en),
        .c_in(temp_c),
        .c_out(c_out),
        .A(A[7:4]),
        .B(D[7:4]),
        .Output(temp_output[7:4]),
        .ready(temp_ready[1])
    );

endmodule

