create_project -force project_1 . -part xc7z045ffg900-2
set_property target_language VHDL [current_project]
read_ip gbt2.xci
generate_target all [get_files gbt2.xci]
