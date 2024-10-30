transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/FPGA/running_light/RTL {D:/FPGA/running_light/RTL/running_light.v}

vlog -vlog01compat -work work +incdir+D:/FPGA/running_light/Quartus_prj/../Sim {D:/FPGA/running_light/Quartus_prj/../Sim/tb_running_light.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_running_light

add wave *
view structure
view signals
run 2 sec
