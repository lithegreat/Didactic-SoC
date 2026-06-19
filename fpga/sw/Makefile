####
# Didactic SoC 
# Baremetal controller SW flow makefile
# Contributor(s):
#   -Matti Käyrä (matti.kayra@tuni.fi)
###

TESTCASE ?= accel
START_TIME=`date +%F_%H:%M`
SHELL = bash
BUILD_DIR ?= ../../build/fpga
PREFIX ?= riscv64-unknown-elf
CC=$(PREFIX)-gcc
CFLAGS=-mabi=ilp32 -Os -g -ffunction-sections -fdata-sections -Icommon/
ELF2HEX_BIN ?= $(PREFIX)-elf2hex
TEST_SRCS = $(wildcard $(TESTCASE)/*.c)
TEST_OBJS = $(patsubst $(TESTCASE)/%.c,$(BUILD_DIR)/sw/$(TESTCASE)_%.o,$(TEST_SRCS))

test: env build_test

env:
	mkdir -p $(BUILD_DIR)/sw
	echo "prerequisite: local install of RISCV32 toolchain + elf2hex"

$(BUILD_DIR)/sw/$(TESTCASE)_%.o: $(TESTCASE)/%.c | env
	$(CC) -march=rv32imc -D__riscv__ $(CFLAGS) -c $< -o $@

build_test: $(TEST_OBJS)
	$(CC) -march=rv32imc -D__riscv__ $(CFLAGS) -DLANGUAGE_ASSEBMLY -c common/crt0.S -o $(BUILD_DIR)/sw/crt0.o
	$(CC) -march=rv32imc -Tcommon/link.ld $(TEST_OBJS) $(BUILD_DIR)/sw/crt0.o -nostartfiles -nostdlib -Wl,--gc-sections -o $(BUILD_DIR)/sw/$(TESTCASE).elf

#hex_test:
#	$(ELF2HEX_BIN) --bit-width 32 --input $(BUILD_DIR)/sw/$(TESTCASE).elf --output $(BUILD_DIR)/sw/$(TESTCASE).hex
