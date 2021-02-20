`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2018 12:01:52 PM
// Design Name: 
// Module Name: decoder_wrapper
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


module decoder_wrapper(
    clk, // input
    run, // input
    trigger, // input
    reset, // input 
    mem_input, // input
//    flg, // input
//    op_code, // input
//    data, // input
//    time_arg, // input
    channels, // output
    status, // output
    mem_addr // output 
    );
    
parameter ADDR_SIZE = 15;
input clk;
input run;
input trigger;
input reset;
input [119:0] mem_input;
//input [23:0] flg;
//input [3:0] op_code;
//input [19:0] data;
//input [31:0] time_arg;
output [63:0] channels;
output [3:0] status;
output [ADDR_SIZE-1:0] mem_addr;




decoder #(.ADDR_SIZE(ADDR_SIZE)) inst (
    .clk(clk), // input
    .run(run), // input
    .trigger(trigger), // input
    .reset(reset), // input 
    .flg(mem_input [119:56]), // input
    .op_code(mem_input [55:52]), // input
    .data(mem_input [51:32]), // input
    .time_arg(mem_input [31:0]), // input
    .channels(channels), // output
    .status(status), // output
    .mem_addr(mem_addr) // output 
    );



endmodule
