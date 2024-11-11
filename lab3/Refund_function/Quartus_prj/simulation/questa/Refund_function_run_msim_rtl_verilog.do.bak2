transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/g1390/Desktop/FPGA/lab3/Refund_function/RTL {C:/Users/g1390/Desktop/FPGA/lab3/Refund_function/RTL/Refund_function.v}

vlog -vlog01compat -work work +incdir+C:/Users/g1390/Desktop/FPGA/lab3/Refund_function/Quartus_prj/../Sim {C:/Users/g1390/Desktop/FPGA/lab3/Refund_function/Quartus_prj/../Sim/tb_Refund_function.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_Refund_function

add wave *
view structure
view signals
run 1 ms
