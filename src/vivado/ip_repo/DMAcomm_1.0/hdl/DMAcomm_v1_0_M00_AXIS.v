`timescale 1 ns / 1 ps
module DMAcomm_v1_0_M00_AXIS # (
        parameter BRAM_DEPTH = 262144,
		parameter BRAM_WIDTH = 32,
		parameter ADDR_MONITOR_WIDTH = 15,

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32,
		// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
		parameter integer C_M_START_COUNT	= 32

    )
    (
  		// Users to add ports here
		input trigger,
      	input [31:0] num_words,

		output [ADDR_MONITOR_WIDTH-1:0] addr_source,


		(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM CLK" *)
		output bram_clk,
		(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM EN" *)
		output bram_en,
		(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM ADDR" *)
		output reg [$clog2(BRAM_DEPTH)-1:0] bram_addr = 0,
		(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM DIN" *)
		output reg [BRAM_WIDTH-1:0] bram_din,
		(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM DOUT" *)
		input [BRAM_WIDTH-1:0] bram_dout,
		(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM WE" *)
		output reg [0:0] bram_we=1'b0,

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
	localparam READ_AND_WAIT = 2'b01;
	localparam WRITE = 2'b10;
	localparam LAST= 2'b11;

  	localparam integer WAIT_COUNT_BITS = $clog2(C_M_START_COUNT-1);
	reg [WAIT_COUNT_BITS-1 : 0] 	count;
  	reg [31:0] data_counter = 0;

	reg [1:0]state = IDLE;

  	assign bram_clk = M_AXIS_ACLK;
    assign bram_en = 1'b1;
    assign M_AXIS_TSTRB =~0;

	always @(posedge M_AXIS_ACLK)
	begin
		if(!M_AXIS_ARESETN)
		// Synchronous reset (active low)
		begin
			state <= IDLE;
			count    <= 0;
          	data_counter <= 0;
		end
		else
        begin
			case (state)
				IDLE:
					if (!trigger)
					begin
						state <= IDLE;
						count <= 0;
                      	data_counter <= 0;
                      	bram_addr <= 0;
					end
					else
					begin
						state <= READ_AND_WAIT;
					end
				READ_AND_WAIT:
                  if (count < C_M_START_COUNT - 1)
					begin
                      	count <= count + 1;
						state <= READ_AND_WAIT;
                      	M_AXIS_TDATA <= bram_dout;
					end
				  else
					begin
						count <= 0;
						M_AXIS_TVALID <= 1'b1;
						state <= WRITE;
                        bram_addr <= bram_addr + 1;
                      	data_counter <= data_counter + 1;
                      if (data_counter < num_words)
                        begin
                        data_counter <= data_counter + 1;
                        M_AXIS_TLAST <= 1'b0;
                        end
                      else
                        begin
                        M_AXIS_TLAST <= 1'b1;
                        end
					end

				WRITE:
					if (M_AXIS_TREADY==1)
					begin
                      	//M_AXIS_TLAST <= 1'b0; //removed
						M_AXIS_TVALID <= 1'b0;
						count <= 0;
                      if (M_AXIS_TLAST == 1)
                        begin
                          M_AXIS_TLAST = 1'b0;
                          state <= IDLE;
                        end
                      else
                        begin
                          state <= READ_AND_WAIT;
                        end
					end
					else
					begin
						state <= WRITE;
						M_AXIS_TVALID <= 1'b1;
					end

            endcase
        end
	end



endmodule
