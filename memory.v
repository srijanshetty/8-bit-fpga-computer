module memory(
   input en,                        // Enable
   input read,                      // For read mode
   input write,                     // For write mode
   input [6:0] address,             // The address of the RAM location
   input [7:0] input_data,          // The data to be writen
   output [7:0] output_data         // The read data
);

    //The RAM
    reg [7:0] RAM[0:127];

    //Other needed registers
    reg [7:0] output_buffer;        //Buffer for storing the output

    //Copying the buffer
    assign output_data=output_buffer;

    //Reading and writing data
    always @(*) begin
        if(en==1) begin
          if(read==1 & write==0) begin
              output_buffer=RAM[address];
              $display("time=%4d\tMemory Module Read:\tRAM[%d]=%d", $time, address,RAM[address]);
          end
          if(write==1 & read==0) begin
              RAM[address]=input_data;
              $display("time=%4d\tMemory Module Write:\tRAM[%d]=%d", $time, address,RAM[address]);
          end
        end
        else
          output_buffer=8'dx;
    end

endmodule
