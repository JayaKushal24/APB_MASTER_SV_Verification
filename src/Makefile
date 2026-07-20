TEST=TEST1

clean:		
	rm -rf work transcript
	rm -rf CovReport
	clear
	@echo "CLEARED OLD COMPILATIONS "
compile:	
	#vlog package.svh
	#vlog tb.sv
	vlog +define+$(TEST) ./testbench/package.svh
	vlog +define+$(TEST) ./testbench/tb.sv
run:		
	vsim -c top -do "run -all"

all:	clean compile run

