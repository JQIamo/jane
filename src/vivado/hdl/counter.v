`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2018 04:26:19 PM
// Design Name: 
// Module Name: counter
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


module counter #(parameter WIDTH = 128)(
    input clk,
    input reset,
    input enable,
    output reg [WIDTH-1:0] count = 0
    );
  
    always @(posedge clk)
    begin
        if (reset == 1) count = 0;
        else if (enable == 1) count = count + 1;
        else count = count;
    end
    
  
endmodule
