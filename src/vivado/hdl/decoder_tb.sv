`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2018 05:13:39 PM
// Design Name: 
// Module Name: decoder_tb
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


module decoder_tb;

parameter ADDR_SIZE = 16;

reg clk_tb = 0;
reg start_tb = 0;
reg trigger_tb = 0;
reg reset_tb = 0;
reg [63:0] flg_tb = 0;
reg [3:0] op_code_tb;
reg [19:0] data_tb;
reg [31:0] time_arg_tb;

wire [63:0] channels_tb;
wire [4:0] status_tb;
wire [ADDR_SIZE-1:0] mem_addr_tb;


reg [119:0] memory_tb [0:14] = {{64'b0,4'd0,20'd0,32'd1},//0 for 10 cycles
                               {64'b0,4'd0,20'd0,32'd0}, //0 for 10 cycles
                               {64'b1,4'd2,20'd20,32'd0}, //for i in range (20): 1 for 26 cycles
                               {64'b1,4'd0,20'd0,32'd0},   //         1 for 5
                               {64'b0,4'd3,20'd2,32'd0}, //        0 for 27 cycles
                               {64'b1,4'd2,20'd12,32'd0},//for i in range(12): 1 for 28
                               {64'b0,4'd3,20'd5,32'd0}, //        0 for 29
                               {64'b1,4'd2,20'd2,32'd0},//for i in range (2): 1 for 30 cycles
                               {64'b0,4'd3,20'd7,32'd0},//        0 for 31 cycles
                               {64'b1,4'd2,20'd2,32'd0},//for i in range (2): 1 for 32 cycles
                               {64'b0,4'd3,20'd9,32'd0},//        0 for 33 cycles
                               {64'b1,4'd2,20'd0,32'd0}, //for i in range (1): 1 for 34 cycles
                               {64'b0,4'd3,20'd11,32'd0},//        0 for 35 cycles
                               {64'b0,4'd1,20'd0,32'd0},
                               {64'b0,4'd0,20'd0,32'd0}
                              };

//reg [119:0] memory_tb [0:4] = {{64'b0,4'd0,20'd0,32'd1},
//                               {64'b1,4'd0,20'd0,32'd1},
//                               {64'b0,4'd0,20'd0,32'd1},
//                               {64'b1,4'd0,20'd0,32'd1},
//                               {64'b0,4'd0,20'd0,32'd1}};
                               





//0000000000000000000000000000000000000000000000000000000000000000|0|0|10
//0000000000000000000000000000000000000000000000000000000000000000|0|0|10
//0000000000000000000000000000001000000000000000000000000000000000|1|2|499
//0000000000000000000000000000000000000000000000000000000000000000|2|3|499
//0000000000000000000000000000001000000000000000000000000000000000|999|2|499
//0000000000000000000000000000000000000000000000000000000000000000|4|3|499
//0000000000000000000000000000001000000000000000000000000000000000|1|2|50
//0000000000000000000000000000000000000000000000000000000000000000|6|3|50
//0000000000000000000000000000001000000000000000000000000000000000|1|2|4499999
//0000000000000000000000000000000000000000000000000000000000000000|8|3|4499999
//0000000000000000000000000000001000000000000000000000000000000000|1|2|5
//0000000000000000000000000000000000000000000000000000000000000000|10|3|5
//0000000000000000000000000000000000000000000000000000000000000000|0|1|10


initial begin
{flg_tb, op_code_tb, data_tb, time_arg_tb} <= memory_tb[0];
#5 reset_tb = 1;
#5 reset_tb = 0;
#20 start_tb = 1;
#2000 start_tb = 0;

end


always @ (posedge clk_tb)
begin
#0.1 {flg_tb, op_code_tb, data_tb, time_arg_tb} <= memory_tb[mem_addr_tb];
end


always
begin
#5 clk_tb = 1;
#5 clk_tb = 0;


// {flg_tb, op_code_tb, data_tb, time_arg_tb} <= memory_tb[mem_addr_tb];
end
decoder #(.ADDR_SIZE(ADDR_SIZE)) my_decoder (
    .clk(clk_tb), // input
    .run(start_tb), // input
    .trigger(trigger_tb), // input
    .reset(reset_tb), // input 
    .flg(flg_tb), // input
    .op_code(op_code_tb), // input
    .data(data_tb), // input
    .time_arg(time_arg_tb), // input
    .channels(channels_tb), // output
    .status(status_tb), // output
    .mem_addr(mem_addr_tb) // output 
    );  


endmodule
