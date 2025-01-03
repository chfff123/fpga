transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/g1390/Desktop/FPGA/lab4/quartus_prj/ip_core {C:/Users/g1390/Desktop/FPGA/lab4/quartus_prj/ip_core/clk_gen.v}
vlog -vlog01compat -work work +incdir+C:/Users/g1390/Desktop/FPGA/lab4/rtl {C:/Users/g1390/Desktop/FPGA/lab4/rtl/vga_pic.v}
vlog -vlog01compat -work work +incdir+C:/Users/g1390/Desktop/FPGA/lab4/rtl {C:/Users/g1390/Desktop/FPGA/lab4/rtl/vga_ctrl.v}
vlog -vlog01compat -work work +incdir+C:/Users/g1390/Desktop/FPGA/lab4/rtl {C:/Users/g1390/Desktop/FPGA/lab4/rtl/vga_char.v}
vlog -vlog01compat -work work +incdir+C:/Users/g1390/Desktop/FPGA/lab4/quartus_prj/db {C:/Users/g1390/Desktop/FPGA/lab4/quartus_prj/db/clk_gen_altpll.v}

vlog -vlog01compat -work work +incdir+C:/Users/g1390/Desktop/FPGA/lab4/quartus_prj/../sim {C:/Users/g1390/Desktop/FPGA/lab4/quartus_prj/../sim/tb_vga_char.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_vga_char

add wave *
view structure
view signals
run 20 ms
