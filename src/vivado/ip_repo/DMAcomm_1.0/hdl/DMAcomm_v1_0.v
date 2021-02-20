
`timescale 1 ns / 1 ps

	module DMAcomm_v1_0 #
	(
		// Users to add parameters here
		// Common parameters
        parameter BRAM_DEPTH = 262144,
        parameter BRAM_WIDTH = 32,
        parameter ADDR_MONITOR_WIDTH = 18,
        
        // Slave parameters
        parameter [$clog2(BRAM_DEPTH)-1:0] LOW_BANK_LIMIT= 16383,
        parameter [$clog2(BRAM_DEPTH)-1:0] HIGH_BANK_LIMIT = 32767,
        

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S00_AXIS_TDATA_WIDTH	= 32,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M00_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here
    input [ADDR_MONITOR_WIDTH-1:0] addr_monitor,
	output [ADDR_MONITOR_WIDTH-1:0] addr_source,
	
	input trigger,
	input [31:0] num_words,
	input [31:0] num_words_slave,
	
	output start_pyncmaster,

		//memory interface
		(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM CLK" *)
	    output bram_a_clk,
	    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM EN" *)
	    output bram_a_en,
	    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM ADDR" *)
	    output [$clog2(BRAM_DEPTH)-1:0] bram_a_addr,
	    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM DIN" *)
	    output [BRAM_WIDTH-1:0] bram_a_din,
	    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM DOUT" *)
	    input [BRAM_WIDTH-1:0] bram_a_dout,
	    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM WE" *)
	    output [0:0] bram_a_we,


		(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM CLK" *)
	    output bram_b_clk,
	    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM EN" *)
	    output bram_b_en,
	    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM ADDR" *)
	    output [$clog2(BRAM_DEPTH)-1:0] bram_b_addr,
	    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM DIN" *)
	    output [BRAM_WIDTH-1:0] bram_b_din,
	    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM DOUT" *)
	    input [BRAM_WIDTH-1:0] bram_b_dout,
	    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM WE" *)
	    output [0:0] bram_b_we,



		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXIS
		input wire  s00_axis_aclk,
		input wire  s00_axis_aresetn,
		output wire  s00_axis_tready,
		input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
		input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb,
		input wire  s00_axis_tlast,
		input wire  s00_axis_tvalid,

		// Ports of Axi Master Bus Interface M00_AXIS
		input wire  m00_axis_aclk,
		input wire  m00_axis_aresetn,
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
		output wire  m00_axis_tlast,
		input wire  m00_axis_tready
	);

// Instantiation of Axi Bus Interface S00_AXIS
	DMAcomm_v1_0_S00_AXIS # (
		.BRAM_DEPTH(BRAM_DEPTH),
		.BRAM_WIDTH(BRAM_WIDTH),
		.C_S_AXIS_TDATA_WIDTH(C_S00_AXIS_TDATA_WIDTH),
		.ADDR_MONITOR_WIDTH(ADDR_MONITOR_WIDTH),

	    .LOW_BANK_LIMIT(LOW_BANK_LIMIT),
        .HIGH_BANK_LIMIT(HIGH_BANK_LIMIT)
	) 
	DMAcomm_v1_0_S00_AXIS_inst (
	    .addr_monitor(addr_monitor),
        .start_pyncmaster(start_pyncmaster),
        .num_words(num_words),
		.bram_clk(bram_a_clk),
	    .bram_en(bram_a_en),
	    .bram_addr(bram_a_addr),
	    .bram_din(bram_a_din),
	    .bram_dout(bram_a_dout),
	    .bram_we(bram_a_we),


		.S_AXIS_ACLK(s00_axis_aclk),
		.S_AXIS_ARESETN(s00_axis_aresetn),
		.S_AXIS_TREADY(s00_axis_tready),
		.S_AXIS_TDATA(s00_axis_tdata),
		.S_AXIS_TSTRB(s00_axis_tstrb),
		.S_AXIS_TLAST(s00_axis_tlast),
		.S_AXIS_TVALID(s00_axis_tvalid)
	);

// Instantiation of Axi Bus Interface M00_AXIS
	DMAcomm_v1_0_M00_AXIS # (
		.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
		.C_M_START_COUNT(C_M00_AXIS_START_COUNT),
		.BRAM_DEPTH(BRAM_DEPTH),
		.BRAM_WIDTH(BRAM_WIDTH),
		.ADDR_MONITOR_WIDTH(ADDR_MONITOR_WIDTH)
	) 
	DMAcomm_v1_0_M00_AXIS_inst (
		.addr_source(addr_source),
		
		.trigger(trigger),
		.num_words(num_words_slave),

		.bram_clk(bram_b_clk),
	    .bram_en(bram_b_en),
	    .bram_addr(bram_b_addr),
	    .bram_din(bram_b_din),
	    .bram_dout(bram_b_dout),
	    .bram_we(bram_b_we),


		.M_AXIS_ACLK(m00_axis_aclk),
		.M_AXIS_ARESETN(m00_axis_aresetn),
		.M_AXIS_TVALID(m00_axis_tvalid),
		.M_AXIS_TDATA(m00_axis_tdata),
		.M_AXIS_TSTRB(m00_axis_tstrb),
		.M_AXIS_TLAST(m00_axis_tlast),
		.M_AXIS_TREADY(m00_axis_tready)
	);

	// Add user logic here



	// User logic ends

	endmodule
