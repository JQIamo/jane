


#How to design a PMOD
##pmod Header JB
#set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports {pmodJB[1]}]
#set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {pmodJB[0]}]
#set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {pmodJB[3]}]
#set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {pmodJB[2]}]
#set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {pmodJB[5]}]
#set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {pmodJB[4]}]
#set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {pmodJB[7]}]
#set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {pmodJB[6]}]
#set_property PULLUP true [get_ports {pmodJB[2]}]
#set_property PULLUP true [get_ports {pmodJB[3]}]
#set_property PULLUP true [get_ports {pmodJB[6]}]
#set_property PULLUP true [get_ports {pmodJB[7]}]



# How to deal with I2C pullups
##Arduino shield shared I2C related pullup
#set_property PULLUP true [get_ports {gpio_shield_sw_a5_a0_tri_io[5]}]
#set_property PULLUP true [get_ports {gpio_shield_sw_a5_a0_tri_io[4]}]


# ----------------------------------------------------------------------------
#     _____
#    /     \
#   /____   \____
#  / \===\   \==/
# /___\===\___\/  AVNET Design Resource Center
#      \======/         www.em.avnet.com/drc
#       \====/    
# ----------------------------------------------------------------------------
# 
#  Created With Avnet UCF Generator V0.4.0 
#     Date: Wednesday, November 27, 2013 
#     Time: 2:10:18 PM 
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
#  
#  Please direct any questions or issues to the MicroZed Community Forums:
#     http://www.microzed.org
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2013 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
#
#  Notes:
# 
#  27 November 2013
#     IO standards based upon Bank 34, Bank 35 Vcco supply options of 1.8V, 
#     2.5V, or 3.3V are possible based upon the Vadj jumper (J18) settings.  
#     By default, Vadj is expected to be set to 1.8V but if a different 
#     voltage is used for a particular design, then the corresponding IO 
#     standard within this UCF should also be updated to reflect the actual 
#     Vadj jumper selection.
# 
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.  
#     HDL net names are adjusted to contain no hyphen characters '-' but 
#     rather use underscore '_' characters.  Comment net name with the hyphen 
#     characters will remain in place since these are intended to match the 
#     schematic net names in order to better enable schematic search.
#
#     In the following, the XDC constraint is matched to the origanal UCF 
#     constraint, UCF commented out above, XDC equivalent placedbelow the UCF.
#
# ----------------------------------------------------------------------------
 
# Bank 13, Vcco = Vadj 
# Set the bank voltage for bank 13.
set_property IOSTANDARD LVCMOS18 [get_ports -filter { IOBANK == 13 } ]

set_property PACKAGE_PIN V7  [get_ports {BANK13_LVDS_0_N}]
set_property PACKAGE_PIN U7  [get_ports {BANK13_LVDS_0_P}]
set_property PACKAGE_PIN U10 [get_ports {BANK13_LVDS_1_N}]
set_property PACKAGE_PIN T9  [get_ports {BANK13_LVDS_1_P}]
set_property PACKAGE_PIN W8  [get_ports {BANK13_LVDS_2_N}]
set_property PACKAGE_PIN V8  [get_ports {BANK13_LVDS_2_P}]
set_property PACKAGE_PIN U5  [get_ports {BANK13_LVDS_3_N}]
set_property PACKAGE_PIN T5  [get_ports {BANK13_LVDS_3_P}]
set_property PACKAGE_PIN Y13 [get_ports {BANK13_LVDS_4_N}]
set_property PACKAGE_PIN Y12 [get_ports {BANK13_LVDS_4_P}]
set_property PACKAGE_PIN V10 [get_ports {BANK13_LVDS_5_N}]
set_property PACKAGE_PIN V11 [get_ports {BANK13_LVDS_5_P}]
set_property PACKAGE_PIN W6  [get_ports {BANK13_LVDS_6_N}]
set_property PACKAGE_PIN V6  [get_ports {BANK13_LVDS_6_P}]
set_property PACKAGE_PIN V5  [get_ports {BANK13_SE_0}]

# Bank 34, Vcco = Vadj
# Set the bank voltage for bank 34.
#set_property IOSTANDARD LVCMOS33 [get_ports -filter { IOBANK == 34 } ]

