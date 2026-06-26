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
# Boots the Ibex core on sw/benchmark/benchmark.c, measures bus cycles
# (APB writes+reads x2) and compute cycles (REG_PERF_CYCLES) separately,
# then prints speedup over the simulated UART.
# Requires the prebuilt program image verification/verilator/benchmark.hex.
# To rebuild it (requires the xpack riscv-none-elf toolchain):
#   make -C sw build_test TESTCASE=benchmark CFLAGS="-O2 -g -ffunction-sections -fdata-sections -Icommon/ -Ibenchmark/ -Iaccel/ -DACC_DIM=16"
#   objcopy build/sw/benchmark.elf --only-section=.text -O binary build/tmp.bin
#   xxd -ps build/tmp.bin | tr -d '\n' | sed -r 's/(.{8})/\1\n/g' | sed -E 's/(..)(..)(..)(..)/\4\3\2\1/' > verification/verilator/benchmark.hex
.PHONY: verilate_benchmark
verilate_benchmark:
	@python3 ./verification/verilator/verilate_soc_benchmark.py

