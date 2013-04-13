module memory(
   input clk,
   input en,                        // Enable
   input read,                      // For read mode
   input write,                     // For write mode
   input [6:0] address,             // The address of the RAM location
   input [7:0] input_data,          // The data to be writen
   output [7:0] output_data,        // The read data
   output ready                     // Ready Signal
);
    // For simulation only
    initial begin
      #1 ready=0; count=0;
    end

    //The RAM
    reg [7:0] RAM[0:127];

    // Ready Signal
    reg ready;
    reg [3:0] count;

    //Other needed registers
    reg [7:0] output_data;

    // Ready Signal
    always @(posedge clk) begin
      if(en==1 && count!=1) begin   //Actual number of counts taken =1
        ready=0;
        count=count+1;
      end
      else begin
          if(en==1)
            ready=1;
            else begin
                ready=0;
                count=0;
            end
        end
        $display("Memory Module:\tread=%d\twrite=%d\tRAM[%d]=%d", read,write,address,RAM[address]);
      end

    //Reading and writing data
    always @(posedge clk) begin
        if(en==1) begin
          if(read==1 & write==0) begin
              output_data=RAM[address];
          end
          if(write==1 & read==0) begin
              RAM[address]=input_data;
          end
        end
        else
          output_data=8'dx;
    end

endmodule
