transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {C:/Users/msimard104/Documents/GitHub/CSD/Examen 2/Q1/seq_add_sub.vhd}

vcom -2008 -work work {C:/Users/msimard104/Documents/GitHub/CSD/Examen 2/Q1/seq_add_sub_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  seq_add_sub_tb

add wave *
view structure
view signals
run -all
