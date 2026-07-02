#!/usr/bin/env python3
# -----------------------------------------------------------------------------
# verilate_soc_benchmark.py -- Build + run the CPU-vs-Accelerator GEMM
# benchmark in full-SoC Verilator simulation.
#
# Boots the Ibex core on sw/benchmark/benchmark.c, which:
#   1. Runs a CPU-only naive GEMM and records Ibex mcycle elapsed.
#   2. Runs the same GEMM through the systolic-array accelerator via APB and
#      records total elapsed mcycles + hardware perf counter.
#   3. Prints cycle counts and speedup over the simulated UART.
#   4. Writes a result word to bench_result:
#        0xBEEFXXXX -> PASS, speedup = XXXX/100  (e.g. 0xBEEF0342 = 3.42x)
#        0xBADDXXXX -> failure code
#
# Reuses the same Verilator file-list as verilate_soc_accel.py.
# Run from the Didactic-SoC repository root:
#   python3 ./verification/verilator/verilate_soc_benchmark.py
#
# The program hex must be pre-built with the RISC-V toolchain:
#   make -C sw build_test hex_test TESTCASE=benchmark
#   # This produces build/sw/benchmark.hex (see sw/Makefile)
#
# Override the hex path if your build directory differs:
#   BENCH_HEX=/path/to/benchmark.hex python3 verilate_soc_benchmark.py
# -----------------------------------------------------------------------------
import os
import subprocess as sp
from pathlib import Path

from colorama import Fore, Style

from verilate import MANUAL_FILES, VERILATOR_CONFIG_PATH

VERILATOR_DIR = Path(__file__).parent
TB_FILE = VERILATOR_DIR / "src" / "soc_accel" / "tb_soc_accel.sv"


# Default ELF path (built from sw/Makefile TESTCASE=benchmark)
_default_elf = Path(__file__).parent.parent.parent / "build" / "sw" / "benchmark.elf"
ELF_FILE = Path(os.environ.get("BENCH_ELF", str(_default_elf)))


def _nm_symbols(elf: Path) -> dict:
    """Return {name: address} for all text/data symbols in *elf*."""
    out = sp.check_output(["nm", str(elf)], text=True, stderr=sp.DEVNULL)
    syms = {}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) >= 3:
            try:
                syms[parts[2]] = int(parts[0], 16)
            except ValueError:
                pass
    return syms


def _parse_wall_cycles(trace_path: Path, elf: Path):
    """
    Parse the Ibex instruction trace to obtain wall-clock cycle counts for:

      cpu_cyc   – first store to cpu_out[0] … last store to cpu_out[M*N-1]
                  (pure CPU GEMM loop, excluding init and prints)

      accel_cyc – entry to accel_run_tiled_gemm …
                  first instruction back in main() after it returns

    Returns (cpu_cyc, accel_cyc) or (0, 0) on parse failure.
    """
    if not trace_path.exists() or not elf.exists():
        return 0, 0

    syms = _nm_symbols(elf)
    main_addr        = syms.get("main", 0)
    tiled_addr       = syms.get("accel_run_tiled_gemm", 0)
    cpu_out_base     = syms.get("cpu_out.0", 0)
    # cpu_out holds ACC_M * ACC_N int32_t values; derive size from accum symbol
    accum_addr       = syms.get("accum", 0)
    cpu_out_end      = accum_addr if accum_addr > cpu_out_base else cpu_out_base + 0x400
    post_main_addr   = syms.get("postMain", main_addr + 0x300)

    cpu_start = cpu_end = None          # cycles bracketing the CPU GEMM loop
    accel_start = accel_end = None      # cycles bracketing the accel path
    tiled_visited = False

    PA_TAG = "PA:0x"

    with open(trace_path, "r", errors="ignore") as f:
        next(f)  # skip header
        for line in f:
            cols = line.split()
            if len(cols) < 3:
                continue
            try:
                cyc = int(cols[1])
                pc  = int(cols[2], 16)
            except ValueError:
                continue

            # ── CPU GEMM: bracket by stores to cpu_out[] ──────────────────
            if accel_start is None:  # stop once accel phase begins
                pa_idx = line.find(PA_TAG)
                if pa_idx >= 0 and " store:" in line:
                    try:
                        pa = int(line[pa_idx + 5 : pa_idx + 13], 16)
                    except ValueError:
                        pa = 0
                    if cpu_out_base <= pa < cpu_out_end:
                        if cpu_start is None:
                            cpu_start = cyc
                        cpu_end = cyc

            # ── Accel path: tiled_gemm entry → return to main ─────────────
            if accel_start is None and pc == tiled_addr:
                accel_start = cyc
                tiled_visited = True

            if accel_start is not None and accel_end is None:
                if tiled_visited and main_addr <= pc < post_main_addr:
                    accel_end = cyc
                    break  # all data collected

    cpu_cyc   = (cpu_end   - cpu_start)   if (cpu_start   and cpu_end)   else 0
    accel_cyc = (accel_end - accel_start) if (accel_start and accel_end) else 0
    return cpu_cyc, accel_cyc

# Default hex location (built from sw/Makefile TESTCASE=benchmark)
_default_hex = VERILATOR_DIR / "benchmark.hex"
HEX_FILE = Path(os.environ.get("BENCH_HEX", str(_default_hex)))

