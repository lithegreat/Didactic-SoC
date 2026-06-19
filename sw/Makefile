####
# Didactic SoC 
# Baremetal controller SW flow makefile
# Contributor(s):
#   -Matti Käyrä (matti.kayra@tuni.fi)
#   -Antti Nurmi
###

TESTCASE ?= blink
START_TIME=`date +%F_%H:%M`
SHELL = bash
BUILD_DIR ?= ../build
XLEN ?= 32
PREFIX ?= riscv$(XLEN)-unknown-elf
ARCH_FLAGS ?= -march=rv32imc -mabi=ilp32
CC=$(PREFIX)-gcc
CFLAGS=-O2 -g -ffunction-sections -fdata-sections -Icommon/
OBJDUMP ?= $(PREFIX)-objdump
OBJCOPY ?= $(PREFIX)-objcopy
TEST_SRCS = $(wildcard $(TESTCASE)/*.c)
TEST_OBJS = $(patsubst $(TESTCASE)/%.c,$(BUILD_DIR)/sw/$(TESTCASE)_%.o,$(TEST_SRCS))

env:
	mkdir -p $(BUILD_DIR)/sw
	echo "prerequisite: local install of RISCV32 toolchain + elf2hex"

$(BUILD_DIR)/sw/$(TESTCASE)_%.o: $(TESTCASE)/%.c | env
	$(CC) $(ARCH_FLAGS) -D__riscv__ $(CFLAGS) -c $< -o $@

build_test: $(TEST_OBJS)
	$(CC) $(ARCH_FLAGS) -D__riscv__ $(CFLAGS) -DLANGUAGE_ASSEBMLY -c common/crt0.S -o $(BUILD_DIR)/sw/crt0.o
	$(CC) $(ARCH_FLAGS) -Tcommon/link.ld $(TEST_OBJS) $(BUILD_DIR)/sw/crt0.o -nostartfiles -nostdlib -Wl,--gc-sections -o $(BUILD_DIR)/sw/$(TESTCASE).elf

hex_test:
	$(OBJCOPY) $(BUILD_DIR)/sw/$(TESTCASE).elf -O binary $(BUILD_DIR)/tmp.bin
	xxd -ps $(BUILD_DIR)/tmp.bin $(BUILD_DIR)/tmp.hex
	tr -d '\n' < $(BUILD_DIR)/tmp.hex > $(BUILD_DIR)/tmp_nl.hex	
	sed -r 's/(.{8})/\1\n/g' < $(BUILD_DIR)/tmp_nl.hex > $(BUILD_DIR)/tmp_be.hex
	sed -E 's/(..)(..)(..)(..)/\4\3\2\1/' < $(BUILD_DIR)/tmp_be.hex > $(BUILD_DIR)/tmp_le.hex

trim:
	head -$(shell wc -w < $(BUILD_DIR)/tmp_le.hex) $(BUILD_DIR)/tmp_le.hex > $(BUILD_DIR)/sw/$(TEST).hex

dump:
	$(OBJDUMP) $(BUILD_DIR)/sw/$(TESTCASE).elf -d > $(BUILD_DIR)/sw/$(TESTCASE).asm

cleanup:
	@rm -fr $(BUILD_DIR)/sw/*.o 
	@rm $(BUILD_DIR)/tmp*

test: env build_test hex_test trim dump cleanup
