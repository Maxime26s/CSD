transcript on
if ![file isdirectory vga_exemple_iputf_libs] {
	file mkdir vga_exemple_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vcom "C:/WORK/COURS/6GEI367/CODE/vga_exemple/vga_pll_sim/vga_pll.vho"

vcom -93 -work work {C:/WORK/COURS/6GEI367/CODE/vga_exemple/VGA_green.vhd}

vcom -93 -work work {C:/WORK/COURS/6GEI367/CODE/vga_exemple/simulation/modelsim/VGA_green_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  VGA_green_tb

add wave *
view structure
view signals
run -all
