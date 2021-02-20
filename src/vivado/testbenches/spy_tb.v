`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2018 12:56:55 PM
// Design Name: 
// Module Name: spy_tb
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


module spy_tb();

reg clk_tb = 0;
reg start_tb = 0;
reg trigger_tb = 0;
reg reset_tb = 0;
reg [23:0] flg_tb = 0;
reg [3:0] op_code_tb;
reg [19:0] data_tb;
reg [31:0] time_arg_tb;

wire [23:0] channels_tb;
wire [4:0] status_tb;
wire [14:0] mem_addr_tb;
wire out_clk_tb;
wire output_led_tb;




reg [79:0] memory_tb [0:9] = {{24'b111111111111111111111111,4'd0,20'd0,32'd7},
                               {24'b000000000000000000000001,4'd0,20'd0,32'd1},
                               {24'b000000000000000000000000,4'd0,20'd0,32'd2},
                               {24'b000000000000000000000000,4'd2,20'd3,32'd5},
                               {24'b000000000000000000000001,4'd0,20'd0,32'd5},
                               {24'b000000000000000000000111,4'd3,20'd3,32'd1},
                               {24'b000000000000000000000000,4'd0,20'd0,32'd5},
                               {24'b000000000000000000000010,4'd0,20'd0,32'd5},
                               {24'b000000000000000000000001,4'd0,20'd0,32'd1},
                               {24'b000000000000000000000000,4'd1,20'd0,32'd1}
                              };


initial begin
input_vector_tb <= memory_tb[0];
#1 reset_tb = 1;
#1 reset_tb = 0;
#20 start_tb = 1;
#2000 start_tb = 0;




end

always
begin
#5 clk_tb = 1;
input_vector_tb <= memory_tb[mem_addr_tb];
#5 clk_tb = 0;
// {flg_tb, op_code_tb, data_tb, time_arg_tb} <= memory_tb[mem_addr_tb];
end



spy spy1(
    .clk(clk_tb),
    .buttons(buttons_tb),
    .input_vector(input_vector_tb),
    .output_led(output_led_tb),
    .out_clk(out_clk_tb),
    .mem_address(mem_addr_tb)
    );


endmodule
