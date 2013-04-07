// Multiplexer with four lines for accessing the memory
module memory_controller (
    input clk,                                                              // Clock
    input state,                                                            // Clock Enable
    input en,                                                               // Enable
    input read0,read1,read2,read3,                                          // Read lines
    input write0,write1,write2,write3,                                      // Write lines
    input [6:0] address0,address1,address2,address3,                        // Addresses
    input [7:0] input_data0, input_data1, input_data2,input_data3,          // Input data
    output [7:0] output_data0, output_data1, output_data2, output_data3     // Output data
);

    // For manipulating the memory
    reg memory_en, memory_read, memory_write;
    wire [7:0] data;                                                //The read data
    reg [6:0] address;                                              //The address
    reg [7:0] input_data;
    reg [7:0] data0, data1, data2,data3;

    //Test bench
    initial begin
        #1 memory_en=0; memory_read=0; memory_write=0; address=0; input_data=0; data0=0; data1=0; data2=0; data3=0;
    end

    // Copying data into output data
    assign output_data0=data;
    assign output_data1=data;
    assign output_data2=data;
    assign output_data3=data;

    always @(*)
    begin
        if(en==1) begin
            case (state)
                    2'd0: begin
                            address=address0;
                            input_data=input_data0;
                            if(read0==1 & write0==0) begin
                                memory_en=1;
                                memory_read=1;
                                memory_write=0;
                            end
                            else if (read0==0 & write0==1) begin
                                memory_en=1;
                                memory_read=0;
                                memory_write=1;
                            end
                            data0=data;
                        end
                    2'd1: begin
                            address=address1;
                            input_data=input_data1;
                            if(read1==1 & write1==0) begin
                                memory_en=1;
                                memory_read=1;
                                memory_write=0;
                            end
                            else if (read1==0 & write1==1) begin
                                memory_en=1;
                                memory_read=0;
                                memory_write=1;
                            end
                            data1=data;
                        end
                    2'd2: begin
                            address=address2;
                            input_data=input_data2;
                            if(read2==1 & write2==0) begin
                                memory_en=1;
                                memory_read=1;
                                memory_write=0;
                            end
                            else if (read2==0 & write2==1) begin
                                memory_en=1;
                                memory_read=0;
                                memory_write=1;
                            end
                            data2=data;
                        end
                    2'd3: begin
                            address=address3;
                            input_data=input_data3;
                            if(read3==1 & write3==0) begin
                                memory_en=1;
                                memory_read=1;
                                memory_write=0;
                            end
                            else if (read3==0 & write3==1) begin
                                memory_en=1;
                                memory_read=0;
                                memory_write=1;
                            end
                            data3=data;
                        end
                    default : begin
                                memory_en=0;
                                data0=8'dx;
                                data1=8'dx;
                                data2=8'dx;
                                data3=8'dx;
                            end
             endcase
            // Displaying the important parameters
            $display("time=%4d\tMemory Controller:\tstate=%d\tmemory_en=%d\tmemory_read=%d\tmemory_write=%d\taddress=%d\tinput_data=%d\tdata=%d\t", $time,state, memory_en,memory_read,memory_write,address,input_data,data);
        end
        else begin
            memory_en=0;
            data0=8'dx;
            data1=8'dx;
            data2=8'dx;
            data3=8'dx;
        end
    end

    memory MEM1(.en(memory_en),.read(memory_read),.write(memory_write),.address(address),.input_data(input_data),.output_data(data));
endmodule