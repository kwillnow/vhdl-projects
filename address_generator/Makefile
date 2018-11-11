SIM_FLAGS ?= -R

all:
	@echo "vhdl work ./address_generator.vhd" > address_generator.prj
	@echo "vhdl work ./address_generator_tb.vhd" >> address_generator.prj
	xvhdl --nolog -prj address_generator.prj
	xelab work.address_generator_tb --nolog -prj address_generator.prj -debug all
	xsim --nolog work.address_generator_tb $(SIM_FLAGS)

clean:
	@rm -rf *.prj *.log *.pb xsim.dir .Xil *.jou *.wdb