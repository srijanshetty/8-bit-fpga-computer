module memory(
   input clk,
   input en,                        // Enable
   input read,                      // For read mode
   input write,                     // For write mode
   input [7:0] address,             // The address of the RAM location
   input [7:0] input_data,          // The data to be writen
   output [7:0] output_data,        // The read data
   output ready                     // Ready Signal
);
    // For simulation only
    initial begin
      #1 ready=0; count=0;
      #1 RAM[0]=8'd1; RAM[1]=8'd5; RAM[2]=0; RAM[3]=0; RAM[4]=0; RAM[5]=0; RAM[6]=0; RAM[7]=0; RAM[8]=0; RAM[9]=0; RAM[10]=0; RAM[11]=0; RAM[12]=0; RAM[13]=0; RAM[14]=0; RAM[15]=0; RAM[16]=0; RAM[17]=0; RAM[18]=0; RAM[19]=0; RAM[20]=0; RAM[21]=0; RAM[22]=0; RAM[23]=0; RAM[24]=0; RAM[25]=0; RAM[26]=0; RAM[27]=0; RAM[28]=0; RAM[29]=0; RAM[30]=0; RAM[31]=0; RAM[32]=0; RAM[33]={LOADi,R3,2'b00}; RAM[34]={LOAD,4'b0001}; RAM[35]={MOVE,R3,R0}; RAM[36]={LOADi,R1,2'b01}; RAM[37]={ADD,R1,R3}; RAM[38]=0; RAM[39]=0; RAM[40]=0; RAM[41]=0; RAM[42]=0; RAM[43]=0; RAM[44]=0; RAM[45]=0; RAM[46]=0; RAM[47]=0; RAM[48]=0; RAM[49]=0; RAM[50]=0; RAM[51]=0; RAM[52]=0; RAM[53]=0; RAM[54]=0; RAM[55]=0; RAM[56]=0; RAM[57]={BGEZ0,4'b1100}; RAM[58]=0; RAM[59]=0; RAM[60]=0; RAM[61]=0; RAM[62]=0; RAM[63]=0; RAM[64]=0; RAM[65]=0; RAM[66]=0; RAM[67]=0; RAM[68]=0; RAM[69]=0; RAM[70]=0; RAM[71]=0; RAM[72]=0; RAM[73]=0; RAM[74]=0; RAM[75]=0; RAM[76]=0; RAM[77]=0; RAM[78]=0; RAM[79]=0; RAM[80]=0; RAM[81]=0; RAM[82]=0; RAM[83]=0; RAM[84]=0; RAM[85]=0; RAM[86]=0; RAM[87]=0; RAM[88]=0; RAM[89]=0; RAM[91]=0; RAM[92]=0; RAM[93]=0; RAM[94]=0; RAM[95]=0; RAM[96]=0; RAM[97]=0; RAM[98]=0; RAM[99]=0; RAM[100]=0; RAM[101]=0; RAM[102]=0; RAM[103]=0; RAM[104]=0; RAM[105]=0; RAM[106]=0; RAM[107]=0; RAM[108]=0; RAM[109]=0; RAM[110]=0; RAM[111]=0; RAM[112]=0; RAM[113]=0; RAM[114]=0; RAM[115]=0; RAM[116]=0; RAM[117]=0; RAM[118]=0; RAM[119]=0; RAM[120]=0; RAM[121]=0; RAM[122]=0; RAM[123]=0; RAM[124]=0; RAM[125]=0; RAM[126]=0; RAM[127]=0;
    end

    // To load a value add it to the segment register two bits and then to the load 4bits

    // Constants
    // The registers
    localparam R0=2'd0;
    localparam R1=2'd1;
    localparam R2=2'd2;
    localparam R3=2'd3;

    // Instruction Set
    localparam NOP=4'b0000;
    localparam ADD=4'b0001;
    localparam ADDi=4'b0010;
    localparam SUB=4'b0011;
    localparam MUL=4'b0100;
    localparam NEG=4'b0110;
    localparam BGEZ0=4'b1000;
    localparam BGEZ1=4'b1001;
    localparam MOVE=4'b1010;
    localparam STORE=4'b1011;
    localparam LOAD=4'b1100;
    localparam LOADi=4'b1101;
    localparam JUMP=4'b1110;
    localparam IN=4'b0001;
    localparam OUT=4'b0010;
    localparam SLEEP=4'b0011;
    localparam HALT=4'b1111;

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
        // $display("Memory Module:\ten=%d\tread=%d\twrite=%d\tRAM[%d]=%b\tready=%b",en,read,write,address,RAM[address],ready);
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
      // RAM[0]=0;
      // RAM[1]=0;
      // RAM[2]=0;
      // RAM[3]=0;
      // RAM[4]=0;
      // RAM[5]=0;
      // RAM[6]=0;
      // RAM[7]=8'd32;
      // RAM[8]=0;
      // RAM[9]=0;
      // RAM[10]=0;
      // RAM[11]=0;
      // RAM[12]={MOVE,R2,R3};
      // RAM[13]={BGEZ1,4'b1100};
      // RAM[14]=0;
      // RAM[15]=0;
      // RAM[16]=0;
      // RAM[17]=0;
      // RAM[18]=0;
      // RAM[19]=0;
      // RAM[20]=0;
      // RAM[21]=0;
      // RAM[22]=0;
      // RAM[23]=0;
      // RAM[24]={NOP,SLEEP};
      // RAM[25]=0;
      // RAM[26]=0;
      // RAM[27]=0;
      // RAM[28]=0;
      // RAM[29]=0;
      // RAM[30]=0;
      // RAM[31]=0;
      // RAM[32]=0;
      // RAM[33]={LOADi,R3,2'b00};
      // RAM[34]={LOAD,4'b0111};
      // RAM[35]={STORE,R3,R1};
      // RAM[36]={LOADi,R3,2'b00};
      // RAM[37]={LOAD,4'b0000};
      // RAM[38]={JUMP,R2,2'b00};
      // RAM[39]=0;
      // RAM[40]={LOAD,4'b0111};
      // RAM[41]=0;
      // RAM[42]=0;
      // RAM[43]=0;
      // RAM[44]=0;
      // RAM[45]=0;
      // RAM[46]=0;
      // RAM[47]=0;
      // RAM[48]=0;
      // RAM[49]=0;
      // RAM[50]=0;
      // RAM[51]=0;
      // RAM[52]=0;
      // RAM[53]=0;
      // RAM[54]=0;
      // RAM[55]=0;
      // RAM[56]={BGEZ0,4'b1100};
      // RAM[57]=0;
      // RAM[58]=0;
      // RAM[59]=0;
      // RAM[60]=0;
      // RAM[61]=0;
      // RAM[62]=0;
      // RAM[63]=0;
      // RAM[64]=0;
      // RAM[65]=0;
      // RAM[66]=0;
      // RAM[67]=0;
      // RAM[68]=0;
      // RAM[69]=0;
      // RAM[70]=0;
      // RAM[71]=0;
      // RAM[72]=0;
      // RAM[73]=0;
      // RAM[74]=0;
      // RAM[75]=0;
      // RAM[76]=0;
      // RAM[77]=0;
      // RAM[78]=0;
      // RAM[79]=0;
      // RAM[80]=0;
      // RAM[81]=0;
      // RAM[82]=0;
      // RAM[83]=0;
      // RAM[84]=0;
      // RAM[85]=0;
      // RAM[86]=0;
      // RAM[87]=0;
      // RAM[88]=0;
      // RAM[89]=0;
      // RAM[91]=0;
      // RAM[92]=0;
      // RAM[93]=0;
      // RAM[94]=0;
      // RAM[95]=0;
      // RAM[96]=0;
      // RAM[97]=0;
      // RAM[98]=0;
      // RAM[99]=0;
      // RAM[100]=0;
      // RAM[101]=0;
      // RAM[102]=0;
      // RAM[103]=0;
      // RAM[104]=0;
      // RAM[105]=0;
      // RAM[106]=0;
      // RAM[107]=0;
      // RAM[108]=0;
      // RAM[109]=0;
      // RAM[110]=0;
      // RAM[111]=0;
      // RAM[112]=0;
      // RAM[113]=0;
      // RAM[114]=0;
      // RAM[115]=0;
      // RAM[116]=0;
      // RAM[117]=0;
      // RAM[118]=0;
      // RAM[119]=0;
      // RAM[120]=0;
      // RAM[121]=0;
      // RAM[122]=0;
      // RAM[123]=0;
      // RAM[124]=0;
      // RAM[125]=0;
      // RAM[126]=0;
      // RAM[127]=0;

endmodule
