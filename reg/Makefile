SIM_FLAGS ?= -R

all:
	@echo "vhdl work ./reg.vhd" > reg.prj
	@echo "vhdl work ./reg_tb.vhd" >> reg.prj
	xvhdl --nolog -prj reg.prj
	xelab work.reg_tb --nolog -prj reg.prj -debug all
	xsim --nolog work.reg_tb $(SIM_FLAGS)

clean:
	@rm -rf *.prj *.log *.pb xsim.dir .Xil *.jou *.wdb