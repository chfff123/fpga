transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/g1390/Desktop/FPGA/lab3/Lecture_side/RTL {C:/Users/g1390/Desktop/FPGA/lab3/Lecture_side/RTL/Lecture_side.v}

vlog -vlog01compat -work work +incdir+C:/Users/g1390/Desktop/FPGA/lab3/Lecture_side/Quartus_prj/../Sim {C:/Users/g1390/Desktop/FPGA/lab3/Lecture_side/Quartus_prj/../Sim/tb_Lecture_side.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_Lecture_side

add wave *
view structure
view signals
run 1 sec
