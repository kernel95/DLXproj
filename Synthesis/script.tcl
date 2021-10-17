gui_start
source "/home/ms21.27/Synthesis/dlx_load.tcl"
elaborate DLX -architecture BEHAVIORAL -library WORK -parameters "nwords = 64, isize = 32"
compile_ultra -no_autoungroup -timing_high_effort_script
change_selection -name __slctBus6 -type {cell design} _sel936
change_selection -name __slctBus10 -type {cell design} _sel961
change_selection -name __slctBus13 -type {cell design} _sel1010
compile_ultra -top -timing_high_effort_script
write -hierarchy -format vhdl -output /home/ms21.27/Synthesis/SynthesizedDesigns/DLX_nword64_isizes32.vhdl
compile -top
remove_design -designs
source "/home/ms21.27/Synthesis/dlx_load.tcl"
elaborate DLX -architecture BEHAVIORAL -library WORK -parameters "nwords = 64, isize = 32"
uplevel #0 check_design -summary
compile_ultra -top -timing_high_effort_script
write -hierarchy -format vhdl -output /home/ms21.27/Synthesis/SynthesizedDesigns/dsd.vhdl
compile -exact_map
compile -exact_map
write -hierarchy -format vhdl -output /home/ms21.27/Synthesis/SynthesizedDesigns/dsd.vhdl
elaborate DLX -architecture BEHAVIORAL -library WORK -parameters "nwords = 64, isize = 32" -update
compile -exact_map
write -format vhdl -output /home/ms21.27/Synthesis/SynthesizedDesigns/DLX_nwords64_isize32.vhdl
write -hierarchy -format vhdl -output /home/ms21.27/Synthesis/SynthesizedDesigns/DLX_nwords64_isize32.vhdl