`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2020 04:04:35 PM
// Design Name: 
// Module Name: clock_domain_bridge_tb
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


module clock_domain_bridge_tb;

parameter DATA_WIDTH = 16;

reg clk_a = 1'b0;
reg clk_b = 1'b0;

reg  [DATA_WIDTH-1:0] a = 0;
wire [DATA_WIDTH-1:0] b;
 


always
begin
    #6 clk_a<=~clk_a;
    a<=a+1;
    #6 clk_a<=~clk_a;
end

always
begin
    #7 clk_b<=~clk_b;
end







clock_domain_bridge #(.DATA_WIDTH(DATA_WIDTH)
                      ) 
                      dut 
                      ( .clk_a(clk_a),
                        .clk_b(clk_b),
                        .a(a),
                        .b(b));



endmodule
