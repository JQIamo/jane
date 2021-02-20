`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JQI
// Engineer: Restelli Alessandro
// 
// Create Date: 07/24/2020 11:34:50 AM
// Design Name: 
// Module Name: ping_pong_controller
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


//THIS IS A WORK IN PROGRESS! THE GOAL IS TO MAKE A MORE EFFICIENT PING PONG MEMORY THAT WOULD ALLOW FOR A DOUBLE
//MEMORY SIZE WHEN USED WITH DMA_ping_ping_engine module


module ping_pong_memory 
          #(parameter WE_SIZE = 1,
            parameter BRAM_WIDTH = 32,
            parameter BRAM_DEPTH = 65536)
           (
            input t_valid_mon,
            input t_ready_mon,      
            
            (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 DMA EN" *)
              input dma_en, // Chip Enable Signal (optional)
              (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 DMA DOUT" *)
              output [BRAM_WIDTH-1:0] dma_dout, // Data Out Bus (optional)
              (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 DMA DIN" *)
              input [BRAM_WIDTH-1:0] dma_din, // Data In Bus (optional)
              (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 DMA WE" *)
              input [WE_SIZE-1:0] dma_we, // Byte Enables (optional)
              (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 DMA ADDR" *)
              input [$clog2(BRAM_DEPTH)-1:0] dma_addr, // Address Signal (required)
              (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 DMA CLK" *)
              input dma_clk, // Clock Signal (required)
              (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 DMA RST" *)
              input dma_rst, // Reset Signal (required)
              
              //(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 PYNCMASTER EN" *)
              //input pyncmaster_en, // Chip Enable Signal (optional)
              (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 PYNCMASTER DOUT" *)
              output [BRAM_WIDTH*4-1:0] decoder_dout, // Data Out Bus (optional)
              //(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 PYNCMASTER DIN" *)
              //input [BRAM_WIDTH*4-1:0] decoder_din, // Data In Bus (optional)
              //(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 PYNCMASTER WE" *)
              //input [WE_SIZE-1:0] decoder_we, // Byte Enables (optional)
              (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 PYNCMASTER ADDR" *)
              input [$clog2(BRAM_DEPTH)-3:0] decoder_addr, // Address Signal (required)
              (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 PYNCMASTER CLK" *)
              input decoder_clk // Clock Signal (required)
              //(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 PYNCMASTER RST" *)
              //input decoder_rst // Reset Signal (required)

    );
    
    `define DECODER 1'b0
    `define DMA 1'b1
        
    wire in_high_bank;
    wire edit;
    
    reg high_clock_select = `DECODER;
    reg low_clock_select = `DECODER;
    
    
    reg [3:0] wea_high = 4'b0000;
    reg [3:0] wea_low = 4'b0000;
    
    
    wire high_clk, low_clk;
    wire [127:0] douta_low;
    wire [127:0] douta_high;
    
    reg rsta_low = 1'b0;
    reg rsta_high = 1'b0;
    reg ena_low = 1'b1;
    reg ena_high = 1'b1;
    reg sleep_high = 1'b0;
    reg sleep_low = 1'b0;
    
    wire [127:0] dina_high;
    wire [127:0] dina_low;
    
    assign in_high_bank = decoder_addr[$clog2(BRAM_DEPTH)-1];
    
    assign decoder_dout = in_high_bank?douta_high:douta_low;
    
    assign dina_high = {dma_din,dma_din,dma_din,dma_din};
    assign dina_low =  {dma_din,dma_din,dma_din,dma_din};
    
    
    assign edit = t_valid_mon && t_ready_mon;
    
    
    
    always @(posedge dma_clk)
    begin
        if (edit)
        begin
            if (in_high_bank)
            begin
                //DMA is accessing the high bank
                low_clock_select <= `DMA;
                high_clock_select <= `DECODER;
                
                wea_high <= 16'h0000;                 
                wea_low <= 16'h000F << { dma_addr[1:0], 2'b00 };
                
                //decoder_dout is set to douta_high by assignment;
            end
            else // if instead the state machine is in high bank
            begin
                low_clock_select <= `DECODER;
                high_clock_select <= `DMA;
                
                wea_high <= 16'h000F << dma_addr[1:0];               
                wea_low <= 16'h0000;
                
                //decoder_dout is set to douta_low by assignment;
            end           
        end
        else
        begin
            high_clock_select <= `DECODER;
            low_clock_select <= `DECODER;
            wea_high <= 16'h0000; 
            wea_low <= 16'h0000; 
        end
        
    end 


//Clock control
    
BUFGMUX #(
   )
   BUFGMUX_low (
      .O(low_clk),   // 1-bit output: Clock output
      .I0(decoder_clk), // 1-bit input: Clock input (S=0)
      .I1(dma_clk), // 1-bit input: Clock input (S=1)
      .S(low_clock_select)    // 1-bit input: Clock select
   );

BUFGMUX #(
   )
   BUFGMUX_high (
      .O(high_clk),   // 1-bit output: Clock output
      .I0(decoder_clk), // 1-bit input: Clock input (S=0)
      .I1(dma_clk), // 1-bit input: Clock input (S=1)
      .S(hi_clock_select)    // 1-bit input: Clock select
   );

    

// XPM_MEMORY instantiation template for Single Port RAM configurations
// Refer to the targeted device family architecture libraries guide for XPM_MEMORY documentation
// =======================================================================================================================

// Parameter usage table, organized as follows:
// +---------------------------------------------------------------------------------------------------------------------+
// | Parameter name       | Data type          | Restrictions, if applicable                                             |
// |---------------------------------------------------------------------------------------------------------------------|
// | Description                                                                                                         |
// +---------------------------------------------------------------------------------------------------------------------+
// +---------------------------------------------------------------------------------------------------------------------+
// | ADDR_WIDTH_A         | Integer            | Range: 1 - 20. Default value = 6.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port A address port addra, in bits.                                                        |
// | Must be large enough to access the entire memory from port A, i.e. = $clog2(MEMORY_SIZE/[WRITE|READ]_DATA_WIDTH_A). |
// +---------------------------------------------------------------------------------------------------------------------+
// | AUTO_SLEEP_TIME      | Integer            | Range: 0 - 15. Default value = 0.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the number of clka cycles to auto-sleep, if feature is available in architecture.                           |
// |                                                                                                                     |
// | 0 - Disable auto-sleep feature                                                                                      |
// | 3-15 - Number of auto-sleep latency cycles                                                                          |
// |                                                                                                                     |
// | Do not change from the value provided in the template instantiation.                                                |
// +---------------------------------------------------------------------------------------------------------------------+
// | BYTE_WRITE_WIDTH_A   | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | To enable byte-wide writes on port A, specify the byte width, in bits.                                              |
// |                                                                                                                     |
// | 8- 8-bit byte-wide writes, legal when WRITE_DATA_WIDTH_A is an integer multiple of 8                                |
// | 9- 9-bit byte-wide writes, legal when WRITE_DATA_WIDTH_A is an integer multiple of 9                                |
// |                                                                                                                     |
// | Or to enable word-wide writes on port A, specify the same value as for WRITE_DATA_WIDTH_A.                          |
// +---------------------------------------------------------------------------------------------------------------------+
// | CASCADE_HEIGHT       | Integer            | Range: 0 - 64. Default value = 0.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | 0- No Cascade Height, Allow Vivado Synthesis to choose.                                                             |
// | 1 or more - Vivado Synthesis sets the specified value as Cascade Height.                                            |
// +---------------------------------------------------------------------------------------------------------------------+
// | ECC_MODE             | String             | Allowed values: no_ecc, both_encode_and_decode, decode_only, encode_only. Default value = no_ecc.|
// |---------------------------------------------------------------------------------------------------------------------|
// |                                                                                                                     |
// |   "no_ecc" - Disables ECC                                                                                           |
// |   "encode_only" - Enables ECC Encoder only                                                                          |
// |   "decode_only" - Enables ECC Decoder only                                                                          |
// |   "both_encode_and_decode" - Enables both ECC Encoder and Decoder                                                   |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_INIT_FILE     | String             | Default value = none.                                                   |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "none" (including quotes) for no memory initialization, or specify the name of a memory initialization file-|
// | Enter only the name of the file with .mem extension, including quotes but without path (e.g. "my_file.mem").        |
// | File format must be ASCII and consist of only hexadecimal values organized into the specified depth by              |
// | narrowest data width generic value of the memory. See the Memory File (MEM) section for more                        |
// | information on the syntax. Initialization of memory happens through the file name specified only when parameter     |
// | MEMORY_INIT_PARAM value is equal to "".                                                                             |
// | When using XPM_MEMORY in a project, add the specified file to the Vivado project as a design source.                |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_INIT_PARAM    | String             | Default value = 0.                                                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "" or "0" (including quotes) for no memory initialization through parameter, or specify the string          |
// | containing the hex characters. Enter only hex characters with each location separated by delimiter (,).             |
// | Parameter format must be ASCII and consist of only hexadecimal values organized into the specified depth by         |
// | narrowest data width generic value of the memory.For example, if the narrowest data width is 8, and the depth of    |
// | memory is 8 locations, then the parameter value should be passed as shown below.                                    |
// | parameter MEMORY_INIT_PARAM = "AB,CD,EF,1,2,34,56,78"                                                               |
// | Where "AB" is the 0th location and "78" is the 7th location.                                                        |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_OPTIMIZATION  | String             | Allowed values: true, false. Default value = true.                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "true" to enable the optimization of unused memory or bits in the memory structure. Specify "false" to      |
// | disable the optimization of unused memory or bits in the memory structure.                                          |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_PRIMITIVE     | String             | Allowed values: auto, block, distributed, ultra. Default value = auto.  |
// |---------------------------------------------------------------------------------------------------------------------|
// | Designate the memory primitive (resource type) to use.                                                              |
// |                                                                                                                     |
// |   "auto"- Allow Vivado Synthesis to choose                                                                          |
// |   "distributed"- Distributed memory                                                                                 |
// |   "block"- Block memory                                                                                             |
// |   "ultra"- Ultra RAM memory                                                                                         |
// |                                                                                                                     |
// | NOTE: There may be a behavior mismatch if Block RAM or Ultra RAM specific features, like ECC or Asymmetry, are selected with MEMORY_PRIMITIVE set to "auto".|
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_SIZE          | Integer            | Range: 2 - 150994944. Default value = 2048.                             |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the total memory array size, in bits.                                                                       |
// | For example, enter 65536 for a 2kx32 RAM.                                                                           |
// |                                                                                                                     |
// |   When ECC is enabled and set to "encode_only", then the memory size has to be multiples of READ_DATA_WIDTH_A       |
// |   When ECC is enabled and set to "decode_only", then the memory size has to be multiples of WRITE_DATA_WIDTH_A      |
// +---------------------------------------------------------------------------------------------------------------------+
// | MESSAGE_CONTROL      | Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify 1 to enable the dynamic message reporting such as collision warnings, and 0 to disable the message reporting|
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_DATA_WIDTH_A    | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port A read data output port douta, in bits.                                               |
// | The values of READ_DATA_WIDTH_A and WRITE_DATA_WIDTH_A must be equal.                                               |
// | When ECC is enabled and set to "encode_only", then READ_DATA_WIDTH_A has to be multiples of 72-bits.                |
// | When ECC is enabled and set to "decode_only" or "both_encode_and_decode", then READ_DATA_WIDTH_A has to be          |
// | multiples of 64-bits.                                                                                               |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_LATENCY_A       | Integer            | Range: 0 - 100. Default value = 2.                                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the number of register stages in the port A read data pipeline. Read data output to port douta takes this   |
// | number of clka cycles.                                                                                              |
// |                                                                                                                     |
// | To target block memory, a value of 1 or larger is required- 1 causes use of memory latch only; 2 causes use of      |
// | output register.                                                                                                    |
// | To target distributed memory, a value of 0 or larger is required- 0 indicates combinatorial output.                 |
// | Values larger than 2 synthesize additional flip-flops that are not retimed into memory primitives.                  |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_RESET_VALUE_A   | String             | Default value = 0.                                                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the reset value of the port A final output register stage in response to rsta input port is assertion.      |
// | Since this parameter is a string, you must specify the hex values inside double quotes. For example,                |
// | If the read data width is 8, then specify READ_RESET_VALUE_A = "EA";                                                |
// | When ECC is enabled, then reset value is not supported.                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | RST_MODE_A           | String             | Allowed values: SYNC, ASYNC. Default value = SYNC.                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Describes the behaviour of the reset                                                                                |
// |                                                                                                                     |
// |   "SYNC" - when reset is applied, synchronously resets output port douta to the value specified by parameter READ_RESET_VALUE_A|
// |   "ASYNC" - when reset is applied, asynchronously resets output port douta to zero                                  |
// +---------------------------------------------------------------------------------------------------------------------+
// | SIM_ASSERT_CHK       | Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | 0- Disable simulation message reporting. Messages related to potential misuse will not be reported.                 |
// | 1- Enable simulation message reporting. Messages related to potential misuse will be reported.                      |
// +---------------------------------------------------------------------------------------------------------------------+
// | USE_MEM_INIT         | Integer            | Range: 0 - 1. Default value = 1.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify 1 to enable the generation of below message and 0 to disable generation of the following message completely.|
// | "INFO - MEMORY_INIT_FILE and MEMORY_INIT_PARAM together specifies no memory initialization.                         |
// | Initial memory contents will be all 0s."                                                                            |
// | NOTE: This message gets generated only when there is no Memory Initialization specified either through file or      |
// | Parameter.                                                                                                          |
// +---------------------------------------------------------------------------------------------------------------------+
// | WAKEUP_TIME          | String             | Allowed values: disable_sleep, use_sleep_pin. Default value = disable_sleep.|
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "disable_sleep" to disable dynamic power saving option, and specify "use_sleep_pin" to enable the           |
// | dynamic power saving option                                                                                         |
// +---------------------------------------------------------------------------------------------------------------------+
// | WRITE_DATA_WIDTH_A   | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port A write data input port dina, in bits.                                                |
// | The values of WRITE_DATA_WIDTH_A and READ_DATA_WIDTH_A must be equal.                                               |
// | When ECC is enabled and set to "encode_only" or "both_encode_and_decode", then WRITE_DATA_WIDTH_A must be           |
// | multiples of 64-bits.                                                                                               |
// | When ECC is enabled and set to "decode_only", then WRITE_DATA_WIDTH_A must be multiples of 72-bits.                 |
// +---------------------------------------------------------------------------------------------------------------------+
// | WRITE_MODE_A         | String             | Allowed values: read_first, no_change, write_first. Default value = read_first.|
// |---------------------------------------------------------------------------------------------------------------------|
// | Write mode behavior for port A output data port, douta.                                                             |
// +---------------------------------------------------------------------------------------------------------------------+

// Port usage table, organized as follows:
// +---------------------------------------------------------------------------------------------------------------------+
// | Port name      | Direction | Size, in bits                         | Domain  | Sense       | Handling if unused     |
// |---------------------------------------------------------------------------------------------------------------------|
// | Description                                                                                                         |
// +---------------------------------------------------------------------------------------------------------------------+
// +---------------------------------------------------------------------------------------------------------------------+
// | addra          | Input     | ADDR_WIDTH_A                          | clka    | NA          | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Address for port A write and read operations.                                                                       |
// +---------------------------------------------------------------------------------------------------------------------+
// | clka           | Input     | 1                                     | NA      | Rising edge | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Clock signal for port A.                                                                                            |
// +---------------------------------------------------------------------------------------------------------------------+
// | dbiterra       | Output    | 1                                     | clka    | Active-high | DoNotCare              |
// |---------------------------------------------------------------------------------------------------------------------|
// | Status signal to indicate double bit error occurrence on the data output of port A.                                 |
// +---------------------------------------------------------------------------------------------------------------------+
// | dina           | Input     | WRITE_DATA_WIDTH_A                    | clka    | NA          | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Data input for port A write operations.                                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | douta          | Output    | READ_DATA_WIDTH_A                     | clka    | NA          | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Data output for port A read operations.                                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | ena            | Input     | 1                                     | clka    | Active-high | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Memory enable signal for port A.                                                                                    |
// | Must be high on clock cycles when read or write operations are initiated. Pipelined internally.                     |
// +---------------------------------------------------------------------------------------------------------------------+
// | injectdbiterra | Input     | 1                                     | clka    | Active-high | Tie to 1'b0            |
// |---------------------------------------------------------------------------------------------------------------------|
// | Controls double bit error injection on input data when ECC enabled (Error injection capability is not available in  |
// | "decode_only" mode).                                                                                                |
// +---------------------------------------------------------------------------------------------------------------------+
// | injectsbiterra | Input     | 1                                     | clka    | Active-high | Tie to 1'b0            |
// |---------------------------------------------------------------------------------------------------------------------|
// | Controls single bit error injection on input data when ECC enabled (Error injection capability is not available in  |
// | "decode_only" mode).                                                                                                |
// +---------------------------------------------------------------------------------------------------------------------+
// | regcea         | Input     | 1                                     | clka    | Active-high | Tie to 1'b1            |
// |---------------------------------------------------------------------------------------------------------------------|
// | Clock Enable for the last register stage on the output data path.                                                   |
// +---------------------------------------------------------------------------------------------------------------------+
// | rsta           | Input     | 1                                     | clka    | Active-high | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Reset signal for the final port A output register stage.                                                            |
// | Synchronously resets output port douta to the value specified by parameter READ_RESET_VALUE_A.                      |
// +---------------------------------------------------------------------------------------------------------------------+
// | sbiterra       | Output    | 1                                     | clka    | Active-high | DoNotCare              |
// |---------------------------------------------------------------------------------------------------------------------|
// | Status signal to indicate single bit error occurrence on the data output of port A.                                 |
// +---------------------------------------------------------------------------------------------------------------------+
// | sleep          | Input     | 1                                     | NA      | Active-high | Tie to 1'b0            |
// |---------------------------------------------------------------------------------------------------------------------|
// | sleep signal to enable the dynamic power saving feature.                                                            |
// +---------------------------------------------------------------------------------------------------------------------+
// | wea            | Input     | WRITE_DATA_WIDTH_A                    | clka    | Active-high | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Write enable vector for port A input data port dina. 1 bit wide when word-wide writes are used.                     |
// | In byte-wide write configurations, each bit controls the writing one byte of dina to address addra.                 |
// | For example, to synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be 4'b0010.   |
// +---------------------------------------------------------------------------------------------------------------------+


// xpm_memory_spram : In order to incorporate this function into the design,
//     Verilog      : the following instance declaration needs to be placed
//     instance     : in the body of the design code.  The instance name
//   declaration    : (xpm_memory_spram_inst) and/or the port declarations within the
//       code       : parenthesis may be changed to properly reference and
//                  : connect this function to the design.  All inputs
//                  : and outputs must be connected.

//  Please reference the appropriate libraries guide for additional information on the XPM modules.

//  <-----Cut code below this line---->

   // xpm_memory_spram: Single Port RAM
   // Xilinx Parameterized Macro, version 2019.1

   xpm_memory_spram #(
      .ADDR_WIDTH_A($clog2(BRAM_DEPTH)-3),              // DECIMAL
      .AUTO_SLEEP_TIME(0),           // DECIMAL
      .BYTE_WRITE_WIDTH_A(8),       // DECIMAL
      .CASCADE_HEIGHT(0),            // DECIMAL
      .ECC_MODE("no_ecc"),           // String
      .MEMORY_INIT_FILE("none"),     // String
      .MEMORY_INIT_PARAM("0"),       // String
      .MEMORY_OPTIMIZATION("true"),  // String
      .MEMORY_PRIMITIVE("block"),     // String
      .MEMORY_SIZE(BRAM_DEPTH/8),            // DECIMAL
      .MESSAGE_CONTROL(0),           // DECIMAL
      .READ_DATA_WIDTH_A(128),        // DECIMAL
      .READ_LATENCY_A(1),            // DECIMAL // minimum option if block memory is used
      .READ_RESET_VALUE_A("0"),      // String
      .RST_MODE_A("SYNC"),           // String
      .SIM_ASSERT_CHK(0),            // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_MEM_INIT(1),              // DECIMAL
      .WAKEUP_TIME("disable_sleep"), // String
      .WRITE_DATA_WIDTH_A(128),       // DECIMAL
      .WRITE_MODE_A("no_change")    // String
   )
   low_bank (
      //.dbiterra(dbiterra),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port A.

      .douta(douta_low),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      //.sbiterra(sbiterra_low),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port A.

      .addra(addra_low),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      .clka(low_clk),                     // 1-bit input: Clock signal for port A.
      .dina(dina_low),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .ena(ena_low),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

      //.injectdbiterra(injectdbiterra_low), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      //.injectsbiterra(injectsbiterra_low), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      //.regcea(regcea_low),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .rsta(rsta_low),                     // 1-bit input: Reset signal for the final port A output register stage.
                                       // Synchronously resets output port douta to the value specified by
                                       // parameter READ_RESET_VALUE_A.

      .sleep(sleep_low),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
      .wea(wea_low)                        // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                       // data port dina. 1 bit wide when word-wide writes are used. In
                                       // byte-wide write configurations, each bit controls the writing one
                                       // byte of dina to address addra. For example, to synchronously write
                                       // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                       // 4'b0010.

   );

   // End of xpm_memory_spram_inst instantiation
				
	   // xpm_memory_spram: Single Port RAM
   // Xilinx Parameterized Macro, version 2019.1

   xpm_memory_spram #(
      .ADDR_WIDTH_A($clog2(BRAM_DEPTH)-3),              // DECIMAL
      .AUTO_SLEEP_TIME(0),           // DECIMAL
      .BYTE_WRITE_WIDTH_A(8),       // DECIMAL
      .CASCADE_HEIGHT(0),            // DECIMAL
      .ECC_MODE("no_ecc"),           // String
      .MEMORY_INIT_FILE("none"),     // String
      .MEMORY_INIT_PARAM("0"),       // String
      .MEMORY_OPTIMIZATION("true"),  // String
      .MEMORY_PRIMITIVE("block"),     // String
      .MEMORY_SIZE(BRAM_DEPTH/8),            // DECIMAL
      .MESSAGE_CONTROL(0),           // DECIMAL
      .READ_DATA_WIDTH_A(128),        // DECIMAL
      .READ_LATENCY_A(1),            // DECIMAL // minimum option if block memory is used
      .READ_RESET_VALUE_A("0"),      // String
      .RST_MODE_A("SYNC"),           // String
      .SIM_ASSERT_CHK(0),            // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_MEM_INIT(1),              // DECIMAL
      .WAKEUP_TIME("disable_sleep"), // String
      .WRITE_DATA_WIDTH_A(128),       // DECIMAL
      .WRITE_MODE_A("no_change")    // String
   )
   high_bank (
      //.dbiterra(dbiterra),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port A.

      .douta(douta_high),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      //.sbiterra(sbiterra),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port A.

      .addra(addra_high),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      .clka(high_clk),                     // 1-bit input: Clock signal for port A.
      .dina(dina_high),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .ena(ena_high),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

      //.injectdbiterra(injectdbiterra), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      //.injectsbiterra(injectsbiterra), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      //.regcea(regcea_high),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .rsta(rsta_high),                     // 1-bit input: Reset signal for the final port A output register stage.
                                       // Synchronously resets output port douta to the value specified by
                                       // parameter READ_RESET_VALUE_A.

      .sleep(sleep_high),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
      .wea(wea_high)                        // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                       // data port dina. 1 bit wide when word-wide writes are used. In
                                       // byte-wide write configurations, each bit controls the writing one
                                       // byte of dina to address addra. For example, to synchronously write
                                       // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                       // 4'b0010.

   );
			
			
    
    
    
    
    
    
    
endmodule
