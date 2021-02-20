`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2020 11:38:35 AM
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps

module testbench;
   
  parameter DATA_TO_WRITE = 200000; // For pseudomaster
  parameter PYNCMASTER_DELAY = 100;// For fake pyncmaster
  parameter INSTRUCTIONS = 200000; // For fake pyncmaster
  
// For slave
  parameter LOW_BANK_LIMIT = 65535;
  parameter HIGH_BANK_LIMIT = 131071;
  
  
  parameter BRAM_DEPTH = 64;
  parameter BRAM_WIDTH = 32;
  parameter ADDR_MONITOR_WIDTH = 17;
  parameter integer C_S_AXIS_TDATA_WIDTH  = 32;
  parameter integer C_M_AXIS_TDATA_WIDTH = 32;
  parameter integer C_M_START_COUNT = 4;
  //parameter integer C_S_START_COUNT	= 32;
  
  
  reg M_AXIS_ACLK = 0;
  reg M_AXIS_ARESETN; 
  wire  M_AXIS_TVALID;
  wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA;
  wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB;
  wire M_AXIS_TLAST;
  wire M_AXIS_TREADY;
  
  wire [ADDR_MONITOR_WIDTH-1:0] addr_source;
  
  reg trigger = 1'b0;
  wire start_pyncmaster;
  
  // Memory interface
  wire bram_clk;
  wire bram_en;
  wire [$clog2(BRAM_DEPTH)-1:0] bram_addr;
  wire [BRAM_WIDTH-1:0] bram_din;
  wire [BRAM_WIDTH-1:0] bram_dout;
  wire [0:0] bram_we;
  
  
  always
  begin
  	#5  M_AXIS_ACLK = ~ M_AXIS_ACLK;    
  end
  
  
  initial
  begin
  	//$dumpfile("dump.vcd");$dumpvars;
  #20 M_AXIS_ARESETN = 1'b1; //starting interface
    #200 trigger = 1'b1;// Sending a trigger pulse
  #10 trigger =1'b0;
  
  	//#12000 $display("Done!");
 	//$finish;
  end
 
  //instantiate Master module
  DMA_pseudomaster
  #(
    .BRAM_DEPTH(BRAM_DEPTH),
    .BRAM_WIDTH(BRAM_WIDTH),
    .ADDR_MONITOR_WIDTH(ADDR_MONITOR_WIDTH),
    .DATA_TO_WRITE(DATA_TO_WRITE),
    
    .C_M_AXIS_TDATA_WIDTH(C_M_AXIS_TDATA_WIDTH),
    .C_M_START_COUNT(C_M_START_COUNT)
  ) pseudomaster_instantiation
  (.trigger(trigger),
   
   .M_AXIS_ACLK(M_AXIS_ACLK),
   .M_AXIS_ARESETN(M_AXIS_ARESETN),
   .M_AXIS_TVALID(M_AXIS_TVALID),
   .M_AXIS_TDATA(M_AXIS_TDATA),
   .M_AXIS_TSTRB(M_AXIS_TSTRB),
   .M_AXIS_TLAST(M_AXIS_TLAST),
   .M_AXIS_TREADY(M_AXIS_TREADY)
  );
 
  
  
  DMAcomm_v1_0_S00_AXIS
	#(
      .BRAM_DEPTH(BRAM_DEPTH),
      .BRAM_WIDTH(BRAM_WIDTH),
      .ADDR_MONITOR_WIDTH(ADDR_MONITOR_WIDTH),
      .C_S_AXIS_TDATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
      .LOW_BANK_LIMIT(LOW_BANK_LIMIT),
      .HIGH_BANK_LIMIT(HIGH_BANK_LIMIT)

    )
    my_slave
	(

      .addr_monitor(addr_source),
      .start_pyncmaster(start_pyncmaster),
      .num_words(DATA_TO_WRITE),
      .S_AXIS_ACLK(M_AXIS_ACLK),
      .S_AXIS_ARESETN(M_AXIS_ARESETN),
      .S_AXIS_TVALID(M_AXIS_TVALID),
      .S_AXIS_TDATA(M_AXIS_TDATA),
      .S_AXIS_TSTRB(M_AXIS_TSTRB),
      .S_AXIS_TLAST(M_AXIS_TLAST),
      .S_AXIS_TREADY(M_AXIS_TREADY),
      .bram_clk(bram_clk),
      .bram_addr(bram_addr),
      .bram_din(bram_din),
      .bram_dout(bram_dout),
      .bram_we(bram_we),
      .bram_en(bram_en)
    );
  
  simplified_memory
  	#(
      .BRAM_DEPTH(BRAM_DEPTH),
      .DATA_WIDTH(BRAM_WIDTH)
    )
  
  my_memory
  (
    .clk(bram_clk),
    .addr(bram_addr),
    .din(bram_din),
    .dout(bram_dout),
    .we(bram_we),
    .en(bram_en)
  );

fake_pyncmaster #(
  .INSTRUCTIONS(INSTRUCTIONS),
  .ADDR_SIZE(ADDR_MONITOR_WIDTH),
  .DELAY(PYNCMASTER_DELAY))
  my_fake_pyncmaster
  (.clk(M_AXIS_ACLK),
   .start(start_pyncmaster),
   .address_source(addr_source)
  );

endmodule




module simplified_memory (clk,
                          addr,
                          din,
                          dout,
                          we,
                          en);
  
  parameter DATA_WIDTH = 256;
  parameter BRAM_DEPTH = 262144;
  localparam ADDR_SIZE = $clog2(BRAM_DEPTH - 1);
  input  clk,we,en;
  input  [ADDR_SIZE-1:0] addr;
  input  [DATA_WIDTH-1:0] din;
  output reg [DATA_WIDTH-1:0] dout;
  
  reg [DATA_WIDTH-1:0] memory [0:BRAM_DEPTH-1];
  initial
    begin
      memory[0] = 42;
      memory[1] = 461;
    end
  
  always @(posedge clk)
    begin
      dout=memory[addr];
      if (we) memory[addr]=din;
    end
                      
endmodule


module fake_pyncmaster #(
			parameter INSTRUCTIONS = 30,
			parameter ADDR_SIZE = 15,
			parameter DELAY = 5)
  			(input clk,
   			input start,
            output reg [ADDR_SIZE-1:0] address_source = 0
            );
  
  localparam IDLE = 2'b00;
  localparam WAIT = 2'b01;
  localparam INCREMENT = 2'b11;
  
  reg [1:0] state = IDLE;
  reg [$clog2(DELAY)-1:0] counter = 0;
  reg [$clog2(INSTRUCTIONS)-1:0] current_instruction=0;
  always @(posedge clk)
  begin
    case (state)
      IDLE:begin
        if (start==1'b1)
          state <= WAIT;
        else
          state<=IDLE;
          counter<=0;
          current_instruction<=0;
          address_source<=0;
      end
        
      WAIT:begin
        if(counter<DELAY)
          begin
          counter<=counter+1;
          state<=WAIT;
          end
        else
          begin
            state<=INCREMENT;
            counter<=0;
          end
      end
        
      INCREMENT:begin
        if(current_instruction<INSTRUCTIONS-1)
          begin
          current_instruction<=current_instruction+1;
          address_source<=address_source+1;
          state<=WAIT;
          end
        else
          begin
            state<=IDLE;
            current_instruction<=0;
          end
        
      end
    endcase
    
        
  end
  
  
endmodule

module DMA_pseudomaster # (
        parameter DATA_TO_WRITE = 30,
		parameter BRAM_WIDTH = 32,
		parameter ADDR_MONITOR_WIDTH = 15,

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32
		// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.

    )
    (
  		// Users to add ports here
		input trigger,

		// User ports ends
		// Do not modify the ports beyond this line

		// Global ports
		input wire  M_AXIS_ACLK,
		//
		input wire  M_AXIS_ARESETN,
		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted.
		output reg  M_AXIS_TVALID = 1'b0,
		// TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
      	output reg [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA =  0,
		// TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
		// TLAST indicates the boundary of a packet.
		output reg  M_AXIS_TLAST=1'b0,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire  M_AXIS_TREADY
	);


    localparam IDLE = 2'b00;
	localparam WRITE = 2'b01;
	localparam LAST= 2'b11;

  	reg [31:0] data_counter = 0;

	reg [1:0]state = IDLE;

  //	assign bram_clk = M_AXIS_ACLK;
  //  assign bram_en = 1'b1;

  always @(posedge M_AXIS_ACLK)
	begin
		if(!M_AXIS_ARESETN)
		// Synchronous reset (active low)
		begin
			state <= IDLE;
          	data_counter <= 0;
		end
		else
        begin
			case (state)
				IDLE:
					if (!trigger)
					begin
						state <= IDLE;
                      	data_counter <= 0;
                        M_AXIS_TVALID<=1'b0;
                      	//bram_addr <= 0;
					end
					else
					begin
						state <= WRITE;
                        M_AXIS_TVALID<=1'b1;
					end

				WRITE:begin
                  if (data_counter < DATA_TO_WRITE)
                  begin                    
                    if (M_AXIS_TREADY)
                    begin
                      data_counter<=data_counter+1;
                      M_AXIS_TDATA<=M_AXIS_TDATA+2;
                    end
                    state<=WRITE;
                  end
                  else
                  begin
                    M_AXIS_TLAST<=1'b1;
                    state<=LAST;
                    M_AXIS_TDATA<=M_AXIS_TDATA+2;
                  end
                end
                LAST:begin
                  if (M_AXIS_TREADY==1'b1)
                    begin
                      M_AXIS_TLAST<=1'b0;
                      M_AXIS_TVALID<=1'b0;
                      state<=IDLE;
                    end
                    else
                  	M_AXIS_TLAST<=LAST;
                end
   
            endcase
        end
	end



endmodule 