#Datapath
#Fetch
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Fetch/register_generic.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Fetch/adder_genericu.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Fetch/instruction_ram.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Fetch/fetch_stage_wrapper.vhd}

#Decode
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/or_gate.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/window_rf.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/sign_ext.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/adder_generic.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/comparator_addr.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Decode/Decode_wrapper.vhd}

#Execute
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

#Memory
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Memory/data_ram.vhd}
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Memory/memory_unit_wrapper.vhd}

#Writeback
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/Writeback/writeback_unit.vhd}

#Datapath wrapper
analyze -library WORK -format vhdl {/home/ms21.27/Synthesis/DLXproj/DataPath/DataPath_wrapper.vhd}



