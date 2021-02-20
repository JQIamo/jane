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
	output [1:0] status_mon,
	output bank_mon,
	output tready_mon,
	output clk_mon,
	output tvalid_mon,
	output reset_mon,
	output end_of_stream_mon,
    
    
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 RAM EN" *)
  // Uncomment the following to set interface specific parameter on the bus interface.
  //  (* X_INTERFACE_PARAMETER = "MASTER_TYPE <value>,MEM_ECC <value>,MEM_WIDTH <value>,MEM_SIZE <value>,READ_WRITE_MODE <value>" *)
  //(* X_INTERFACE_PARAMETER = "MASTER_TYPE BRAM_CTRL" *)
  output reg bram_en = 1'b1, // Chip Enable Signal (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 RAM DOUT" *)
  input [BRAM_WIDTH-1:0] bram_dout, // Data Out Bus (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 RAM DIN" *)
  output reg [BRAM_WIDTH-1:0] bram_din, // Data In Bus (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 RAM WE" *)
  output reg [0:0] bram_we=1'b0, // Byte Enables (optional)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 RAM ADDR" *)
  output [$clog2(BRAM_DEPTH)-1:0] bram_addr, // Address Signal (required)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 RAM CLK" *)
  output bram_clk, // Clock Signal (required)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 RAM RST" *)
  output bram_rst, // Reset Signal (required)
    

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
	`define WAIT  2'b10
	`define WRITE  2'b11
	
	// State variable
    reg [1:0] state = `IDLE;
    
    assign status_mon = state;
    
    
	assign clk_mon = S_AXIS_ACLK;
	assign tvalid_mon = S_AXIS_TVALID;
	assign reset_mon = S_AXIS_ARESETN;
	
    reg axis_tready;
	assign S_AXIS_TREADY =  axis_tready;
    assign tready_mon = axis_tready;	
	//It keep tracks of the bank accessed in the previous clock cycle and in the current
	reg last_bank = 1'b1;
	reg current_bank_accessed;
	assign bank_mon = current_bank_accessed;
	
	// Pointers for ping-pong memory
	reg [$clog2(BRAM_DEPTH)-1:0] write_pointer; 
	reg [$clog2(BRAM_DEPTH):0] write_limit = HIGH_BANK_LIMIT; //one extra bit

	assign bram_addr = write_pointer;
	assign bram_clk = S_AXIS_ACLK;
	reg [$clog2(BRAM_DEPTH)-1:0] high_mem = BRAM_DEPTH;
	
	
	reg first_time = 1'b1;    
    wire end_of_stream;
    reg word_counter_end;
    reg [31:0] word_counter;
    
    always @( posedge S_AXIS_ACLK ) //This is causing issues
	begin
	   if (state==`IDLE)
	   begin
	       word_counter_end<=1'b0;
	       word_counter<=0;
	   end
	   else
	   begin
           if (word_counter<=num_words)
           begin
               if((axis_tready==1'b1) && (S_AXIS_TVALID==1'b1)) word_counter<=word_counter+1; //state!=`WAIT
               word_counter_end<=1'b0;
           end
           else
           begin
               word_counter_end<=1'b1;
           end
	   end
	end
    
    
    always @( posedge S_AXIS_ACLK )
	begin
	   if((axis_tready==1'b1) && (S_AXIS_TVALID==1'b1) && S_AXIS_ARESETN)
	   begin
	       bram_din <= S_AXIS_TDATA;
	       bram_we <= ~0;
	   end
	   else
	   begin
	       bram_we <= 0;
	   end
	
	end
    
    
       
    
    
    
    
    assign end_of_stream = word_counter_end;
    assign end_of_stream_mon = word_counter_end;
    always @( posedge S_AXIS_ACLK )
	begin
	
		if (!S_AXIS_ARESETN)
		begin
		    axis_tready <= 1'b0;
			state <= `IDLE;
		end
		else
		begin
			case(state)
			`IDLE:begin
				start_pyncmaster <= 1'b0;
				axis_tready <= 1'b1;
				last_bank <= 1'b1;
				first_time <= 1'b1;
				if (S_AXIS_TVALID == 0)
				begin
					state <= `IDLE;
					write_pointer <= 0;
				end
				else
				begin
				    write_pointer <= 0; // added to make compatibile with write
				    write_limit <= LOW_BANK_LIMIT-1; //// added to make compatibile with write
					state <= `WRITE;
					write_pointer <= 0;
				end
			end

			`WAIT:begin
			    start_pyncmaster <= 1'b0;
			    first_time <= 1'b0;
			    
              
				if (current_bank_accessed == last_bank || S_AXIS_TVALID == 1'b0)
				begin
				    axis_tready <= 1'b0;
					state <= `WAIT;
				end
				else
				begin
					last_bank <= current_bank_accessed;
                  	axis_tready <= 1'b1;
					state <= `WRITE;
					if (current_bank_accessed==1'b0)
					begin
						write_pointer <= LOW_BANK_LIMIT; //WAIT state causes the
						                                   //  writing in LOW_BANK_LIMIT
						write_limit <= HIGH_BANK_LIMIT-1;
					end
					else
					begin
						write_pointer <= 0; //WAIT state causes the writing in 0
						write_limit <= LOW_BANK_LIMIT-1;
					end
				end
			end

		    `WRITE:begin
		        if (S_AXIS_TVALID==1'b1);
				begin
					write_pointer <= write_pointer + 1;
				end
		    
		        if (end_of_stream==1'b1)
			    begin
				   state <=`IDLE;
				   start_pyncmaster <= 1'b1;
				end
				else
				begin
				    if (write_pointer < write_limit)
				    begin
					    axis_tready <= 1'b1;
						state <= `WRITE;
					end
					else
					begin
                        if (first_time) start_pyncmaster <= 1'b1;

                        state <=`WAIT;
                    end
				end	
			end		          
              	
		endcase
        end	
	end
      

	//Tells the other processes in which bank the pseudoclock state machine is reading
	//assign current_bank_accessed = (addr_monitor < (LOW_BANK_LIMIT - 1))?1'b0:1'b1;
	//assign current_bank_accessed = addr_monitor[ADDR_MONITOR_WIDTH-1];
	
	
	always @(posedge S_AXIS_ACLK) //instead of *
	begin
      if (addr_monitor < (LOW_BANK_LIMIT+1)) current_bank_accessed = 1'b0; //was -1
      else
		current_bank_accessed = 1'b1;
	end
    
    

endmodule