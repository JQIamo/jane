`timescale 1 ns / 1 ps

	module DMAcomm_v1_0_S00_AXIS #
	(
		// Users to add parameters here

		parameter BRAM_DEPTH = 262144,
        parameter BRAM_WIDTH = 32,
        parameter ADDR_MONITOR_WIDTH = 15,

        parameter [$clog2(BRAM_DEPTH)-1:0] LOW_BANK_LIMIT= 16383,
        parameter [$clog2(BRAM_DEPTH)-1:0] HIGH_BANK_LIMIT = 32767,

		// User parameters ends
		// Do not modify the parameters beyond this line

		// AXI4Stream sink: Data Width
		parameter integer C_S_AXIS_TDATA_WIDTH	= 32
	)
	(
		// Users to add ports here

	input [ADDR_MONITOR_WIDTH-1:0] addr_monitor,
	input [31:0] num_words,

	output reg start_pyncmaster = 1'b0,

	(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM CLK" *)
    output bram_clk,
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM EN" *)
    output reg bram_en = 1'b1,
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM ADDR" *)
    output [$clog2(BRAM_DEPTH)-1:0] bram_addr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM DIN" *)
    output reg [BRAM_WIDTH-1:0] bram_din,
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM DOUT" *)
    input [BRAM_WIDTH-1:0] bram_dout,
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CT_RAM WE" *)
    output reg [0:0] bram_we=1'b0,


		// User ports ends
		// Do not modify the ports beyond this line

		// AXI4Stream sink: Clock
		input wire  S_AXIS_ACLK,
		// AXI4Stream sink: Reset
		input wire  S_AXIS_ARESETN,
		// Ready to accept data in
		output wire  S_AXIS_TREADY,
		// Data in
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
		// Byte qualifier
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
		// Indicates boundary of last packet
		input wire  S_AXIS_TLAST,
		// Data is in valid
		input wire  S_AXIS_TVALID
	);
	// function called clogb2 that returns an integer which has the
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

	//The state machine stays in IDLE state, then it writes the entire memory (INITIAL_WRITE)
	//Then it goes back and forth between WAIT and WRITE until it has processed a number of words
	// that corresponds to a page of memory (half the memory)
	
    `define IDLE  2'b00
	`define INITIAL_WRITE  2'b01
	`define WAIT  2'b10
	`define WRITE  2'b11
	
	// State variable
    reg [1:0] state = `IDLE;
	
    reg axis_tready;
	assign S_AXIS_TREADY =  axis_tready;
    	
	//It keep tracks of the bank accessed in the previous clock cycle and in the current
	reg last_bank = 1'b1;
	reg current_bank_accessed;
	
	
	// Pointers for ping-pong memory
	reg [$clog2(BRAM_DEPTH)-1:0] write_pointer;
	reg [$clog2(BRAM_DEPTH)-1:0] write_limit = HIGH_BANK_LIMIT;

	assign bram_addr = write_pointer;
	assign bram_clk = S_AXIS_ACLK;
	reg [$clog2(BRAM_DEPTH)-1:0] high_mem = BRAM_DEPTH;
	
	    
    wire end_of_stream;
    reg word_counter_end;
    reg [31:0] word_counter;
    
    always @( posedge S_AXIS_ACLK )
	begin
	   if (state==`IDLE)
	   begin
	       word_counter_end<=1'b0;
	       word_counter<=0;
	   end
	   else
	   begin
           if (word_counter<num_words)
           begin
               if((state!=`WAIT) & (S_AXIS_TVALID==1'b1)) word_counter<=word_counter+1;
               word_counter_end<=1'b0;
           end
           else
           begin
               word_counter_end<=1'b1;
           end
	   end
	end
    
    assign end_of_stream = word_counter_end;
    
	always @( posedge S_AXIS_ACLK )
	begin
		if (!S_AXIS_ARESETN)
		begin
			state <= `IDLE;
		end
		else
		begin
			case(state)
			`IDLE:begin
				start_pyncmaster <= 1'b0;
				if (S_AXIS_TVALID == 0)
				begin
					state <= `IDLE;
					write_pointer <= 0;
					bram_we <= 0;
				end
				else
				begin
					state <= `INITIAL_WRITE;
					write_pointer <= 0;
                  	bram_din <= S_AXIS_TDATA;
					bram_we <= ~0;
				end
			end
			`INITIAL_WRITE:begin
              if (write_pointer < (HIGH_BANK_LIMIT - 1))
				begin
					if (end_of_stream==1'b1)
					begin
						state <=`IDLE;
						start_pyncmaster <= 1'b1;
					end
					else
					begin
						state <= `INITIAL_WRITE;
					end

					if (S_AXIS_TVALID==1'b1)
					begin
						write_pointer <= write_pointer + 1;
						bram_din <= S_AXIS_TDATA;
					end
				end
              	else
				begin
                  if (S_AXIS_TVALID==1'b1 & end_of_stream == 1'b1)
					begin
                      	state <= `IDLE;
                      	last_bank <= 1'b1;
						write_pointer <= write_pointer + 1;
						bram_din <= S_AXIS_TDATA;
                      	start_pyncmaster <= 1'b1;
					end
                  else if ( S_AXIS_TVALID == 1'b1 & end_of_stream==1'b0)
                    begin
                    state <=`WAIT;
                  	write_pointer <= write_pointer + 1;
                  	bram_din <= S_AXIS_TDATA;
                    start_pyncmaster <= 1'b1;
                    last_bank <= 1'b0; //used to be 0
                    end
				  else
                    begin
					state <= `INITIAL_WRITE;
                    end
				end
			end
			`WAIT:begin
			  start_pyncmaster<=1'b0;
              bram_we <= 0;
				if (current_bank_accessed == last_bank)
				begin
					state <= `WAIT;
				end
				else
				begin
					last_bank <= current_bank_accessed;
                  	bram_we <= 1;
					state <= `WRITE;
					if (current_bank_accessed==0)
					begin
						write_pointer <= LOW_BANK_LIMIT;
						write_limit <= HIGH_BANK_LIMIT-1;
					end
					else
					begin
						write_pointer <= 0;
						write_limit <= LOW_BANK_LIMIT-1;
					end
				end
			end
			`WRITE:begin
              	bram_we <= 1;
				if (write_pointer < write_limit)
				begin
					if (end_of_stream==1'b1)
					begin
						state <=`IDLE;
						start_pyncmaster <= 1'b1;
					end
					else
					begin
						state <= `WRITE;
					end

					if (S_AXIS_TVALID==1'b1);
					begin
						write_pointer <= write_pointer + 1;
						bram_din <= S_AXIS_TDATA;
					end
				end
              	else
				begin
                  if (S_AXIS_TVALID==1'b1 & end_of_stream == 1'b1)
					begin
                      	state <= `IDLE;
						write_pointer <= write_pointer + 1;
						bram_din <= S_AXIS_TDATA;
					end
                  else if ( S_AXIS_TVALID == 1'b1 & end_of_stream==1'b0)
                    begin
                    state <=`WAIT;
                  	write_pointer <= write_pointer + 1;
                  	bram_din <= S_AXIS_TDATA;
                    end
				  else
                    begin
					state <= `WRITE;
                    end
				end
			end
		endcase
        end	
	end
      

      always @(*)
      begin
        case(state)
        `WAIT:begin
          axis_tready = 1'b0;
        end
        `IDLE, `INITIAL_WRITE, `WRITE: begin
          axis_tready = 1'b1;
        end
        endcase
      end

	//Tells the other processes in which bank the pseudoclock state machine is reading
	//assign current_bank_accessed = (addr_monitor < (LOW_BANK_LIMIT - 1))?1'b0:1'b1;
	//assign current_bank_accessed = addr_monitor[ADDR_MONITOR_WIDTH-1];
	
	
	always @(posedge S_AXIS_ACLK ) //It used to be (*)
	begin
      if (addr_monitor < (LOW_BANK_LIMIT - 1)) current_bank_accessed = 1'b0;
      else
		current_bank_accessed = 1'b1;
	end
    
    

endmodule