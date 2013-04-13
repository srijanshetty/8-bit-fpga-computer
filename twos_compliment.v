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
        #1 ready=0;
    end

    reg ready;                          // Redefining the output as reg

    //Wires and other control signals
    wire c_out,c_out2;
    wire [7:0] temp_value;
    wire[1:0] temp_ready;

    // For the ready signal
    always @(clk) begin
        if(temp_ready==2'b11)
            ready=1;
        else
            ready=0;
        // $display("\nTwo's Compliment: A=%d\tOutput=%d\tReady=%d",A,Output,ready);
    end

    ones_compliment COMPLIMENT1(
        .A(A),
        .Output(temp_value)
    );

    cla_adder ADDER1(
        .clk(clk),
        .c_in(0),
        .A(temp_value[3:0]), .B(4'd1),
        .en(1),
        .Output(Output[3:0]),
        .c_out(c_out),
        .ready(temp_ready[0])
    );

    cla_adder ADDER2(
        .clk(clk),
        .c_in(0),
        .A(temp_value[7:4]), .B({3'd0,c_out}),
        .en(1),
        .Output(Output[7:4]),
        .c_out(c_out2),
        .ready(temp_ready[1])
    );
endmodule
