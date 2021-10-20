#Datapath
#Fetch
vcom -reportprogress 300 -work work./DataPath/Fetch/register_generic.vhd
vcom -reportprogress 300 -work work./DataPath/Fetch/adder_genericu.vhd
vcom -reportprogress 300 -work work./DataPath/Fetch/instruction_ram.vhd
vcom -reportprogress 300 -work work./DataPath/Fetch/fetch_stage_wrapper.vhd

#Decode
vcom -reportprogress 300 -work work./DataPath/Decode/or_gate.vhd
vcom -reportprogress 300 -work work./DataPath/Decode/window_rf.vhd
vcom -reportprogress 300 -work work./DataPath/Decode/sign_ext.vhd
vcom -reportprogress 300 -work work./DataPath/Decode/adder_generic.vhd
vcom -reportprogress 300 -work work./DataPath/Decode/comparator_addr.vhd
vcom -reportprogress 300 -work work./DataPath/Decode/Decode_wrapper.vhd

#Execute
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/xor2.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/or2.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/and2.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/vp.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/half_adder.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/fa.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/full_adder.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/g_block.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/pg_block.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/g_block_carry.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/MUX21.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/mux31.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/MUX41.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/MUX81.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/pg_net.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/rca.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/rca_signed.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/carry_generator.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/carry_select_adder.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/sparse_tree_adder.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/zero_comparator.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/shifter.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/shift.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/shifter_wrapper.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/logic_op_unit.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/adder_wrapper.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/ALU_decoder.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/boothmul.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/mul_wrapper.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/ALU.vhd
vcom -reportprogress 300 -work work./DataPath/Execute_wrapper/execute_stage_wrapper.vhd

#Memory
vcom -reportprogress 300 -work work./DataPath/Memory/data_ram.vhd
vcom -reportprogress 300 -work work./DataPath/Memory/memory_unit_wrapper.vhd

#Writeback
vcom -reportprogress 300 -work work./DataPath/Writeback/writeback_unit.vhd

#Datapath wrapper
vcom -reportprogress 300 -work work./DataPath/DataPath_wrapper.vhd

#ControlUnit
vcom -reportprogress 300 -work work./ControlUnit/CU_wrapper/myTypes.vhd
vcom -reportprogress 300 -work work./ControlUnit/CU_wrapper/CU_HW.vhd
vcom -reportprogress 300 -work work./ControlUnit/CU_wrapper/CU_wrapper.vhd

#HazardUnit
vcom -reportprogress 300 -work work./HazardUnit/hazard_detection_unit.vhd

#DLX wrapper
vcom -reportprogress 300 -work work./DLX.vhd