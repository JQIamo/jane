`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JQI
// Engineer: Alessandro Restelli
// 
// Create Date: 07/22/2020 01:32:34 PM
// Design Name: 
// Module Name: byte_to_word_ram_adapter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Work in progress! The goal is to double the available memory by being smart about switching between banks.
//                      This way instead of a 32k instructions internal bank we will have a 64k instructions bank that will use all the available block ram.
//
//
//
// 
//////////////////////////////////////////////////////////////////////////////////


module byte_to_word_ram_adapter #(parameter WE_SIZE = 1,
                                  parameter BRAM_WIDTH = 32,
                                  parameter BRAM_DEPTH = 65536)
(
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IN EN" *)
  // Uncomment the following to set interface specific parameter on the bus interface.
  //  (* X_INTERFACE_PARAMETER = "MASTER_TYPE <value>,MEM_ECC <value>,MEM_WIDTH <value>,MEM_SIZE <value>,READ_WRITE_MODE <value>" *)
  //(* X_INTERFACE_PARAMETER = "MASTER_TYPE BRAM_CTRL" *)
  input in_en, // Chip Enable Signal (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IN DOUT" *)
  output [BRAM_WIDTH-1:0] in_dout, // Data Out Bus (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IN DIN" *)
  input [BRAM_WIDTH-1:0] in_din, // Data In Bus (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IN WE" *)
  input [WE_SIZE-1:0] in_we, // Byte Enables (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IN ADDR" *)
  input [$clog2(BRAM_DEPTH)+1:0] in_addr, // Address Signal (required)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IN CLK" *)
  input in_clk, // Clock Signal (required)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IN RST" *)
  input in_rst, // Reset Signal (required)

  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 OUT EN" *)
  // Uncomment the following to set interface specific parameter on the bus interface.
  //  (* X_INTERFACE_PARAMETER = "MASTER_TYPE <value>,MEM_ECC <value>,MEM_WIDTH <value>,MEM_SIZE <value>,READ_WRITE_MODE <value>" *)
  //(* X_INTERFACE_PARAMETER = "MASTER_TYPE BRAM_CTRL" *)
  output out_en, // Chip Enable Signal (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 OUT DOUT" *)
  input [BRAM_WIDTH-1:0] out_dout, // Data Out Bus (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 OUT DIN" *)
  output [BRAM_WIDTH-1:0] out_din, // Data In Bus (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 OUT WE" *)
  output reg [0:0] out_we, // Byte Enables (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 OUT ADDR" *)
  output [$clog2(BRAM_DEPTH)-1:0] out_addr, // Address Signal (required)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 OUT CLK" *)
  output out_clk, // Clock Signal (required)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 OUT RST" *)
  output out_rst // Reset Signal (required)
    );
    
    assign out_en = in_en;
    assign in_dout = out_dout;
    assign out_din = in_din;
    //out_we will be special
   
    integer i;
    always @(in_we)
    begin
        out_we = 1'b0;
        for (i=0;i<WE_SIZE;i=i+1)
        begin
            out_we = out_we || in_we[i];
        end
    end
    
    assign out_addr = in_addr [$clog2(BRAM_DEPTH)+1:2];
    assign out_clk = in_clk;
    assign out_rst = in_rst;
endmodule
