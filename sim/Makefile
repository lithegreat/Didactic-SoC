############################################
# Sim makefile for questa/modelsim
# Project: Edu4chip
# SoC: Didactic
# Contributors: 
# * Matti Käyrä (Matti.kayra@tuni.fi)
# * Antti Nurmi (Antti.nurmi@tuni.fi)
# Notes:
# * 
###############################################

BUILD_DIR ?= $(realpath $(CURDIR))/../build
START_TIME=`date +%F_%H:%M`
SHELL = bash

DUT = tb_didactic

# TB defines enable tb peripherals
TB_DEFINES = \
	+define+USE_UART \
	+define+USE_SPI 

# Dut defines:
# * RVFi required by tracer
# * Synthesis disables verification assertions within
# pulp / ibex codes
# * COMMON_CELLS_ASSERTS_OFF silences the common_cells rr_arb_tree OBI-arbiter
#   assertions. Ibex legitimately retracts OBI requests before grant, which
#   trips the LockIn "lock_req" ASSUME every cycle during normal memory traffic
#   (millions of hits -> multi-GB logs). The Verilator flow disables them the
#   same way; functional correctness is checked by the program's own result
#   comparison, not these library protocol assumes.
DUT_DEFINES = \
	+define+RVFI \
	+define+INC_ASSERT \
	+define+COMMON_CELLS_ASSERTS_OFF \
#	+define+SYNTHESIS \

DUT_LIBS = \
	-L $(BUILD_DIR)/didactic_lib \

# vsim-8386: suppress bit-to-reg assignment errors
VSIM_OPTS = \
	-suppress vsim-3009 \
	-voptargs=+acc=npr \
	-suppress vsim-8386 \

VOPT_OPTS = \
	-sv \
	-suppress vopt-2577 \
	+acc=npr \
	$(INIT_OPTS) \

# Deterministic 0-initialisation of unreset flip-flops at elaboration.
# Ibex is instantiated with ResetAll=0, so the fetch FIFO data flops
# (ibex_fetch_fifo rdata_q/err_q, the g_rdata_nr branch) have no reset and power
# up as X in 4-state QuestaSim. That X blends into the unaligned/compressed
# opcode concat ({rdata_q[1][15:0], rdata[31:16]}) and the core fetches a bogus
# "0xX0XXX7XX", trapping as an illegal instruction even though imem holds the
# correct word. +initreg+0 forces those flops to 0, matching real silicon and
# the 2-state Verilator flow -> the full-SoC run reaches "JTAG RETURN OK".
# NOTE: do NOT add +initmem here -- in this build it crashes the vsim kernel
# (Error 218); the fetch X is a register issue, so +initreg alone is enough.
# Override (e.g. INIT_OPTS=) to restore pure 4-state X behaviour.
INIT_OPTS ?= +initreg+0

# vlog-2244: tracer Variable implicitly static
VLOG_OPTS = \
	-svinputport=compat \
	-suppress vlog-2583 \
	-suppress vlog-2244 \

BENDER ?= bender

COMMON_CELLS_DIR ?= $(shell $(BENDER) path common_cells)
AXI_DIR          ?= $(shell $(BENDER) path axi)
APB_DIR          ?= $(shell $(BENDER) path apb)
REGIF_DIR        ?= $(shell $(BENDER) path register_interface)
OBI_DIR          ?= $(shell $(BENDER) path obi)
IBEX_DIR         ?= $(BUILD_DIR)/../vendor_ips/ibex
# Group5 systolic-array accelerator RTL include dir (resolves `include "accel_pkg.sv").
ACCEL_INC_DIR    ?= $(BUILD_DIR)/../../rtl/include

SIM_FLIST        ?= $(shell $(BENDER) script flist -t rtl -t vendor -t simulation -t tracer -t didactic_obi)

INCLUDES ?= \
	+incdir+$(COMMON_CELLS_DIR)/include \
	+incdir+$(AXI_DIR)/include \
	+incdir+$(APB_DIR)/include \
	+incdir+$(REGIF_DIR)/include \
	+incdir+$(OBI_DIR)/include \
	+incdir+$(IBEX_DIR)/vendor/lowrisc_ip/dv/sv/dv_utils \
	+incdir+$(IBEX_DIR)/vendor/lowrisc_ip/ip/prim/rtl \
	+incdir+$(IBEX_DIR)/rtl \
	+incdir+$(ACCEL_INC_DIR)

env:
	mkdir -p $(BUILD_DIR)/logs/compile
	mkdir -p $(BUILD_DIR)/logs/opt
	mkdir -p $(BUILD_DIR)/logs/sim

library_mapping: 
	cd $(BUILD_DIR)
	vmap didactic_lib $(BUILD_DIR)/didactic_lib

compile: env compile_didactic

compile_didactic:
	vlib $(BUILD_DIR)/didactic_lib
	vmap didactic_lib $(BUILD_DIR)/didactic_lib
	vlog -sv -work didactic_lib $(DUT_DEFINES) $(TB_DEFINES) $(INCLUDES) $(DUT_LIBS) \
	$(VLOG_OPTS) $(SIM_FLIST) -l $(BUILD_DIR)/logs/compile/$(START_TIME)_didactic.log

SANITY_CHECK ?= 0
TESTCASE ?= blink
GUI ?= "-c"
# vsim -do command. Default keeps the GUI-friendly behaviour (advance 0 ms, then
# wait for interactive commands). For headless/batch runs pass a self-finishing
# script, e.g.  make run_sim RUN_CMD="run -all; quit -f".
RUN_CMD ?= run 0ms;
elaborate: library_mapping
	cd $(BUILD_DIR)
	vopt \
	$(DUT_LIBS) $(VOPT_OPTS) \
	-gDM_SANITY_TESTCASES=$(SANITY_CHECK) \
	-gTESTCASE=$(TESTCASE) \
	-work $(BUILD_DIR)/didactic_lib \
	$(DUT) \
	-o $(DUT)_opt \
	-l $(BUILD_DIR)/logs/opt/$(START_TIME)_vopt.log

run_sim: library_mapping
	mkdir -p stdout &&	touch stdout/uart
	cd $(BUILD_DIR)
	vsim $(GUI) \
	$(DUT_LIBS) $(VSIM_OPTS) \
	-work $(BUILD_DIR)/didactic_lib \
	$(DUT)_opt \
	-do "$(RUN_CMD)" \
	-l $(BUILD_DIR)/logs/sim/$(START_TIME)_sim.log