#set_property PACKAGE_PIN T10 [get_ports {JX1_LVDS_0_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_0_N}]
#set_property PACKAGE_PIN T11 [get_ports {JX1_LVDS_0_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_0_P}]
#set_property PACKAGE_PIN U12 [get_ports {JX1_LVDS_1_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_1_N}]
#set_property PACKAGE_PIN T12 [get_ports {JX1_LVDS_1_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_1_P}]
#set_property PACKAGE_PIN U15 [get_ports {JX1_LVDS_10_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_10_N}]
#set_property PACKAGE_PIN U14 [get_ports {JX1_LVDS_10_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_10_P}]
#set_property PACKAGE_PIN U19 [get_ports {JX1_LVDS_11_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_11_N}]
#set_property PACKAGE_PIN U18 [get_ports {JX1_LVDS_11_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_11_P}]
#set_property PACKAGE_PIN P19 [get_ports {JX1_LVDS_12_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_12_N}]
#set_property PACKAGE_PIN N18 [get_ports {JX1_LVDS_12_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_12_P}]
#set_property PACKAGE_PIN P20 [get_ports {JX1_LVDS_13_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_13_N}]
#set_property PACKAGE_PIN N20 [get_ports {JX1_LVDS_13_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_13_P}]
#set_property PACKAGE_PIN U20 [get_ports {JX1_LVDS_14_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_14_N}]
#set_property PACKAGE_PIN T20 [get_ports {JX1_LVDS_14_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_14_P}]
#set_property PACKAGE_PIN W20 [get_ports {JX1_LVDS_15_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_15_N}]
#set_property PACKAGE_PIN V20 [get_ports {JX1_LVDS_15_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_15_P}]
#set_property PACKAGE_PIN Y19 [get_ports {JX1_LVDS_16_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_16_N}]
#set_property PACKAGE_PIN Y18 [get_ports {JX1_LVDS_16_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_16_P}]
#set_property PACKAGE_PIN W16 [get_ports {JX1_LVDS_17_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_17_N}]
#set_property PACKAGE_PIN V16 [get_ports {JX1_LVDS_17_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_17_P}]
#set_property PACKAGE_PIN R17 [get_ports {JX1_LVDS_18_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_18_N}]
#set_property PACKAGE_PIN R16 [get_ports {JX1_LVDS_18_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_18_P}]
#set_property PACKAGE_PIN R18 [get_ports {JX1_LVDS_19_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_19_N}]
#set_property PACKAGE_PIN T17 [get_ports {JX1_LVDS_19_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_19_P}]
#set_property PACKAGE_PIN V13 [get_ports {JX1_LVDS_2_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_2_N}]
#set_property PACKAGE_PIN U13 [get_ports {JX1_LVDS_2_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_2_P}]
#set_property PACKAGE_PIN V18 [get_ports {JX1_LVDS_20_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_20_N}]
#set_property PACKAGE_PIN V17 [get_ports {JX1_LVDS_20_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_20_P}]
#set_property PACKAGE_PIN W19 [get_ports {JX1_LVDS_21_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_21_N}]
#set_property PACKAGE_PIN W18 [get_ports {JX1_LVDS_21_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_21_P}]
#set_property PACKAGE_PIN P18 [get_ports {JX1_LVDS_22_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_22_N}]
#set_property PACKAGE_PIN N17 [get_ports {JX1_LVDS_22_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_22_P}]
#set_property PACKAGE_PIN P16 [get_ports {JX1_LVDS_23_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_23_N}]
#set_property PACKAGE_PIN P15 [get_ports {JX1_LVDS_23_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_23_P}]
#set_property PACKAGE_PIN W13 [get_ports {JX1_LVDS_3_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_3_N}]
#set_property PACKAGE_PIN V12 [get_ports {JX1_LVDS_3_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_3_P}]
#set_property PACKAGE_PIN T15 [get_ports {JX1_LVDS_4_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_4_N}]
#set_property PACKAGE_PIN T14 [get_ports {JX1_LVDS_4_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_4_P}]
#set_property PACKAGE_PIN R14 [get_ports {JX1_LVDS_5_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_5_N}]
#set_property PACKAGE_PIN P14 [get_ports {JX1_LVDS_5_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_5_P}]
#set_property PACKAGE_PIN Y17 [get_ports {JX1_LVDS_6_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_6_N}]
#set_property PACKAGE_PIN Y16 [get_ports {JX1_LVDS_6_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_6_P}]
#set_property PACKAGE_PIN Y14 [get_ports {JX1_LVDS_7_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_7_N}]
#set_property PACKAGE_PIN W14 [get_ports {JX1_LVDS_7_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_7_P}]
#set_property PACKAGE_PIN U17 [get_ports {JX1_LVDS_8_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_8_N}]
#set_property PACKAGE_PIN T16 [get_ports {JX1_LVDS_8_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_8_P}]
#set_property PACKAGE_PIN W15 [get_ports {JX1_LVDS_9_N}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_9_N}]
#set_property PACKAGE_PIN V15 [get_ports {JX1_LVDS_9_P}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_LVDS_9_P}]
#set_property PACKAGE_PIN R19 [get_ports {JX1_SE_0}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_SE_0}]
#set_property PACKAGE_PIN T19 [get_ports {JX1_SE_1}]; set_property IOSTANDARD LVCMOS33 [get_ports {JX1_SE_1}]

