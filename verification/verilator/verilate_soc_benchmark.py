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

        # Automatically print UART benchmark results
        trace_path = Path("trace_core_00000000.log")
        if trace_path.exists():
            chars = []
            with open(trace_path, "r", encoding="utf-8", errors="ignore") as f:
                for line in f:
                    if "PA:0x01030100 store:" in line:
                        idx = line.find("PA:0x01030100 store:")
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
                print("".join(chars).strip())
                print(
                    Fore.YELLOW
                    + "--------------------------------------\n"
                    + Style.RESET_ALL
                )
        return 0
    print(Fore.RED + "[benchmark] FAIL" + Style.RESET_ALL)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
