TEST=TEST1

clean:		
	rm -rf work transcript
	rm -rf covReport
	rm -rf *.log
	rm -rf *.ucdb
	clear
	@echo "CLEARED OLD COMPILATIONS "
compile:	
	#vlog package.svh
	#vlog tb.sv
	vlog +define+$(TEST) ./testbench/package.svh
	vlog +define+$(TEST) ./testbench/tb.sv

cover:
	vlog +define+$(TEST) ./testbench/package.svh
	vlog -sv +acc +cover +fcover +define+$(TEST)  -l verif_log.log ./testbench/tb.sv
	vsim -vopt work.top  -voptargs=+acc=npr -assertdebug -l verif_log.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll verif_ucdb.ucdb; run -all; exit"
	vcover report -html verif_ucdb.ucdb -htmldir covReport -details

run:	clean compile		
	vsim -c top -do "run -all"

all:	clean cover