# Bank 35, Vcco = Vadj
# Set the bank voltage for bank 35.



# Defining bank 34 Voltages and pins
set_property IOSTANDARD LVCMOS33 [get_ports -filter { IOBANK == 34 } ]
set_property PACKAGE_PIN Y14 [get_ports {B1[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B1[0]} ]
set_property PACKAGE_PIN W14 [get_ports {B1[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B1[1]} ]
set_property PACKAGE_PIN R14 [get_ports {B1[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B1[2]} ]
set_property PACKAGE_PIN P14 [get_ports {B1[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B1[3]} ]
set_property PACKAGE_PIN T12 [get_ports {B1[7]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B1[7]} ]
set_property PACKAGE_PIN U12 [get_ports {B1[6]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B1[6]} ]
set_property PACKAGE_PIN V12 [get_ports {B1[5]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B1[5]} ]
set_property PACKAGE_PIN W13 [get_ports {B1[4]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B1[4]} ]
set_property PACKAGE_PIN Y17 [get_ports {B2[7]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B2[7]} ]
set_property PACKAGE_PIN Y16 [get_ports {B2[6]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B2[6]} ]
set_property PACKAGE_PIN T15 [get_ports {B2[5]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B2[5]} ]
set_property PACKAGE_PIN T14 [get_ports {B2[4]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B2[4]} ]
set_property PACKAGE_PIN T11 [get_ports {B2[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B2[0]} ]
set_property PACKAGE_PIN T10 [get_ports {B2[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B2[1]} ]
set_property PACKAGE_PIN U13 [get_ports {B2[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B2[2]} ]
set_property PACKAGE_PIN V13 [get_ports {B2[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B2[3]} ]
set_property PACKAGE_PIN P18 [get_ports {B3[7]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B3[7]} ]
set_property PACKAGE_PIN N17 [get_ports {B3[6]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B3[6]} ]
set_property PACKAGE_PIN V18 [get_ports {B3[5]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B3[5]} ]
set_property PACKAGE_PIN V17 [get_ports {B3[4]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B3[4]} ]
set_property PACKAGE_PIN Y18 [get_ports {B3[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B3[0]} ]
set_property PACKAGE_PIN Y19 [get_ports {B3[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B3[1]} ]
set_property PACKAGE_PIN R16 [get_ports {B3[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B3[2]} ]
set_property PACKAGE_PIN R17 [get_ports {B3[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B3[3]} ]
set_property PACKAGE_PIN V16 [get_ports {B4[7]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B4[7]} ]
set_property PACKAGE_PIN W16 [get_ports {B4[6]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B4[6]} ]
set_property PACKAGE_PIN T17 [get_ports {B4[5]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B4[5]} ]
set_property PACKAGE_PIN R18 [get_ports {B4[4]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B4[4]} ]
set_property PACKAGE_PIN P16 [get_ports {B4[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B4[0]} ]
set_property PACKAGE_PIN P15 [get_ports {B4[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B4[1]} ]
set_property PACKAGE_PIN W19 [get_ports {B4[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B4[2]} ]
set_property PACKAGE_PIN W18 [get_ports {B4[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B4[3]} ]
#set_property PACKAGE_PIN R19 [get_ports {JX1_SE_0}]
#set_property PACKAGE_PIN T19 [get_ports {JX1_SE_1}]
#set_property PACKAGE_PIN U14 [get_ports {N$9}]
#set_property PACKAGE_PIN U18 [get_ports {N$10}]
#set_property PACKAGE_PIN U15 [get_ports {N$11}]
#set_property PACKAGE_PIN U19 [get_ports {N$12}]
#set_property PACKAGE_PIN N18 [get_ports {N$13}]
#set_property PACKAGE_PIN N20 [get_ports {N$14}]
#set_property PACKAGE_PIN P19 [get_ports {N$15}]
#set_property PACKAGE_PIN P20 [get_ports {N$16}]
#set_property PACKAGE_PIN T20 [get_ports {N$17}]
#set_property PACKAGE_PIN V20 [get_ports {N$18}]
#set_property PACKAGE_PIN U20 [get_ports {N$19}]
#set_property PACKAGE_PIN W20 [get_ports {N$20}]
set_property PACKAGE_PIN U17 [get_ports {TRIG1_N}]
set_property PACKAGE_PIN T16 [get_ports {TRIG1_P}]
set_property PACKAGE_PIN W15 [get_ports {TRIG2_N}]
set_property PACKAGE_PIN V15 [get_ports {TRIG2_P}]

# Defining bank 35 Voltages and pins
set_property IOSTANDARD LVCMOS33 [get_ports -filter { IOBANK == 35 } ]
set_property PACKAGE_PIN L20 [get_ports {B5[7]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B5[7]} ]
set_property PACKAGE_PIN L19 [get_ports {B5[6]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B5[6]} ]
set_property PACKAGE_PIN E19 [get_ports {B5[5]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B5[5]} ]
set_property PACKAGE_PIN E18 [get_ports {B5[4]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B5[4]} ]
set_property PACKAGE_PIN C20 [get_ports {B5[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B5[0]} ]
set_property PACKAGE_PIN B20 [get_ports {B5[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B5[1]} ]
set_property PACKAGE_PIN E17 [get_ports {B5[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B5[2]} ]
set_property PACKAGE_PIN D18 [get_ports {B5[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B5[3]} ]
set_property PACKAGE_PIN M15 [get_ports {B6[7]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B6[7]} ]
set_property PACKAGE_PIN M14 [get_ports {B6[6]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B6[6]} ]
set_property PACKAGE_PIN N16 [get_ports {B6[5]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B6[5]} ]
set_property PACKAGE_PIN N15 [get_ports {B6[4]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B6[4]} ]
set_property PACKAGE_PIN G19 [get_ports {B6[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B6[0]} ]
set_property PACKAGE_PIN G20 [get_ports {B6[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B6[1]} ]
set_property PACKAGE_PIN K14 [get_ports {B6[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B6[2]} ]
set_property PACKAGE_PIN J14 [get_ports {B6[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B6[3]} ]
set_property PACKAGE_PIN M20 [get_ports {B7[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B7[0]} ]
set_property PACKAGE_PIN M19 [get_ports {B7[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B7[1]} ]
set_property PACKAGE_PIN F17 [get_ports {B7[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B7[2]} ]
set_property PACKAGE_PIN F16 [get_ports {B7[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B7[3]} ]
set_property PACKAGE_PIN B19 [get_ports {B7[7]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B7[7]} ]
set_property PACKAGE_PIN A20 [get_ports {B7[6]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B7[6]} ]
set_property PACKAGE_PIN D19 [get_ports {B7[5]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B7[5]} ]
set_property PACKAGE_PIN D20 [get_ports {B7[4]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B7[4]} ]
set_property PACKAGE_PIN J16 [get_ports {B8[0]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B8[0]} ]
set_property PACKAGE_PIN K16 [get_ports {B8[1]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B8[1]} ]
set_property PACKAGE_PIN L15 [get_ports {B8[2]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B8[2]} ]
set_property PACKAGE_PIN L14 [get_ports {B8[3]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B8[3]} ]
set_property PACKAGE_PIN J20 [get_ports {B8[7]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B8[7]} ]
set_property PACKAGE_PIN H20 [get_ports {B8[6]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B8[6]} ]
set_property PACKAGE_PIN H15 [get_ports {B8[5]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B8[5]} ]
set_property PACKAGE_PIN G15 [get_ports {B8[4]}]; set_property IOSTANDARD LVCMOS33 [get_ports {B8[4]} ]
#set_property PACKAGE_PIN G14 [get_ports {JX2_SE_0}]
#set_property PACKAGE_PIN J15 [get_ports {JX2_SE_1}]
#set_property PACKAGE_PIN L16 [get_ports {N$25}]
#set_property PACKAGE_PIN K17 [get_ports {N$26}]
#set_property PACKAGE_PIN L17 [get_ports {N$27}]
#set_property PACKAGE_PIN K18 [get_ports {N$28}]
#set_property PACKAGE_PIN H16 [get_ports {N$29}]
#set_property PACKAGE_PIN J18 [get_ports {N$30}]
#set_property PACKAGE_PIN H17 [get_ports {N$31}]
#set_property PACKAGE_PIN H18 [get_ports {N$32}]
set_property PACKAGE_PIN G17 [get_ports {ENABLE}]; set_property IOSTANDARD LVCMOS33 [get_ports {ENABLE} ]
#set_property PACKAGE_PIN F19 [get_ports {N$34}]
#set_property PACKAGE_PIN G18 [get_ports {N$35}]
#set_property PACKAGE_PIN F20 [get_ports {N$36}]
set_property PACKAGE_PIN M18 [get_ports {TRIG3_N}]
set_property PACKAGE_PIN M17 [get_ports {TRIG3_P}]
set_property PACKAGE_PIN J19 [get_ports {TRIG4_N}]
set_property PACKAGE_PIN K19 [get_ports {TRIG4_P}]
