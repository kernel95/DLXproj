#################################################
#		Analyze Datapath			     		#
#################################################


exec mkdir -p reports
exec mkdir -p work

#Fetch Stage
analyze -library WORK -format vhdl {./DataPath/Fetch/register_generic.vhd}
analyze -library WORK -format vhdl {./DataPath/Fetch/adder_genericu.vhd}
analyze -library WORK -format vhdl {./DataPath/Fetch/fetch_stage_wrapper.vhd}
#Decode Stage
analyze -library WORK -format vhdl {./DataPath/Decode/or_gate.vhd}
analyze -library WORK -format vhdl {./DataPath/Decode/window_rf.vhd}
analyze -library WORK -format vhdl {./DataPath/Decode/sign_ext.vhd}
analyze -library WORK -format vhdl {./DataPath/Decode/adder_generic.vhd}
analyze -library WORK -format vhdl {./DataPath/Decode/comparator_addr.vhd}
analyze -library WORK -format vhdl {./DataPath/Decode/Decode_wrapper.vhd}
#Execute Stage
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/xor2.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/or2.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/and2.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/vp.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/half_adder.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/fa.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/full_adder.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/g_block.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/pg_block.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/g_block_carry.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/MUX21.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/mux31.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/MUX41.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/MUX81.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/pg_net.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/rca.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/rca_signed.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/carry_generator.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/carry_select_adder.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/sparse_tree_adder.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/zero_comparator.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/shifter.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/shift.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/shifter_wrapper.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/logic_op_unit.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/adder_wrapper.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/ALU_decoder.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/boothmul.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/mul_wrapper.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/ALU.vhd}
analyze -library WORK -format vhdl {./DataPath/Execute_wrapper/execute_stage_wrapper.vhd}
#Memory Stage
analyze -library WORK -format vhdl {./DataPath/Memory/memory_unit_wrapper.vhd}
#Writeback Stage
analyze -library WORK -format vhdl {./DataPath/Writeback/writeback_unit.vhd}


#################################################
#		Set the clock constrain					#
#################################################

proc set_custom_clock {} {
	#Clock 1.0=>1.0, 1.2=>0.833, 1.4=>0.714, 1.5=>0.666, 1.6=>0.625
	set WCP 0.625
	create_clock -name "CLOCK" -period $WCP clk
	set_max_delay $WCP -from [all_inputs] -to [all_outputs]
	set max_fanout 32
	set minbit 1
	set_clock_gating_style -minimum_bitwidth $minbit -max_fanout $max_fanout -control_point before -positive_edge_logic {latch and}
}

#################################################
#		Elaborate&Compile			     		#
#################################################

#Fetch Stage
elaborate fetch_stage_wrapper -architecture structural -library WORK -parameters "nwords = 64, nbit = 32"
set_wire_load_model -name 5K_hvratio_1_4
set_custom_clock
compile_ultra -timing_high_effort_script -no_autoungroup -gate_clock
report_timing > reports/fetch_stage_timing.txt
report_area > reports/fetch_stage_area.txt
report_power > reports/fetch_stage_power.txt

#Decode Stage
elaborate Decode_wrapper -architecture Behavioral -library WORK
set_wire_load_model -name 5K_hvratio_1_4
set_custom_clock
compile_ultra -timing_high_effort_script -no_autoungroup -gate_clock
report_timing > reports/decode_stage_timing.txt
report_area > reports/decode_stage_area.txt
report_power > reports/decode_stage_power.txt

#Execute Stage
elaborate execute_stage_wrapper -architecture Behavioral -library WORK -parameters "NBIT = 32, N = 32"
set_wire_load_model -name 5K_hvratio_1_4
set WCP 0.625
set_max_delay $WCP -from [all_inputs] -to [all_outputs]
compile_ultra -timing_high_effort_script -no_autoungroup -gate_clock
report_timing > reports/execute_stage_timing.txt
report_area > reports/execute_stage_area.txt
report_power > reports/execute_stage_power.txt

#Memory Stage
elaborate memory_unit -architecture Structural -library WORK -parameters "nbit = 32, nwords = 64"
set_wire_load_model -name 5K_hvratio_1_4
set WCP 0.625
set_max_delay $WCP -from [all_inputs] -to [all_outputs]
compile_ultra -timing_high_effort_script -no_autoungroup -gate_clock
report_timing > reports/memory_stage_timing.txt
report_area > reports/memory_stage_area.txt
report_power > reports/memory_stage_power.txt

#Writeback Stage
elaborate writeback_unit -architecture Structural -library WORK -parameters "N = 32"
set_wire_load_model -name 5K_hvratio_1_4
set WCP 0.625
set_max_delay $WCP -from [all_inputs] -to [all_outputs]
compile_ultra -timing_high_effort_script -no_autoungroup -gate_clock
report_timing > reports/writeback_stage_timing.txt
report_area > reports/writeback_stage_area.txt
report_power > reports/writeback_stage_power.txt

#################################################
#		Complete DLX							#
#################################################

#ControlUnit
analyze -library WORK -format vhdl {./ControlUnit/CU_wrapper/myTypes.vhd}
analyze -library WORK -format vhdl {./ControlUnit/CU_wrapper/CU_HW.vhd}
analyze -library WORK -format vhdl {./ControlUnit/CU_wrapper/CU_wrapper.vhd}

#HazardUnit
analyze -library WORK -format vhdl {./HazardUnit/hazard_detection_unit.vhd}

#DLX wrapper
analyze -library WORK -format vhdl {./DLX.vhd}

elaborate DLX -architecture Behavioral -library WORK -parameters "nwords = 64, isize = 32"
set_wire_load_model -name 5K_hvratio_1_4
set_custom_clock
compile_ultra -timing_high_effort_script -no_autoungroup -gate_clock

#################################################
#		Post-synthesis design					#
#################################################

write -hierarchy -format vhdl -output DLX_nwords64_isize32.vhd
write -hierarchy -format verilog -output DLX_nwords64_isize32.v
write_sdc DLX_nwords64_isize32.sdc

