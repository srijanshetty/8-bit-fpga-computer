// Module to compute two's compliment
module twos_compliment (
    input clk,
    input en,
    input [7:0] A,  //Input
    output [7:0] Output, //Output
    output ready
);
    // For simulation only
    initial begin
        #1 ready=0; cla_adder_en=0;
    end

    reg ready;                          // Redefining the output as reg
    wire [7:0] temp_output;                 // To store the output temporarily
    reg [7:0] Output;

    //Wires and other control signals
    wire c_out,c_out2;
    wire [7:0] temp_value;
    wire[1:0] temp_ready;
    reg cla_adder_en;

    // For the ready signal
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
        // $display("Two's Compliment:\ten=%d\tA=%d\tOutput=%d\tReady=%d",en,A,Output,ready);
    end

    ones_compliment COMPLIMENT1(
        .A(A),
        .Output(temp_value)
    );

    cla_adder ADDER1(
        .clk(clk),
        .c_in(0),
        .A(temp_value[3:0]), .B(4'd1),
        .en(cla_adder_en),
        .Output(temp_output[3:0]),
        .c_out(c_out),
        .ready(temp_ready[0])
    );

    cla_adder ADDER2(
        .clk(clk),
        .c_in(0),
        .A(temp_value[7:4]), .B({3'd0,c_out}),
        .en(cla_adder_en),
        .Output(temp_output[7:4]),
        .c_out(c_out2),
        .ready(temp_ready[1])
    );
endmodule
