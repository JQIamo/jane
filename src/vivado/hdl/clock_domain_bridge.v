`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Alessandro Restelli
// 
// Create Date: 10/15/2020 03:32:17 PM
// Design Name: 
// Module Name: clock_domain_bridge
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


module clock_domain_bridge(
                            clk_a,
                            clk_b,
                            a,
                            b
    );

//Asynchronous transfer of a register between clock domains
//  a ==> b

//This is useful when a process wants to monitor with fidelity the value of some register in another process. 
//The goal is not speed here but data integrity and the process must be able to work across very different clock domains.
//Also it is not guaranteed that some data is skipped or oversampled. What counts is that the value of the register passes through.



parameter DATA_WIDTH = 8;    

input  clk_a,
       clk_b;

input  [DATA_WIDTH-1:0] a;
output reg [DATA_WIDTH-1:0] b;


reg acquired = 1'b0;
reg valid = 1'b0;

reg [DATA_WIDTH-1:0] stable_data = 0; 



always @(posedge clk_a)
begin
    if (valid == 1'b0)
    begin
        stable_data <= a;
        valid <= 1'b1;
    end
    else
    begin
        if (acquired)
        begin
            valid <= 1'b0;
        end  
    end
end


always @(posedge clk_b)
begin
    if (valid)
    begin
        b <= stable_data;
        acquired <= 1'b1;
    end
    else acquired <= 1'b0;
end

endmodule