# Build parallelism — default 1 to fit constrained CI runners.
VERILATOR_JOBS = os.environ.get("VERILATOR_JOBS", "1")

VERILATOR_ARGS = [
    "verilator",
    "--binary",
    "--timing",
    "--timescale",
    "1ns/1ps",
    "--top-module",
    "tb_soc_accel",
    "-Mdir",
    "obj_dir_soc_benchmark",
    "-j",
    VERILATOR_JOBS,
    "--output-split",
    "20000",
    "--output-split-cfuncs",
    "500",
    # Benign combinational arbitration loop in the OBI crossbar — harmless.
    "-Wno-UNOPTFLAT",
    "+define+RVFI",
    "+define+COMMON_CELLS_ASSERTS_OFF",
    # See verilate.py for why ASSERTS_OFF must also be set (prevents
    # common_cells/assertions.svh from globally leaking INC_ASSERT into
    # ibex_ex_block.sv's multdiv SVA idle generate blocks).
    "+define+ASSERTS_OFF",
    str(VERILATOR_CONFIG_PATH),
]


def main() -> int:
    if not HEX_FILE.exists():
        print(
            Fore.RED
            + f"[benchmark] missing program image: {HEX_FILE}\n"
            + "  Build with:  make -C sw build_test hex_test TESTCASE=benchmark\n"
            + "  Then copy the resulting build/sw/benchmark.hex here (or set BENCH_HEX)."
            + Style.RESET_ALL
        )
        return 1

    build = list(VERILATOR_ARGS)
    build.extend(MANUAL_FILES)
    build.append(str(TB_FILE))

    print(Fore.CYAN + "[benchmark] verilating..." + Style.RESET_ALL)
    if sp.run(build).returncode != 0:
        print(Fore.RED + "[benchmark] build FAIL" + Style.RESET_ALL)
        return 1

    run_cmd = [
        "./obj_dir_soc_benchmark/Vtb_soc_accel",
        f"+HEX={HEX_FILE}",
    ]
    print(Fore.CYAN + "[benchmark] running simulation..." + Style.RESET_ALL)
    rc = sp.run(run_cmd).returncode

    if rc == 0:
        print(Fore.GREEN + "[benchmark] PASS" + Style.RESET_ALL)

        # Decode UART output from the Ibex trace and extract hardware counters
        trace_path = Path("trace_core_00000000.log")
        hw_compute_cyc = 0
        hw_bus_cyc = 0
        chars = []
        if trace_path.exists():
            with open(trace_path, "r", encoding="utf-8", errors="ignore") as f:
                for line in f:
                    if "PA:0x01300100 store:" in line:
                        idx = line.find("PA:0x01300100 store:")
                        val_str = line[idx + 20 :].split()[0]
                        try:
                            val = int(val_str, 16)
                            if 32 <= val <= 126 or val in (9, 10, 13):
                                chars.append(chr(val))
                        except ValueError:
                            pass
            if chars:
                print(
                    Fore.YELLOW
                    + "\n--- Decoded UART Benchmark Output ---"
                    + Style.RESET_ALL
                )
                uart_text = "".join(chars).strip()
                print(uart_text)
                print(
                    Fore.YELLOW
                    + "--------------------------------------"
                    + Style.RESET_ALL
                )
                # Parse hardware cycle counts from UART output
                import re
                m = re.search(r"compute:\s+(\d+)\s+cyc", uart_text)
                if m:
                    hw_compute_cyc = int(m.group(1))
                m = re.search(r"bus:\s+(\d+)\s+cyc", uart_text)
                if m:
                    hw_bus_cyc = int(m.group(1))

        # Wall-clock cycle analysis from the Ibex instruction trace
        cpu_cyc, accel_cyc = _parse_wall_cycles(trace_path, ELF_FILE)
        if cpu_cyc and accel_cyc:
            sx = cpu_cyc / accel_cyc
            hw_total = hw_compute_cyc + hw_bus_cyc
            sw_overhead = accel_cyc - hw_total if hw_total and accel_cyc > hw_total else 0
            print(
                Fore.CYAN
                + "\n--- Wall-clock breakdown (Ibex trace) ---"
                + Style.RESET_ALL
            )
            print(f"  CPU  GEMM:   {cpu_cyc:>8} cyc  (first→last store to cpu_out[])")
            print(f"  Accel path:  {accel_cyc:>8} cyc  (accel_run_tiled_gemm entry → return to main)")
            if hw_total:
                print(f"    compute:   {hw_compute_cyc:>8} cyc  (REG_PERF_CYCLES, systolic array)")
                print(f"    bus:       {hw_bus_cyc:>8} cyc  (APB transactions x2)")
                print(f"    SW overhead:{sw_overhead:>7} cyc  (loop control, packing, accumulation)")
            print(f"  Speedup:          {sx:.2f}x  (CPU GEMM / Accel wall-clock)")
            print(Fore.CYAN + "-----------------------------------------\n" + Style.RESET_ALL)
        elif trace_path.exists():
            print(Fore.YELLOW + "[benchmark] trace parsed but phase markers not found" + Style.RESET_ALL)

        return 0
    print(Fore.RED + "[benchmark] FAIL" + Style.RESET_ALL)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
