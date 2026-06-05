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
# -----------------------------------------------------------------------------
import subprocess as sp
from pathlib import Path

from colorama import Fore, Style

from verilate import MANUAL_FILES, VERILATOR_CONFIG_PATH

VERILATOR_DIR = Path(__file__).parent
TB_FILE = VERILATOR_DIR / "src" / "soc_accel" / "tb_soc_accel.sv"
HEX_FILE = VERILATOR_DIR / "accel.hex"

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
