# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "C_S_AXIL_ADDR_WIDTH"
  ipgui::add_param $IPINST -name "C_M_AXIF_WUSER_WIDTH"
  ipgui::add_param $IPINST -name "C_M_AXIF_RUSER_WIDTH"
  ipgui::add_param $IPINST -name "C_M_AXIF_ID_WIDTH"
  ipgui::add_param $IPINST -name "C_M_AXIF_BUSER_WIDTH"
  ipgui::add_param $IPINST -name "C_M_AXIF_AWUSER_WIDTH"
  ipgui::add_param $IPINST -name "C_M_AXIF_ARUSER_WIDTH"
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "C_NO_WRITE_RESPONSE"
  ipgui::add_param $IPINST -name "C_AxCACHE"

}

proc update_PARAM_VALUE.C_AxCACHE { PARAM_VALUE.C_AxCACHE } {
	# Procedure called to update C_AxCACHE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AxCACHE { PARAM_VALUE.C_AxCACHE } {
	# Procedure called to validate C_AxCACHE
	return true
}

proc update_PARAM_VALUE.C_M_AXIF_ARUSER_WIDTH { PARAM_VALUE.C_M_AXIF_ARUSER_WIDTH } {
	# Procedure called to update C_M_AXIF_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIF_ARUSER_WIDTH { PARAM_VALUE.C_M_AXIF_ARUSER_WIDTH } {
	# Procedure called to validate C_M_AXIF_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXIF_AWUSER_WIDTH { PARAM_VALUE.C_M_AXIF_AWUSER_WIDTH } {
	# Procedure called to update C_M_AXIF_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIF_AWUSER_WIDTH { PARAM_VALUE.C_M_AXIF_AWUSER_WIDTH } {
	# Procedure called to validate C_M_AXIF_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXIF_BUSER_WIDTH { PARAM_VALUE.C_M_AXIF_BUSER_WIDTH } {
	# Procedure called to update C_M_AXIF_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIF_BUSER_WIDTH { PARAM_VALUE.C_M_AXIF_BUSER_WIDTH } {
	# Procedure called to validate C_M_AXIF_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXIF_ID_WIDTH { PARAM_VALUE.C_M_AXIF_ID_WIDTH } {
	# Procedure called to update C_M_AXIF_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIF_ID_WIDTH { PARAM_VALUE.C_M_AXIF_ID_WIDTH } {
	# Procedure called to validate C_M_AXIF_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXIF_RUSER_WIDTH { PARAM_VALUE.C_M_AXIF_RUSER_WIDTH } {
	# Procedure called to update C_M_AXIF_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIF_RUSER_WIDTH { PARAM_VALUE.C_M_AXIF_RUSER_WIDTH } {
	# Procedure called to validate C_M_AXIF_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXIF_WUSER_WIDTH { PARAM_VALUE.C_M_AXIF_WUSER_WIDTH } {
	# Procedure called to update C_M_AXIF_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIF_WUSER_WIDTH { PARAM_VALUE.C_M_AXIF_WUSER_WIDTH } {
	# Procedure called to validate C_M_AXIF_WUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_NO_WRITE_RESPONSE { PARAM_VALUE.C_NO_WRITE_RESPONSE } {
	# Procedure called to update C_NO_WRITE_RESPONSE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_NO_WRITE_RESPONSE { PARAM_VALUE.C_NO_WRITE_RESPONSE } {
	# Procedure called to validate C_NO_WRITE_RESPONSE
	return true
}

proc update_PARAM_VALUE.C_S_AXIL_ADDR_WIDTH { PARAM_VALUE.C_S_AXIL_ADDR_WIDTH } {
	# Procedure called to update C_S_AXIL_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIL_ADDR_WIDTH { PARAM_VALUE.C_S_AXIL_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXIL_ADDR_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_S_AXIL_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXIL_ADDR_WIDTH PARAM_VALUE.C_S_AXIL_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIL_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIL_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIF_ID_WIDTH { MODELPARAM_VALUE.C_M_AXIF_ID_WIDTH PARAM_VALUE.C_M_AXIF_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIF_ID_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIF_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIF_AWUSER_WIDTH { MODELPARAM_VALUE.C_M_AXIF_AWUSER_WIDTH PARAM_VALUE.C_M_AXIF_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIF_AWUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIF_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIF_ARUSER_WIDTH { MODELPARAM_VALUE.C_M_AXIF_ARUSER_WIDTH PARAM_VALUE.C_M_AXIF_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIF_ARUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIF_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIF_WUSER_WIDTH { MODELPARAM_VALUE.C_M_AXIF_WUSER_WIDTH PARAM_VALUE.C_M_AXIF_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIF_WUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIF_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIF_RUSER_WIDTH { MODELPARAM_VALUE.C_M_AXIF_RUSER_WIDTH PARAM_VALUE.C_M_AXIF_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIF_RUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIF_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIF_BUSER_WIDTH { MODELPARAM_VALUE.C_M_AXIF_BUSER_WIDTH PARAM_VALUE.C_M_AXIF_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIF_BUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIF_BUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_NO_WRITE_RESPONSE { MODELPARAM_VALUE.C_NO_WRITE_RESPONSE PARAM_VALUE.C_NO_WRITE_RESPONSE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_NO_WRITE_RESPONSE}] ${MODELPARAM_VALUE.C_NO_WRITE_RESPONSE}
}

proc update_MODELPARAM_VALUE.C_AxCACHE { MODELPARAM_VALUE.C_AxCACHE PARAM_VALUE.C_AxCACHE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AxCACHE}] ${MODELPARAM_VALUE.C_AxCACHE}
}

