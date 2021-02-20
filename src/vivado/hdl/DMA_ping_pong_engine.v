	//Written by Ananya Sitaram and Alessandro Restelli
	
	//This module is a BRAM driver that interfaces a DMA AXIs driver to a BRAM that is partitioned in two identical banks
	
	//At first the DMA will fill-up the full memory and if the size of the program is much longer than
	
	
	
	
	
	module DMA_pingpong_engine #
	(
		// Parameters
       
       
        //This parameter specifies the size of the RAM (in words with size BRAM_WIDTH)
        parameter ADDR_WIDTH = 17,
        
        
        //How many words (with size BRAM_WIDTH) for one instruction?
        parameter WORDS_IN_INSTRUCTION = 4,


		// AXI4Stream sink: Data Width
		// Bram data width
		//They should be both 32 bits.
		parameter integer C_S_AXIS_TDATA_WIDTH	= 32,
		parameter BRAM_WIDTH = 32
	)
	(
		// Users to add ports here

	input [ADDR_WIDTH - $clog2(WORDS_IN_INSTRUCTION)-1:0] instruction_monitor,
	input [31:0] num_words,

	output reg start_pyncmaster = 1'b0,
	    
    
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
  output reg [ADDR_WIDTH-1:0] bram_addr, // Address Signal (required)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 RAM CLK" *)
  output bram_clk, // Clock Signal (required)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 RAM RST" *)
  output bram_rst, // Reset Signal (required)
   

		// AXI4Stream sink: Clock
		input wire  S_AXIS_ACLK,
		// AXI4Stream sink: Reset
		input wire  S_AXIS_ARESETN,
		// Ready to accept data in
		output reg  S_AXIS_TREADY,
		// Data in
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
		// Byte qualifier
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
		// Indicates boundary of last packet
		input wire  S_AXIS_TLAST,
		// Data is in valid
		input wire  S_AXIS_TVALID,
		
		
		output tvalid,
		output tready
		
		
	);
	
	localparam [ADDR_WIDTH-1:0] LOW_BANK_LIMIT= (2**(ADDR_WIDTH - 1) -1);
    localparam [ADDR_WIDTH-1:0] HIGH_BANK_LIMIT = (2**(ADDR_WIDTH) - 1);
	
	
	
    `define IDLE  2'b00
	`define WAIT  2'b10
	`define WRITE  2'b11
	`define WRITE_MASKED 2'b01
	// State variable
    reg [1:0] state = `IDLE;
    
   
	
    
    wire [ADDR_WIDTH-1:0] addr_monitor;
    
    assign addr_monitor [ADDR_WIDTH-1:$clog2(WORDS_IN_INSTRUCTION)] = instruction_monitor;
    if ($clog2(WORDS_IN_INSTRUCTION)>0) assign addr_monitor [$clog2(WORDS_IN_INSTRUCTION)-1:0] = 0;
    
    reg axis_tready;
	

	//It keep tracks of the bank accessed in the previous clock cycle and in the current
	reg last_bank = 1'b1;
	reg current_bank_accessed;

	
	// Pointers for ping-pong memory
	reg [ADDR_WIDTH-1:0] write_pointer; 
	reg [ADDR_WIDTH:0] write_limit = HIGH_BANK_LIMIT; //one extra bit


	assign bram_clk = S_AXIS_ACLK;
	assign tvalid = S_AXIS_TVALID;
	assign tready = S_AXIS_TREADY;
	
	reg first_time = 1'b1;    
    wire end_of_stream;
    reg word_counter_end;
    reg [31:0] word_counter;
    
    reg we = 0;
    
    //main state machine
    //The state machine stays in IDLE state, then it writes (WRITE_MASKED and WRITE)
	//Then it goes back and forth between WAIT and (WRITE_MASKED and WRITE)
	
	// WRITE_MASKED is used before write to ensure that there is no control on the value of
	//  write_pointer when the first word of the memory bank is written. This ensures that write_pointer
	//  has the time to overflow correctly and become less than write_limit
    
    always @( posedge S_AXIS_ACLK )
	begin
	    S_AXIS_TREADY <=  axis_tready;
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
				last_bank <= 1'b0;
				first_time <= 1'b1;
				if (S_AXIS_TVALID == 0)
				begin
					state <= `IDLE;
				end
				else
				begin
				    write_limit <= HIGH_BANK_LIMIT-1; //// added to make compatibile with write
					state <= `WRITE_MASKED;

				end
			end
			
		    `WRITE_MASKED:begin
                 if (end_of_stream==1'b1)
                    begin
                       state <=`IDLE;
                       start_pyncmaster <= 1'b1;
                    end
                    else
                    begin
                        axis_tready <= 1'b1;
						state <= `WRITE;
                    end
		    
		    end  
            
             `WRITE:begin	    
		        if (end_of_stream==1'b1)
			    begin
				   state <=`IDLE;
				   if (first_time) start_pyncmaster <= 1'b1;
				end
				begin
				    if ((write_pointer < write_limit))
				    begin
					    axis_tready <= 1'b1;
						state <= `WRITE;
					end
					else
					begin
                        if (first_time) start_pyncmaster <= 1'b1;
                        axis_tready <= 1'b0;
                        state <=`WAIT;
                    end
				end	
			end		          
            
			`WAIT:begin
			    start_pyncmaster <= 1'b0;
			    first_time <= 1'b0;
			    
			    if (end_of_stream==1'b1)
				begin
				   state <= `IDLE;
				end
			    else
			    begin
                    if (current_bank_accessed == last_bank || S_AXIS_TVALID == 1'b0)
                    begin
                        axis_tready <= 1'b0;
                        state <= `WAIT;
                    end
                    else
                    begin
                        last_bank <= current_bank_accessed;
                        axis_tready <= 1'b1;
                        state <= `WRITE_MASKED;
                        if (current_bank_accessed==1'b0)
                        begin
                            write_limit <= HIGH_BANK_LIMIT-1;
                        end
                        else
                        begin
                            write_limit <= LOW_BANK_LIMIT-1;
                        end
                    end
                end
			end
               	
		endcase
        end	
	end
    
    
    //State machine taking care of the total word counter that is used to tell the system when the program is finished.
    
    assign end_of_stream = word_counter_end;
    
    always @( posedge S_AXIS_ACLK )
	begin
	   if (state==`IDLE)
	   begin
	       word_counter_end<=1'b0;
	       word_counter <= 0;
	   end
	   else
	   begin
           if (word_counter<num_words)
           begin
               if((S_AXIS_TREADY==1'b1) && (S_AXIS_TVALID==1'b1)) word_counter<=word_counter+1; //state!=`WAIT
               word_counter_end<=1'b0;
           end
           else
           begin
               word_counter_end<=1'b1;
           end
	   end
	end
    
    
    
    //State machine that increments the memory pointer and enables bram_we only on the basis of a legal transaction happening
    // when tready and tvalid are both 1 there MUST be a memory write!
       
    always @( posedge S_AXIS_ACLK )
	begin
	   
	   if (S_AXIS_TVALID==1'b1) bram_din <= S_AXIS_TDATA;
	   bram_addr <= write_pointer;
	
	
	   if((axis_tready==1'b1) && (S_AXIS_TVALID==1'b1) && S_AXIS_ARESETN)
	   begin
	       if (state==`IDLE)
	       begin
	           bram_we <= ~0;
	       end
	       else
	       begin
	           bram_we <= we;
	       end
	       we <= ~0;
	       write_pointer <= write_pointer + 1;
	   end
	   else
	   begin
	       we <= 0;
	       bram_we <= we;
	       if (state==`IDLE) write_pointer <= 0;            
	   end
	
	end
    
    
    
    
      

	//Tells the other processes in which bank the pseudoclock state machine is reading

	
	always @(posedge S_AXIS_ACLK) //instead of *
	begin
      if (addr_monitor < LOW_BANK_LIMIT) current_bank_accessed = 1'b0; //was -1
      else
		current_bank_accessed = 1'b1;
	end
    
    

endmodule