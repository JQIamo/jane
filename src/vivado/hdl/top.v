`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Xilinx Inc
// Design Name: PYNQ
// Module Name: top
// Project Name: PYNQ
// Target Devices: ZC7020
// Tool Versions: 2016.1
// Description: 
//////////////////////////////////////////////////////////////////////////////////

module top(
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    Vp_Vn_v_n,
    Vp_Vn_v_p,
    //8 output banks (64 total outputs)
    B1,
    B2,
    B3,
    B4,
    B5,
    B6,
    B7,
    B8,
    ENABLE,
    TRIG1_N,
    TRIG1_P
//    BANK_LVDS_0_N,
//    BANK_LVDS_0_P,
//    BANK_LVDS_1_N,
//    BANK_LVDS_1_P,
//    BANK_LVDS_2_N,
//    BANK_LVDS_2_P,
//    BANK_LVDS_3_N,
//    BANK_LVDS_3_P,
//    BANK_LVDS_4_N,
//    BANK_LVDS_4_P,
//    BANK_LVDS_5_N,
//    BANK_LVDS_5_P,
//    BANK_LVDS_6_N,
//    BANK_LVDS_6_P,
//    BANK13_SE_0,
//    JX1_LVDS_0_N,
//    JX1_LVDS_0_P,
//    JX1_LVDS_1_N,
//    JX1_LVDS_1_P,
//    JX1_LVDS_10_N,
//    JX1_LVDS_10_P,
//    JX1_LVDS_11_N,
//    JX1_LVDS_11_P,
//    JX1_LVDS_12_N,
//    JX1_LVDS_12_P,
//    JX1_LVDS_13_N,
//    JX1_LVDS_13_P,
//    JX1_LVDS_14_N,
//    JX1_LVDS_14_P,
//    JX1_LVDS_15_N,
//    JX1_LVDS_15_P,
//    JX1_LVDS_16_N,
//    JX1_LVDS_16_P,
//    JX1_LVDS_17_N,
//    JX1_LVDS_17_P,
//    JX1_LVDS_18_N,
//    JX1_LVDS_18_P,
//    JX1_LVDS_19_N,
//    JX1_LVDS_19_P,
//    JX1_LVDS_2_N,
//    JX1_LVDS_2_P,
//    JX1_LVDS_20_N,
//    JX1_LVDS_20_P,
//    JX1_LVDS_21_N,
//    JX1_LVDS_21_P,
//    JX1_LVDS_22_N,
//    JX1_LVDS_22_P,
//    JX1_LVDS_23_N,
//    JX1_LVDS_3_N,
//    JX1_LVDS_3_P,
//    JX1_LVDS_4_N,
//    JX1_LVDS_4_P,
//    JX1_LVDS_5_N,
//    JX1_LVDS_5_P,
//    JX1_LVDS_6_N,
//    JX1_LVDS_6_P,
//    JX1_LVDS_7_N,
//    JX1_LVDS_7_P,
//    JX1_LVDS_8_N,
//    JX1_LVDS_8_P,
//    JX1_LVDS_9_N,
//    JX1_LVDS_9_P,
//    JX1_SE_0,
//    JX1_SE_1,
//    JX2_LVDS_0_N,
//    JX2_LVDS_0_P,
//    JX2_LVDS_1_N,
//    JX2_LVDS_1_P,
//    JX2_LVDS_10_N,
//    JX2_LVDS_10_P,
//    JX2_LVDS_11_N,
//    JX2_LVDS_11_P,
//    JX2_LVDS_12_N,
//    JX2_LVDS_12_P,
//    JX2_LVDS_13_N,
//    JX2_LVDS_13_P,
//    JX2_LVDS_14_N,
//    JX2_LVDS_14_P,
//    JX2_LVDS_15_N,
//    JX2_LVDS_15_P,
//    JX2_LVDS_16_N,
//    JX2_LVDS_16_P,
//    JX2_LVDS_17_N,
//    JX2_LVDS_17_P,
//    JX2_LVDS_18_N,
//    JX2_LVDS_18_P,
//    JX2_LVDS_19_N,
//    JX2_LVDS_19_P,
//    JX2_LVDS_2_N,
//    JX2_LVDS_2_P,
//    JX2_LVDS_20_N,
//    JX2_LVDS_20_P,
//    JX2_LVDS_21_N,
//    JX2_LVDS_21_P,
//    JX2_LVDS_22_N,
//    JX2_LVDS_22_P,
//    JX2_LVDS_23_N,
//    JX2_LVDS_3_N,
//    JX2_LVDS_3_P,
//    JX2_LVDS_4_N,
//    JX2_LVDS_4_P,
//    JX2_LVDS_5_N,
//    JX2_LVDS_5_P,
//    JX2_LVDS_6_N,
//    JX2_LVDS_6_P,
//    JX2_LVDS_7_N,
//    JX2_LVDS_7_P,
//    JX2_LVDS_8_N,
//    JX2_LVDS_8_P,
//    JX2_LVDS_9_N,
//    JX2_LVDS_9_P,
//    JX2_SE_0,
//    JX2_SE_1 
    );
    
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input Vp_Vn_v_n;
  input Vp_Vn_v_p;
  output [7:0] B1;
  output [7:0] B2;
  output [7:0] B3;
  output [7:0] B4;
  output [7:0] B5;
  output [7:0] B6;
  output [7:0] B7;
  output [7:0] B8;
  output ENABLE;
  input TRIG1_N;
  input TRIG1_P;
  
  //assign B1[0] = trigger;
//  inout BANK_LVDS_0_N;
//  inout BANK_LVDS_0_P;
//  inout BANK_LVDS_1_N;
//  inout BANK_LVDS_1_P;
//  inout BANK_LVDS_2_N;
//  inout BANK_LVDS_2_P;
//  inout BANK_LVDS_3_N;
//  inout BANK_LVDS_3_P;
//  inout BANK_LVDS_4_N;
//  inout BANK_LVDS_4_P;
//  inout BANK_LVDS_5_N;
//  inout BANK_LVDS_5_P;
//  inout BANK_LVDS_6_N;
//  inout BANK_LVDS_6_P;
//  inout BANK13_SE_0;
//  output JX1_LVDS_0_N;
//  output JX1_LVDS_0_P;
//  output JX1_LVDS_1_N;
//  output JX1_LVDS_1_P;
//  inout JX1_LVDS_10_N;
//  inout JX1_LVDS_10_P;
//  inout JX1_LVDS_11_N;
//  inout JX1_LVDS_11_P;
//  output JX1_LVDS_12_N;
//  output JX1_LVDS_12_P;
//  output JX1_LVDS_13_N;
//  output JX1_LVDS_13_P;
//  output JX1_LVDS_14_N;
//  output JX1_LVDS_14_P;
//  output JX1_LVDS_15_N;
//  output JX1_LVDS_15_P;
//  inout JX1_LVDS_16_N;
//  inout JX1_LVDS_16_P;
//  inout JX1_LVDS_17_N;
//  inout JX1_LVDS_17_P;
//  inout JX1_LVDS_18_N;
//  output JX1_LVDS_18_P;
//  inout JX1_LVDS_19_N;
//  inout JX1_LVDS_19_P;
//  inout JX1_LVDS_2_N;
//  inout JX1_LVDS_2_P;
//  inout JX1_LVDS_20_N;
//  inout JX1_LVDS_20_P;
//  inout JX1_LVDS_21_N;
//  inout JX1_LVDS_21_P;
//  inout JX1_LVDS_22_N;
//  inout JX1_LVDS_22_P;
//  inout JX1_LVDS_23_N;
//  output JX1_LVDS_3_N;
//  output JX1_LVDS_3_P;
//  output JX1_LVDS_4_N;
//  output JX1_LVDS_4_P;
//  inout JX1_LVDS_5_N;
//  inout JX1_LVDS_5_P;
//  output JX1_LVDS_6_N;
//  output JX1_LVDS_6_P;
//  output JX1_LVDS_7_N;
//  output JX1_LVDS_7_P;
//  output JX1_LVDS_8_N;
//  output JX1_LVDS_8_P;
//  output JX1_LVDS_9_N;
//  output JX1_LVDS_9_P;
//  inout JX1_SE_0;
//  inout JX1_SE_1;
//  inout JX2_LVDS_0_N;
//  inout JX2_LVDS_0_P;
//  inout JX2_LVDS_1_N;
//  inout JX2_LVDS_1_P;
//  inout JX2_LVDS_10_N;
//  inout JX2_LVDS_10_P;
//  inout JX2_LVDS_11_N;
//  inout JX2_LVDS_11_P;
//  inout JX2_LVDS_12_N;
//  inout JX2_LVDS_12_P;
//  inout JX2_LVDS_13_N;
//  inout JX2_LVDS_13_P;
//  inout JX2_LVDS_14_N;
//  inout JX2_LVDS_14_P;
//  inout JX2_LVDS_15_N;
//  inout JX2_LVDS_15_P;
//  inout JX2_LVDS_16_N;
//  inout JX2_LVDS_16_P;
//  inout JX2_LVDS_17_N;
//  inout JX2_LVDS_17_P;
//  inout JX2_LVDS_18_N;
//  inout JX2_LVDS_18_P;
//  inout JX2_LVDS_19_N;
//  inout JX2_LVDS_19_P;
//  inout JX2_LVDS_2_N;
//  inout JX2_LVDS_2_P;
//  inout JX2_LVDS_20_N;
//  inout JX2_LVDS_20_P;
//  inout JX2_LVDS_21_N;
//  inout JX2_LVDS_21_P;
//  inout JX2_LVDS_22_N;
//  inout JX2_LVDS_22_P;
//  inout JX2_LVDS_23_N;
//  inout JX2_LVDS_3_N;
//  inout JX2_LVDS_3_P;
//  inout JX2_LVDS_4_N;
//  inout JX2_LVDS_4_P;
//  inout JX2_LVDS_5_N;
//  inout JX2_LVDS_5_P;
//  inout JX2_LVDS_6_N;
//  inout JX2_LVDS_6_P;
//  inout JX2_LVDS_7_N;
//  inout JX2_LVDS_7_P;
//  inout JX2_LVDS_8_N;
//  inout JX2_LVDS_8_P;
//  inout JX2_LVDS_9_N;
//  inout JX2_LVDS_9_P;
//  inout JX2_SE_0;
//  inout JX2_SE_1;
  
  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire trigger;
  wire [63:0] ports;
  
  assign ports= {B8, B7, B6, B5, B4, B3, B2, B1};
  //wire fake;
                         

system_wrapper system_i
   (.DDR_addr(DDR_addr),
    .DDR_ba(DDR_ba),
    .DDR_cas_n(DDR_cas_n),
    .DDR_ck_n(DDR_ck_n),
    .DDR_ck_p(DDR_ck_p),
    .DDR_cke(DDR_cke),
    .DDR_cs_n(DDR_cs_n),
    .DDR_dm(DDR_dm),
    .DDR_dq(DDR_dq),
    .DDR_dqs_n(DDR_dqs_n),
    .DDR_dqs_p(DDR_dqs_p),
    .DDR_odt(DDR_odt),
    .DDR_ras_n(DDR_ras_n),
    .DDR_reset_n(DDR_reset_n),
    .DDR_we_n(DDR_we_n),
    .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
    .FIXED_IO_mio(FIXED_IO_mio),
    .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
    //.test(JX1_LVDS_18_P),           // PMOD JD Pin 1
    .Trigger(trigger),
    //.channels({ports[62:1],ports[63]}), //Add B4 - B8 later
    .channels(ports),
    .run_monitor(),
    .ENABLE(ENABLE)
    );
  
  
   // IBUFDS: Differential Input Buffer
    //         Artix-7
    // Xilinx HDL Language Template, version 2018.2
 
    IBUFDS #(
       .DIFF_TERM("FALSE"),       // Differential Termination
       .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
       .IOSTANDARD("BLVDS_25")     // Specify the input I/O standard
    ) IBUFDS_inst (
       .O(trigger),  // Buffer output
       .I(TRIG1_P),  // Diff_p buffer input (connect directly to top-level port)
       .IB(TRIG1_N) // Diff_n buffer input (connect directly to top-level port)
    );
        
endmodule
