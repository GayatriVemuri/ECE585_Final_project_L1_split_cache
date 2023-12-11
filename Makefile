
ifeq ($(VERIFICATION),ON)
MAIN:Constraints MainDUT Coverage
else
MAIN:MainDUT
endif

Constraints:
	qverilog cachetest.sv

Coverage:
	vlog coverage.sv
	vsim -c top -do "coverage save -onexit MSDCOVER;run -all; q"
	vsim -c -cvgperinstance -viewcov MSDCOVER -do "coverage report -file coverage_final_report.txt -byfile -detail -noannotate -option -cvg; q"

MainDUT: 
	gcc -std=gnu99 -Wall Defines.c main.c -o cacheSim
	./cacheSim

ifeq ($(VERIFICATION),ON)
clean:
	rm -rf work/ qverilog.log dump.vcd transcript testFile.txt coverage_debug.txt coverage.txt coverage_final_report.txt MSDCOVER myapp cacheSim
	clear
else
clean:
	rm -rf work/ qverilog.log dump.vcd transcript coverage.txt coverage_debug.txt coverage_final_report.txt MSDCOVER myapp a.out
	clear
endif

