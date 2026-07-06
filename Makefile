########################################
# Top repository makefile
# Project: Edu4chip
# SoC: Didactic
#
# Description:
# * Top level commands to enable "make <command>"
# -style automated workflows.
#
# Contributors: 
# * Matti Käyrä (Matti.kayra@tuni.fi)
# * Roni Hämäläinen (roni.hamalainen@tuni.fi)
#######################################

# Common shell variables
SHELL=bash
BUILD_DIR ?= $(realpath $(CURDIR))/build/
TEST ?= blink


# Fetch submodule revisions and 
# save work in submodules to stashes - avoid data loss by accidents
repository_init:
	bender update
	bender vendor init
#	git submodule update --init --recursive

check-env:
	mkdir -p $(BUILD_DIR)/logs/compile
	mkdir -p $(BUILD_DIR)/logs/opt
	mkdir -p $(BUILD_DIR)/logs/sim

clean_build:
	rm -rf $(BUILD_DIR)

clean_ips:
	rm -fr ./.bender

clean_all: clean_build clean_ips

######################################################################
#
######################################################################
soc-rtl:
	echo "Generating SoC RTL. Check variables from scripts/run_kactus2_script.sh to be able to run Kactus2."
	source scripts/run_kactus2_script.sh -f scripts/kactus2_generate_soc_rtl.py

######################################################################
# hw targets
######################################################################

# compile hw library with chosen tools
compile: check-env
	$(MAKE) -C sim compile BUILD_DIR=$(BUILD_DIR)

# potentionally elaborate hw library with chosen tools
elaborate: check-env
	$(MAKE) -C sim elaborate BUILD_DIR=$(BUILD_DIR) TESTCASE=$(TEST)

# Potentionally split this to multiple subtasks
syn: check-env
	$(MAKE) -C syn synthesize BUILD_DIR=$(BUILD_DIR)

######################################################################
# sim targets
######################################################################

# compile hw library with chosen tools
run_sim: check-env
	$(MAKE) -C sim run_sim BUILD_DIR=$(BUILD_DIR)

######################################################################
# sw targets
######################################################################
#
build_test: check-env
	$(MAKE) -C sw test BUILD_DIR=$(BUILD_DIR) TESTCASE=$(TEST)

######################################################################
# full flow targets
######################################################################

test_all: check-env compile elaborate build_test run_sim

######################################################################
# fpga targets
######################################################################

fpga: check-env
	$(MAKE) -C fpga all_xilinx BUILD_DIR=$(BUILD_DIR)

######################################################################
# verilator targets
######################################################################

.PHONY: verilate
verilate:
	@python3 ./verification/verilator/verilate.py

# Full-SoC, bus-driven accelerator functional test (license-free, Verilator).
# Boots the Ibex core on sw/accel/accel.c and drives the systolic-array
# accelerator through the real OBI/APB fabric. Requires the prebuilt program
# image verification/verilator/accel.hex (see build_test TESTCASE=accel).
.PHONY: verilate_accel
verilate_accel:
	@python3 ./verification/verilator/verilate_soc_accel.py

# CPU vs. CPU+Accelerator GEMM benchmark (license-free, Verilator).
# Boots the Ibex core on sw/benchmark/benchmark.c, measures bus / compute
# cycles from hardware perf counters and the Ibex instruction trace, then
# prints the wall-clock speedup.
#
# One-step targets (build firmware + run sim):
#   make verilate_benchmark      — 16×16 INT8, full hardware utilisation
#   make verilate_benchmark_16   — same as above (explicit)
#   make verilate_benchmark_8    — 8×8 INT8, partial hardware utilisation
#
# Toolchain prefix — override if your riscv gcc is installed elsewhere.
BENCH_CC_PREFIX  ?= riscv-none-elf
BENCH_CFLAGS_BASE = -O2 -g -ffunction-sections -fdata-sections -Icommon/

# Internal macro: build sw/benchmark, copy hex, then run the sim.
# $(1) = ACC_DIM value   $(2) = extra CFLAGS (e.g. -DBENCH_SKIP_BUILD_INFO)
define _bench_run
	$(MAKE) -C sw PREFIX=$(BENCH_CC_PREFIX) TESTCASE=benchmark TEST=benchmark \
		CFLAGS="$(BENCH_CFLAGS_BASE) -DACC_DIM=$(1) $(2)" test
	cp build/sw/benchmark.imem.hex verification/verilator/benchmark.hex
	$(BENCH_CC_PREFIX)-nm build/sw/benchmark.elf > verification/verilator/benchmark.syms
	@python3 ./verification/verilator/verilate_soc_benchmark.py
endef

.PHONY: verilate_benchmark verilate_benchmark_16 verilate_benchmark_8

verilate_benchmark_16:
	$(call _bench_run,16,)

verilate_benchmark_8:
	$(call _bench_run,8,-DBENCH_SKIP_BUILD_INFO)

# Default: 16×16 (full hardware match).
verilate_benchmark: verilate_benchmark_16

