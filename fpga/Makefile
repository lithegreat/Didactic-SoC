######################################
# Didactic SoC 
# FPGA flow makefile
# Contributor(s):
#   -Matti Käyrä (matti.kayra@tuni.fi)
######################################

SHELL = bash
VIVADO ?= vivado

TEST ?= accel

export BUILD_DIR ?= ../build
export PROJECT ?= z1

ACCEL_CONFIG ?= ../../sim/common/c_code/accel_config.py

# Physical systolic-array variant compiled into the bitstream. 16x16 saturates
# the PYNQ-Z1 (LUT > 100%); use the named 8x8 variant to fit. Override e.g.:
#   make all_xilinx ACCEL_VARIANT=int8_8x8
# or directly:
#   make all_xilinx ACCEL_DIM=8 ACCEL_DATA_W=8
export ACCEL_VARIANT ?= int8_8x8
export ACCEL_DIM ?= $(shell python3 $(ACCEL_CONFIG) --variant $(ACCEL_VARIANT) --format shell | sed -n 's/^ACCEL_DIM=//p')
export ACCEL_DATA_W ?= $(shell python3 $(ACCEL_CONFIG) --variant $(ACCEL_VARIANT) --format shell | sed -n 's/^ACCEL_DATA_W=//p')

check_env:
	mkdir -p $(BUILD_DIR)
	@echo "ACCEL_VARIANT=$(ACCEL_VARIANT) ACCEL_DIM=$(ACCEL_DIM) ACCEL_DATA_W=$(ACCEL_DATA_W)"

all_xilinx: check_env
	cd $(BUILD_DIR)
	$(VIVADO) -mode batch -notrace -source ../fpga/scripts/run_xilinx.tcl  

all_xilinx_gui: check_env
	cd $(BUILD_DIR)
	$(VIVADO) -mode gui -source ../fpga/scripts/run_xilinx.tcl &

load_elf: check_env
	riscv64-unknown-elf-gdb $(BUILD_DIR)/fpga/sw/$(TEST).elf -x ../fpga/utils/connect-and-load.gdb
