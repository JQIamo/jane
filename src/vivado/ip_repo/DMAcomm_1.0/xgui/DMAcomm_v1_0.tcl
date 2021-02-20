# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set C_M00_AXIS_TDATA_WIDTH [ipgui::add_param $IPINST -name "C_M00_AXIS_TDATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.} ${C_M00_AXIS_TDATA_WIDTH}
  set C_M00_AXIS_START_COUNT [ipgui::add_param $IPINST -name "C_M00_AXIS_START_COUNT" -parent ${Page_0}]
  set_property tooltip {Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.} ${C_M00_AXIS_START_COUNT}
  set C_S00_AXIS_TDATA_WIDTH [ipgui::add_param $IPINST -name "C_S00_AXIS_TDATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {AXI4Stream sink: Data Width} ${C_S00_AXIS_TDATA_WIDTH}

  ipgui::add_param $IPINST -name "BRAM_DEPTH"
  ipgui::add_param $IPINST -name "BRAM_WIDTH"
  ipgui::add_param $IPINST -name "ADDR_MONITOR_WIDTH"
  ipgui::add_param $IPINST -name "LOW_BANK_LIMIT"
  ipgui::add_param $IPINST -name "HIGH_BANK_LIMIT"

}

proc update_PARAM_VALUE.ADDR_MONITOR_WIDTH { PARAM_VALUE.ADDR_MONITOR_WIDTH } {
	# Procedure called to update ADDR_MONITOR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_MONITOR_WIDTH { PARAM_VALUE.ADDR_MONITOR_WIDTH } {
	# Procedure called to validate ADDR_MONITOR_WIDTH
	return true
}

proc update_PARAM_VALUE.BRAM_DEPTH { PARAM_VALUE.BRAM_DEPTH } {
	# Procedure called to update BRAM_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BRAM_DEPTH { PARAM_VALUE.BRAM_DEPTH } {
	# Procedure called to validate BRAM_DEPTH
	return true
}

proc update_PARAM_VALUE.BRAM_WIDTH { PARAM_VALUE.BRAM_WIDTH } {
	# Procedure called to update BRAM_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BRAM_WIDTH { PARAM_VALUE.BRAM_WIDTH } {
	# Procedure called to validate BRAM_WIDTH
	return true
}

proc update_PARAM_VALUE.HIGH_BANK_LIMIT { PARAM_VALUE.HIGH_BANK_LIMIT } {
	# Procedure called to update HIGH_BANK_LIMIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HIGH_BANK_LIMIT { PARAM_VALUE.HIGH_BANK_LIMIT } {
	# Procedure called to validate HIGH_BANK_LIMIT
	return true
}

proc update_PARAM_VALUE.LOW_BANK_LIMIT { PARAM_VALUE.LOW_BANK_LIMIT } {
	# Procedure called to update LOW_BANK_LIMIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LOW_BANK_LIMIT { PARAM_VALUE.LOW_BANK_LIMIT } {
	# Procedure called to validate LOW_BANK_LIMIT
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M00_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_START_COUNT { PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to update C_M00_AXIS_START_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_START_COUNT { PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to validate C_M00_AXIS_START_COUNT
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S00_AXIS_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_START_COUNT { MODELPARAM_VALUE.C_M00_AXIS_START_COUNT PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_START_COUNT}] ${MODELPARAM_VALUE.C_M00_AXIS_START_COUNT}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.BRAM_DEPTH { MODELPARAM_VALUE.BRAM_DEPTH PARAM_VALUE.BRAM_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAM_DEPTH}] ${MODELPARAM_VALUE.BRAM_DEPTH}
}

proc update_MODELPARAM_VALUE.BRAM_WIDTH { MODELPARAM_VALUE.BRAM_WIDTH PARAM_VALUE.BRAM_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAM_WIDTH}] ${MODELPARAM_VALUE.BRAM_WIDTH}
}

proc update_MODELPARAM_VALUE.ADDR_MONITOR_WIDTH { MODELPARAM_VALUE.ADDR_MONITOR_WIDTH PARAM_VALUE.ADDR_MONITOR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_MONITOR_WIDTH}] ${MODELPARAM_VALUE.ADDR_MONITOR_WIDTH}
}

proc update_MODELPARAM_VALUE.LOW_BANK_LIMIT { MODELPARAM_VALUE.LOW_BANK_LIMIT PARAM_VALUE.LOW_BANK_LIMIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LOW_BANK_LIMIT}] ${MODELPARAM_VALUE.LOW_BANK_LIMIT}
}

proc update_MODELPARAM_VALUE.HIGH_BANK_LIMIT { MODELPARAM_VALUE.HIGH_BANK_LIMIT PARAM_VALUE.HIGH_BANK_LIMIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HIGH_BANK_LIMIT}] ${MODELPARAM_VALUE.HIGH_BANK_LIMIT}
}

