#!/usr/bin/env python3
# -----------------------------------------------------------------------------
# verilate_soc_accel.py -- Build + run the full-SoC accelerator functional test.
#
# Reuses the exact file list from verilate.py (the structural SoC smoke test),
# but swaps the top module for the self-checking SystemVerilog testbench
# tb_soc_accel, which boots the Ibex core on sw/accel/accel.c and drives the
# accelerator through the real OBI/APB fabric.
#
# License-free: open-source Verilator only.
# Run from the Didactic-SoC repository root:  python3 ./verification/verilator/verilate_soc_accel.py
#
# Memory-constrained CI: this build verilates the *entire* Didactic SoC (Ibex +
# fabric + accelerator), which is heavy.  On a small runner (e.g. ~900 MB RAM,
# no swap) the default parallel C++ compile OOMs, so the build defaults to a
# single compile job and splits the generated C++ into small translation units
# to cap peak compiler memory.  Override with env vars when running on a roomy
# host:
#   VERILATOR_JOBS=4 ./verification/verilator/verilate_soc_accel.py   (faster)
# -----------------------------------------------------------------------------
import os
import subprocess as sp
from pathlib import Path

from colorama import Fore, Style

from verilate import MANUAL_FILES, VERILATOR_CONFIG_PATH

VERILATOR_DIR = Path(__file__).parent
TB_FILE = VERILATOR_DIR / "src" / "soc_accel" / "tb_soc_accel.sv"
HEX_FILE = VERILATOR_DIR / "accel.hex"

# Build parallelism (verilation + C++ compile). Default 1 to bound peak memory
# on the constrained CI runner; raise via VERILATOR_JOBS on a larger host.
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
    "obj_dir_soc_accel",
    # Bound peak RAM: serialize compile and keep each generated C++ translation
    # unit small so no single g++ invocation blows the runner's memory budget.
    "-j",
    VERILATOR_JOBS,
    "--output-split",
    "20000",
    "--output-split-cfuncs",
    "500",
    # The OBI crossbar grant path is a benign combinational arbitration loop.
    # Verilator >=5.048 promotes this UNOPTFLAT warning to a fatal exit; it is
    # harmless here (the simulator still converges), so silence it to keep the
    # build portable across Verilator versions on the CI runner.
    "-Wno-UNOPTFLAT",
    "+define+RVFI",
    "+define+COMMON_CELLS_ASSERTS_OFF",
    str(VERILATOR_CONFIG_PATH),
]


def main() -> int:
    # The accelerator program image must exist (built with the RISC-V toolchain
    # via sw/Makefile: make build_test TESTCASE=accel + hex generation).
    if not HEX_FILE.exists():
        print(Fore.RED + f"missing program image {HEX_FILE}" + Style.RESET_ALL)
        return 1

    # MANUAL_FILES is relative to the repo root (the expected CWD). Drop the
    # example testbench's C++ main; this flow is a self-driving SV testbench.
    build = list(VERILATOR_ARGS)
    build.extend(MANUAL_FILES)
    build.append(str(TB_FILE))

    if sp.run(build).returncode != 0:
        print(Fore.RED + "[soc_accel] build FAIL" + Style.RESET_ALL)
        return 1

    run = [
        "./obj_dir_soc_accel/Vtb_soc_accel",
        f"+HEX={HEX_FILE}",
    ]
    rc = sp.run(run).returncode
    if rc == 0:
        print(Fore.GREEN + "[soc_accel] OK" + Style.RESET_ALL)
        return 0
    print(Fore.RED + "[soc_accel] FAIL" + Style.RESET_ALL)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
