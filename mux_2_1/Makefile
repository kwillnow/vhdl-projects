SIM_FLAGS ?= -R

all:
	@echo "vhdl work ./mux_2_1.vhd" > mux_2_1.prj
	@echo "vhdl work ./mux_2_1_tb.vhd" >> mux_2_1.prj
	xvhdl --nolog -prj mux_2_1.prj
	xelab work.mux_2_1_tb --nolog -prj mux_2_1.prj -debug all
	xsim --nolog work.mux_2_1_tb $(SIM_FLAGS)

clean:
	@rm -rf *.prj *.log *.pb xsim.dir .Xil *.jou *.wdb