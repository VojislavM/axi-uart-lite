# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z020clg484-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/voja/psdsProject/project_1/project_1.cache/wt [current_project]
set_property parent.project_path C:/Users/voja/psdsProject/project_1/project_1.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property ip_repo_paths c:/Users/voja/psdsProject/ip_repo/simpleMultiplier_1.0 [current_project]
read_vhdl -library xil_defaultlib C:/Users/voja/psdsProject/project_1/project_1.srcs/sources_1/new/TX_control.vhd
synth_design -top TX_control -part xc7z020clg484-1
write_checkpoint -noxdef TX_control.dcp
catch { report_utilization -file TX_control_utilization_synth.rpt -pb TX_control_utilization_synth.pb }