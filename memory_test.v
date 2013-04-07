module test;
    reg en;
    reg read;                      // For read mode
    reg write;                     // For write mode
    reg [6:0] address;                   // The address of the memory location
    reg [7:0] input_data;          // The data to be writen
    wire [7:0] output_data;         // The read data

    initial
    begin
        #2 write=1; read=0; input_data=8'b11111111; address=7'd1;
        #2 en=1;
        #6 en=0;
        #2 read=1; write=0;
        #2 en=1;
        #4 en=0;
        #15 $finish;
    end

    memory MEM1(.en(en),.read(read),.write(write),.address(address),.input_data(input_data),.output_data(output_data));
endmodule