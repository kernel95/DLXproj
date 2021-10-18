#Analyze 
exec mkdir -p reports
exec mkdir -p WORK

#Fetch Stage
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Fetch/register_generic.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Fetch/adder_genericu.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Fetch/fetch_stage_wrapper.vhd}
#Decode Stage
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/or_gate.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/window_rf.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/sign_ext.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/adder_generic.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/comparator_addr.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/Decode_wrapper.vhd}
#Execute Stage
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/xor2.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/or2.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/and2.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/vp.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/half_adder.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/fa.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/full_adder.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/g_block.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/pg_block.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/g_block_carry.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/MUX21.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/mux31.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/MUX41.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/MUX81.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/pg_net.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/rca.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/rca_signed.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/carry_generator.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/carry_select_adder.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/sparse_tree_adder.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/zero_comparator.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/shifter.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/shift.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/shifter_wrapper.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/logic_op_unit.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/adder_wrapper.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/ALU_decoder.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/boothmul.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/mul_wrapper.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/ALU.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Execute_wrapper/execute_stage_wrapper.vhd}
#Memory Stage
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Memory/memory_unit_wrapper.vhd}
#Writeback Stage
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Writeback/writeback_unit.vhd}

#Elaborate
#Fetch Stage
elaborate fetch_stage_wrapper -architecture structural -library WORK -parameters "nwords = 64, nbit = 32"
set_wire_load_model -name 5K_hvratio_1_4
compile -exact_map
report_timing > reports/fetch_stage_timing.txt

#Decode Stage
elaborate Decode_wrapper -architecture Behavioral -library WORK
compile -exact_map
report_timing > reports/decode_stage_timing.txt

#Execute Stage
elaborate execute_stage_wrapper -architecture Behavioral -library WORK -parameters "NBIT = 32, N = 32"
compile -exact_map
report_timing > reports/execute_stage_timing.txt

#Memory Stage
elaborate memory_unit_wrapper -architecture Structural -library WORK -parameters "nwords = 64, isize = 32"
compile -exact_map
report_timing > reports/memory_stage_timing.txt

#Writeback Stage
elaborate writeback_unit -architecture Structural -library WORK -parameters "NBIT = 32"
compile -exact_map
report_timing > reports/writeback_stage_timing.txt


