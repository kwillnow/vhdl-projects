SIM_FLAGS ?= -R

all:
	@echo "vhdl work ./adder.vhd" > adder.prj
	@echo "vhdl work ./adder_tb.vhd" >> adder.prj
	xvhdl --nolog -prj adder.prj
	xelab work.adder_tb --nolog -prj adder.prj -debug all
	xsim --nolog work.adder_tb $(SIM_FLAGS)

clean:
	@rm -rf *.prj *.log *.pb xsim.dir .Xil *.jou *.wdb