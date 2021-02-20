`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2018 12:31:40 PM
// Design Name: 
// Module Name: spy
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


module spy(
    input clk,
    input [3:0] buttons,
    input [127:0] input_vector,
    output [3:0] output_led,
    output out_clk,
    output reg [14:0]mem_address=0
    );
wire [3:0]buffered_buttons;
reg [16:0] sel=0;
genvar n;

generate
for (n=0;n<4;n=n+1)
begin
    anti_bounce bc(.clk(clk),
                          .input_button(buttons[n]),
                          .filtered_out(buffered_buttons[n]));
end
endgenerate
assign out_clk = clk;

always @(posedge clk)
begin
    if (buffered_buttons[0]==1)
            mem_address=mem_address+1;
    else if (buffered_buttons[1] == 1)
            mem_address=mem_address-1;
end


assign viewer_clk=(buffered_buttons[2]||buffered_buttons[3]);

always @(posedge clk)
begin
    if (buffered_buttons[2]==1)
        begin 
            sel<=sel-1;
        end
    else if (buffered_buttons[3] == 1)
        begin
            sel<=sel+1;

        end
end


assign output_led= input_vector [4*sel+:4];
    
    
    
endmodule



module anti_bounce(
    input clk,
    input input_button,
    output reg filtered_out = 0
    );
 
 parameter MAX_TIME=1000000;
    
 reg [$clog2(MAX_TIME):0] counter=0;
 reg button_pressed=0;
 always @(posedge clk)  
    begin
        if ((counter>0))            //When the counter is running it prevents anything else happen
                                    
            begin
                counter<=counter-1;
                filtered_out<=1'b0; //comment this line to have a continuous output rather than a 
                                    //single pulse on rising edge.
            end
       
       
        else if ((input_button==1'b0)&&(button_pressed==1'b1))  //if the button is NOT pressed after
                                                                //exiting from the "counter" loop
                                                                //it flags the state of the button as NOT pressed
            begin
                counter<=MAX_TIME;
                filtered_out<=1'b0;
                button_pressed<=1'b0;
            end 
       
       
        else if ((input_button==1'b1)&&(button_pressed==1'b0))  //if input_button is pressed and has been released
                                                                //before
            begin
                filtered_out<=1'b1; 
                counter<=MAX_TIME;
                button_pressed<=1'b1;
            end
           
    end

            
     

//the following statements can be used for simulation 
//always
//begin
//#5 force clk=1'b0;
//#5 force clk=1'b1; 
//end

    
endmodule
