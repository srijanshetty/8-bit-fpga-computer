module ripple_cla16(
    input clk,
    input c_in,
    input en,
    input [15:0] A, B,
    output [15:0] Output,
    output c_out,
    output ready
);
    // For simulation only
    initial begin
        #1 ready=0; cla_adder_en=0;
    end

    reg ready;                          // Redefine the output ready as reg
    wire [15:0] temp_output;                 // To store the output temporarily
    reg [15:0] Output;

    //Connecting wires
    wire temp1_c,temp2_c,temp3_c;
    wire [15:0] D;
    wire [3:0] temp_ready;
    reg cla_adder_en;

    // Ready signal
    always @(posedge clk) begin
        if(en==1) begin
            cla_adder_en=1;
            if(temp_ready==4'b1111) begin
                ready=1;
                Output=temp_output;
            end
        end
        else begin
            ready=0;
            cla_adder_en=0;
            Output=16'dx;
        end
        // $display("Ripple CLA16:\ten=%d\tA=%d\tB=%d\tOutput=%d\tReady=%d",en,A,B,Output,ready);
    end

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
    cla_adder CLA1(
        .clk(clk),
        .c_in(c_in),
        .c_out(temp1_c),
        .A(A[3:0]),.B(D[3:0]),
        .en(cla_adder_en),
        .Output(temp_output[3:0]),
        .ready(temp_ready[0])
    );

    cla_adder CLA2(
        .clk(clk),
        .c_in(temp1_c),
        .c_out(temp2_c),
        .A(A[7:4]),.B(D[7:4]),
        .en(cla_adder_en),
        .Output(temp_output[7:4]),
        .ready(temp_ready[1])
    );

    cla_adder CLA3(
        .clk(clk),
        .c_in(temp2_c),
        .c_out(temp3_c),
        .A(A[11:8]),.B(D[11:8]),
        .en(cla_adder_en),
        .Output(temp_output[11:8]),
        .ready(temp_ready[2])
    );

    cla_adder CLA4(
        .clk(clk),
        .c_in(temp3_c),
        .c_out(c_out),
        .A(A[15:12]),
        .B(D[15:12]),
        .en(cla_adder_en),
        .Output(temp_output[15:12]),
        .ready(temp_ready[3])
    );
endmodule
