# Full-SoC accelerator functional test (Verilator, license-free)

`tb_soc_accel.sv` is a self-driving SystemVerilog testbench that instantiates the
complete `Didactic` SoC and lets the **Ibex core actually execute the baremetal
program `sw/accel/accel.c`**. The default `int8_16x16` program streams random
signed 8-bit matrices A/B over the system bus, starts the compute, polls
`STATUS`, reads Matrix C back, compares every element against a precomputed
golden reference, and writes a result word into data memory. Unlike the
standalone `sim/testbenches/tb_accel.sv` (which pokes the accelerator's APB
slave directly), this exercises the accelerator through the **real OBI/APB
fabric**, end to end.

It runs under open-source **Verilator** — no QuestaSim / Mentor license needed.

## Run

```sh
# from the Didactic-SoC repository root
make verilate_accel
# or directly:
python3 ./verification/verilator/verilate_soc_accel.py
```

Expected output:

```
[tb_soc_accel] reset released, core booting...
[tb_soc_accel] accel_result = acce5500
[tb_soc_accel] RESULT: PASS (core drove A/B, compute, read C over the bus)
[soc_accel] OK
```

PASS criterion: `accel.c` writes `accel_result` (data-memory word 0) =
`0xACCE5500`. A mismatch yields `0xBADD0000 | <count>`.

## Program image

The test needs the prebuilt image `verification/verilator/accel.hex`. Rebuild it
with the RISC-V toolchain:

```sh
make build_test XLEN=64 TESTCASE=accel TEST=accel   # produces build/sw/accel.hex
cp build/sw/accel.hex verification/verilator/accel.hex
```

### Test vectors (random A/B + golden C)

`accel.c` includes `sw/accel/accel_gemm_data.h`, an auto-generated header with
random signed `accel_A`/`accel_B` and the golden `accel_C = A*B` for the selected
build variant. The golden is computed with the **same signed 32-bit
two's-complement wrap** as the RTL MAC (`rtl/MAC/mac_pe.sv`), so it matches
bit-for-bit. Regenerate it (from the group5 superproject root) before rebuilding
the image when you want new vectors or switch variants:

```sh
python3 sim/common/c_code/gen_accel_data.py --variant int8_16x16
```

## How the boot works (no JTAG)

The SoC has no autonomous boot ROM. On reset the Ibex fetch-enable register is
`On`, so the core fetches from its reset vector `0x0104_0180`, which reads the
SS_Ctrl boot-ROM register `boot_reg_0` (defaults to a spin). The real flow uses
JTAG to install a jump there; this testbench emulates that by `force`-ing
`boot_reg_0 = 0xF01BF06F` (`jal x0, 0x0100_0080`), so the core jumps to the imem
reset vector, which branches to `reset_handler -> main`.

## imem/dmem preload mapping (important)

The SysCtrl OBI crossbar forwards the **full byte address** to `i_imem`, and
`sp_sram` indexes its `ram` array directly with `addr_i[11:0]` — i.e. a byte
address used as a word index. Hardware reads and writes are self-consistent, but
a flat `$readmemh(file, ram)` is **not**: program word `i` lives at byte `4*i`,
so it must be scattered to `ram[4*i]`. The data-memory result word
(`accel_result` @ byte 0) maps to `ram[0]`, so the testbench reads it as
`DMEM[0]`.
