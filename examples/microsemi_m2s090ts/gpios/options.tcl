#Function: fpga_device   <FPGA> [-tool <TOOL>]     Return: none
#Function: fpga_file     <FILE> [-lib <LIBRARY>]   Return: none
#Function: fpga_file     <FILE> [-top <TOPNAME>]   Return: none
#Constant: $FPGA_TOOL                              Name of the running tool

fpga_device "M2S090TS-1-fg484"  -tool "libero-soc"

fpga_file "top.vhdl" -top "Top"
fpga_file "m2s090ts.pdc"

#if {$FPGA_TOOL == "ise"} {
#   project set "FSM Encoding Algorithm" "Sequential" -process "Synthesize - XST"
#} elseif {$FPGA_TOOL == "vivado"} {
#   set_property "steps.synth_design.args.fsm_extraction" "sequential" [get_runs synth_1]
#} elseif {$FPGA_TOOL == "quartus2"} {
#   set_global_assignment -name STATE_MACHINE_PROCESSING SEQUENTIAL
#} elseif {$FPGA_TOOL == "libero-soc"} {
#
#}
