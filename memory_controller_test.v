// A test bench for the memory controller multiplexer
module memory_controller_test;

    // Registers
    reg clk;
    reg en;
    reg [1:0] state;                                                    // Clock Enable
    reg read0,read1,read2,read3;                                        // Read lines
    reg write0,write1,write2,write3;                                    // Write lines
    reg [6:0] address0,address1,address2,address3;                      // Addresses
    reg [7:0] input_data0, input_data1, input_data2,input_data3;        // Input data
    wire [7:0] output_data0, output_data1, output_data2, output_data3;  // Output data

    // Monitoring the output
    always begin
        #1 $display("\ntime=%8d\ten=%d\tclk=%d",$time,en,clk);
    end

    // Initialize varibles
    initial begin
        #1 en=1; state=5; clk=0; read0=0; write0=0; address0=0; input_data0=0; read1=0; write1=0; address1=0; input_data1=0; read2=0; write2=0; address2=0; input_data2=0; read3=0; write3=0; address3=0; input_data3=0;
        #1 state=0; address0=7'd10;write0=1;input_data0=10;
        #5 write0=0;
        #5 state=1; read1=1; address1=7'd10;
        #5 en=0;
        #5 $finish;
    end

    // Some module
    memory_controller MC1(
        .clk(clk),
        .state(state),
        .en(en),
        .read0(read0),.read1(read1),.read2(read2),.read3(read3),
        .write0(write0),.write1(write1),.write2(write2),.write3(write3),
        .address0(address0),.address1(address1),.address2(address2),.address3(address3),
        .input_data0(input_data0), .input_data1(input_data1), .input_data2(input_data2),.input_data3(input_data3),
        .output_data0(output_data0), .output_data1(output_data1), .output_data2(output_data2), .output_data3(output_data3)
    );

    //For the clock
    always begin
        #1 clk=!clk;
    end
endmodule
