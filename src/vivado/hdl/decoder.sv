`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Ananya Sitaram
//
// Create Date: 07/30/2018 03:40:12 PM
// Design Name:
// Module Name: decoder
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


module decoder(
    clk, // input
    run, // input
    trigger, // input
    reset, // input
    flg, // input
    op_code, // input
    data, // input
    time_arg, // input
    channels, // output
    status, // output
    mem_addr, // output
    start_monitor //output
    );

parameter ADDR_SIZE = 16;
input clk;
input run;
input trigger;
input reset;
input [63:0] flg;
input [3:0] op_code;
input [19:0] data;
input [31:0] time_arg;
output reg [63:0] channels = 0;
output reg [3:0] status;
output reg [ADDR_SIZE-1:0] mem_addr = 0;
output start_monitor;
reg [63:0] chn_prefetch = 0;
reg [ADDR_SIZE-1:0] next_addr;
reg [51:0] count = 0;
reg [19:0] loop = 0;
reg [19:0] loop_max = 0;
reg im_in_loop = 1'b0;
reg [19:0] sub_routine;
reg [51:0] delay;
reg [19:0] argument = 0;
reg trigger_registered = 1'b0;

wire [51:0] next_delay;
wire start;

assign start_monitor = start;

//    parameter CONT = 4'd0;
//    parameter STOP = 4'd1;
//    parameter LOOP = 4'd2;
//    parameter END_LOOP = 4'd3;
//    parameter JSR = 4'd4;
//    parameter RTS = 4'd5;
//    parameter BRANCH = 4'd6;
//    parameter LONG_DELAY = 4'd7;
//    parameter WAITOP = 4'd8;
//    reg [3:0] state = STOP;

    // The following contains SystemVerilog constructs and should not be used if using a tool that does not support this standard

       typedef enum logic [3:0] {CONT = 4'b0000,
                         STOP = 4'b0001,
                         LOOP = 4'b0010,
                         END_LOOP = 4'b0011,
                         JSR = 4'b0100,
                         RTS = 4'b0101,
                         BRANCH = 4'b0110,
                         LONG_DELAY = 4'b0111,
                         WAITOP = 4'b1000} statetype;
       statetype state = STOP;
       statetype op_code_tbl [0:8] =  {CONT, STOP, LOOP, END_LOOP, JSR, RTS, BRANCH, LONG_DELAY, WAITOP};

//      enum logic [3:0] {CONT = 4'b0000,
//                        STOP = 4'b0001,
//                        LOOP = 4'b0010,
//                        END_LOOP = 4'b0011,
//                        JSR = 4'b0100,
//                        RTS = 4'b0101,
//                        BRANCH = 4'b0110,
//                        LONG_DELAY = 4'b0111,
//                        WAITOP = 4'b1000} op_code_tbl = STOP;

reg in_delay;

always @(*)
begin
    if (count < delay) in_delay <= 1'b1;
    else in_delay <= 1'b0; 
end     



       always @(posedge clk)
       begin
          trigger_registered<=trigger;
          if (reset == 1) begin
             state <= STOP;
             mem_addr <= 0;
          end
          else
             case (state)
                CONT : begin
                   // channels <= flg;
                   if (in_delay)
                      begin
                      count <= count + 1;
//                      delay <= next_delay;
                      end
                   else
                      begin
                      channels <= flg;
                      state <= op_code_tbl[op_code];
                      mem_addr <= next_addr;
                      delay <= next_delay;
                      count <= 0;
                      argument <= data;
                      end
                end
                STOP : begin
                   // Decide what to do with the channels
                   if (start == 1)
                      begin
                      channels <= flg;
                      state <= op_code_tbl[op_code];
                      mem_addr <= next_addr;
                      delay <= next_delay;
                      count <= 0;
                      end
                   else
                      state <= STOP;
                end
                LOOP : begin
                   // channels <= flg;
                   if (im_in_loop == 1'b0)
                        begin
                            loop_max <= argument;
                            loop <= 0;
                            im_in_loop <= 1'b1;
                        end    
                   if (in_delay)
                      begin
                        count <= count + 1;
                      end
                   else
                      begin
                      channels <= flg;
                      state <= op_code_tbl[op_code];
                      mem_addr <= next_addr;
                      delay <= next_delay;
                      count <= 0;
                      argument <= data;
                      if (im_in_loop == 1'b1) loop <= loop + 1;
                    end
                end
                END_LOOP : begin
                   if (loop < loop_max)
                         im_in_loop <= 1'b1;
                      else
                         im_in_loop <= 1'b0;
                   if (in_delay)
                      begin
                       count <= count + 1;
                      end
                   else
                      begin
                      channels <= flg;
                      state <= op_code_tbl[op_code];
                      mem_addr <= next_addr;
                      delay <= next_delay;
                      count <= 0;
                      argument <= data;
                      end
                end
                JSR : begin
                   // channels <= flg;
                   if (in_delay)
                      begin
                      count <= count + 1;
                      sub_routine <= data;
                      end
                   else
                      begin
                      channels <= flg;
                      state <= op_code_tbl[op_code];
                      mem_addr <= next_addr;
                      delay <= next_delay;
                      count <= 0;
                      //argument <= data;
                      end
                end
                RTS : begin
                   // channels <= flg;
                   if (in_delay)
                      count <= count + 1;
                   else
                      begin
                      channels <= flg;
                      state <= op_code_tbl[op_code];
                      mem_addr <= next_addr;
                      delay <= next_delay;
                      count <= 0;
                      argument <= data;
                      end
                end
                BRANCH : begin
                   // channels <= flg;
                   if (in_delay)
                      count <= count + 1;
                   else
                      begin
                      channels <= flg;
                      state <= op_code_tbl[op_code];
                      mem_addr <= next_addr;
                      delay <= next_delay;
                      count <= 0;
                      argument <= data;
                      end
                end
                LONG_DELAY : begin
                   // channels <= flg;
                   if (in_delay)
                      count <= count + 1;
                   else
                      begin
                      channels <= flg;
                      state <= op_code_tbl[op_code];
                      mem_addr <= next_addr;
                      delay <= next_delay;
                      count <= 0;
                      argument <= data;
                      end
                end
                WAITOP : begin
                   // Decide what to do with the channels
                   if (trigger_registered == 1)
                      begin
                      channels <= flg;
                      state <= op_code_tbl[op_code];
                      mem_addr <= next_addr;
                      delay <= next_delay;
                      count <= 0;
                      argument <= data;
                      end
                   else
                      state <= WAITOP;
                end

             endcase
       end


always @(*)
begin
case (op_code)
    0: next_addr <= mem_addr + 1;
    1: next_addr <= 0;
    2: next_addr <= mem_addr + 1;
    3: begin
        if (state==LOOP ) next_addr = (loop+1 < loop_max) ? data : (mem_addr + 1);
        else next_addr = (loop < loop_max) ? data : (mem_addr + 1);
    end
    4: next_addr <= data;
    5: next_addr <= sub_routine;
    6: next_addr <= data;
    7: next_addr <= mem_addr + 1;
    8: next_addr <= mem_addr + 1;
endcase

end

always @(*)
begin
    if (reset == 1)
       status <= 2;
    else
    case (state)
    CONT: status <= 4;
    STOP: status <= 1;
    LOOP: status <= 4;
    END_LOOP: status <= 4;
    JSR: status <= 4;
    RTS: status <= 4;
    BRANCH: status <= 4;
    LONG_DELAY: status <= 4;
    WAITOP: status <= 8;
    endcase
end

assign next_delay = (op_code_tbl[op_code] == LONG_DELAY) ? data * time_arg : {20'd0,time_arg};
//assign next_delay = time_arg;

start_shortener shortener(
    .clk(clk),
    .start(run),
    .start_short(start)
    );






//counter #(.WIDTH(32)) delay_timer(
//    .clk(clk),
//    .reset(reset),
//    .enable(start),
//    .count(count)
//    );

endmodule

module start_shortener(
    input clk,
    input start,
    output reg start_short = 0
    );

enum logic [1:0] {IDLE,
            FIRST_CYCLE,
            SEC_CYCLE,
            WAITING} state = IDLE;



always @(posedge clk)
begin
    case (state)
        IDLE: begin
            if (start == 1)
                begin
                start_short <= 1;
                state <= FIRST_CYCLE;
                end
            else
                begin
                start_short <= 0;
                state <= IDLE;
                end
        end
        FIRST_CYCLE: state <= SEC_CYCLE;
        SEC_CYCLE: begin
            state <= WAITING;
            start_short = 0;
        end
        WAITING: begin
            start_short <= 0;
            if (start == 0)
                state <= IDLE;
            else
                state <= WAITING;
        end
    endcase
end


endmodule
    
