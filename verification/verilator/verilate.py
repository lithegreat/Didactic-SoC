import subprocess as sp
from copy import deepcopy
from typing import List
from pathlib import Path

from colorama import Fore, Style


class Testcase:
    def __init__(self, path: str) -> None:
        self.path = Path(path)


VERILATOR_DIR = Path(__file__).parent
TESTCASES_DIR = VERILATOR_DIR / "src"
TESTCASES: List[Testcase] = [
    Testcase("example"),
]
VERILATOR_CONFIG_PATH = VERILATOR_DIR / "verilate.vlt"
VERILATOR_ARGS = [
    "verilator",
    "--trace-vcd",
    "--cc",
    "--exe",
    "--top-module",
    "Didactic",
    "+define+RVFI",
    "+define+COMMON_CELLS_ASSERTS_OFF",
    # common_cells/include/common_cells/assertions.svh unconditionally defines
    # INC_ASSERT unless ASSERTS_OFF is set. That macro is global preprocessor
    # state, so once any common_cells file pulls it in, it also enables the
    # (otherwise Verilator-guarded) assertion-only SVA idle-signal generate
    # blocks in vendor_ips/ibex/rtl/ibex_ex_block.sv, which then require the
    # unbuilt ibex_multdiv_slow module. Disable it explicitly.
    "+define+ASSERTS_OFF",
    str(VERILATOR_CONFIG_PATH),
]
MANUAL_FILES = [
    # This has to be selected explicitely, otherwise verilator crashes...
    "./src/rtl/obi_sram.sv",
    "./.bender/git/checkouts/obi-cbdec09f22f66762/src/obi_xbar.sv",
    "-I./vendor_ips/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/",
    "-I./vendor_ips/ibex/dv/uvm/core_ibex/common/prim/",
    "-I./vendor_ips/ibex/syn/rtl/",
    # prim_pkg is a package: it must be compiled explicitly (a -I include path
    # is not enough for package resolution).
    "./vendor_ips/ibex/dv/uvm/core_ibex/common/prim/prim_pkg.sv",
    # Use the self-contained synthesis prim_clock_gating (as the Questa flow
    # does). Listing it explicitly stops Verilator from auto-pulling the
    # dv/uvm wrapper variant that needs the absent prim_generic_clock_gating.
    "./vendor_ips/ibex/syn/rtl/prim_clock_gating.v",
    "./vendor_ips/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_pkg.sv",
    "./vendor_ips/ibex/rtl/ibex_pkg.sv",
    "./vendor_ips/ibex/rtl/ibex_dummy_instr.sv",
    "-I./vendor_ips/ibex/vendor/lowrisc_ip/dv/sv/dv_utils/",
    "-I./vendor_ips/ibex/vendor/lowrisc_ip/ip/prim/rtl/",
    "-I./vendor_ips/ibex/rtl/",
    "./src/tech_generic/io_cell.sv",
    # Simulation stand-in for the analog macro (module name TOPCELL_ISAR_with_
    # padframe != filename, so -I auto-discovery can't find it; must list
    # explicitly). analog_wrapper_0.v (real ASIC macro instance) pulls this in.
    "./src/tech_generic/analog_tieoff.v",
    "-I./src/tech_generic/",
    "./.bender/git/checkouts/tech_cells_generic-c6f7639ae8d3c67d/src/rtl/tc_clk.sv",
    # obi_sram.sv (new SoC memory model, replaces sp_sram) instantiates
    # tc_sram; list it explicitly (same reasoning as tc_clk.sv above).
    "./.bender/git/checkouts/tech_cells_generic-c6f7639ae8d3c67d/src/rtl/tc_sram.sv",
    "-I./.bender/git/checkouts/common_cells-3bd5b2d671aaec0e/src/deprecated/",
    "-I./.bender/git/checkouts/riscv-dbg-0a8f5dd79750e659/debug_rom/",
    "./.bender/git/checkouts/common_cells-3bd5b2d671aaec0e/src/cdc_4phase.sv",
    "./.bender/git/checkouts/common_cells-3bd5b2d671aaec0e/src/cdc_reset_ctrlr_pkg.sv",
    "-I./.bender/git/checkouts/riscv-dbg-0a8f5dd79750e659/src/",
    "-I./.bender/git/checkouts/common_cells-3bd5b2d671aaec0e/include/",
    "-I./.bender/git/checkouts/common_cells-3bd5b2d671aaec0e/src/",
    "-I./.bender/git/checkouts/obi-cbdec09f22f66762/src/",
    "./vendor_ips/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_pkg.sv",
    "./.bender/git/checkouts/riscv-dbg-0a8f5dd79750e659/src/dm_pkg.sv",
    "./.bender/git/checkouts/apb-e4460f86c75afc6a/src/apb_pkg.sv",
    "./.bender/git/checkouts/common_cells-3bd5b2d671aaec0e/src/cf_math_pkg.sv",
    "./.bender/git/checkouts/apb-e4460f86c75afc6a/src/apb_intf.sv",
    "./.bender/git/checkouts/obi-cbdec09f22f66762/src/obi_pkg.sv",
    "./.bender/git/checkouts/obi-cbdec09f22f66762/src/obi_intf.sv",
    "-I./.bender/git/checkouts/obi-cbdec09f22f66762/include/",
    "-I./src/rtl/",
    "-I./.bender/git/checkouts/apb_uart-82e60c3a7ada9dd1/src/",
    "-I./vendor_ips/axi_spi_master/",
    "-I./vendor_ips/apb_spi_master/",
    "-I./.bender/git/checkouts/apb_gpio-f882c1c8a370562e/rtl/",
    "-I./src/generated/",
    # New Didactic-SoC: Kactus2-generated student subsystem wrappers replace the
    # old *_tieoff.sv files. Each student_wrapper_N.v defines module student_wrapper_N
    # which instantiates `subsystem`; subsystem.v is our accelerator glue.
    # Listed explicitly because Verilator can be fragile with mixed .v/.sv via -I.
    # Only slot 1 (student_wrapper_0) instantiates the real `subsystem`
    # (accelerator); slots 2-7 (student_wrapper_1..6) instantiate the
    # subsystem_tieoff stub so the accelerator isn't replicated 7x.
    "./src/generated/subsystem.v",
    "./src/tech_generic/subsystem_tieoff.v",
    "./src/generated/student_wrapper_0.v",
    "./src/generated/student_wrapper_1.v",
    "./src/generated/student_wrapper_2.v",
    "./src/generated/student_wrapper_3.v",
    "./src/generated/student_wrapper_4.v",
    "./src/generated/student_wrapper_5.v",
    "./src/generated/student_wrapper_6.v",
    # generic_and gate used by student_wrapper IRQ mask logic.
    "./src/rtl/generic_cells.sv",
    # Group5 systolic-array AI accelerator (instantiated by subsystem). Files are
    # self-contained and only depend on accel_pkg via the include directory.
    "-I../rtl/include/",
    "../rtl/include/accel_pkg.sv",
    "../rtl/control/control_unit.sv",
    "../rtl/MAC/mac_pe.sv",
    "../rtl/array/skew_shift.sv",
    "../rtl/array/systolic_array.sv",
    "../rtl/matrix/matrix_buffer_ab.sv",
    "../rtl/matrix/matrix_buffer_c.sv",
    "../rtl/top/accelerator_top.sv",
    "./src/generated/Didactic.v",
]


def main():
    succeeded: List[int] = list()
    for i, tc in enumerate(TESTCASES):
        path_full = TESTCASES_DIR / tc.path / "main.cpp"
        p1 = deepcopy(VERILATOR_ARGS)
        p1.extend(MANUAL_FILES)
        p1.append(str(path_full))
        p2 = "make --directory=./obj_dir --makefile=VDidactic.mk".split(" ")
        p3 = "./obj_dir/VDidactic +trace".split(" ")
        r1 = sp.run(p1)
        if r1.returncode == 0:
            r2 = sp.run(p2)
            if r2.returncode == 0:
                r3 = sp.run(p3)
                if r3.returncode == 0:
                    print(Fore.GREEN + f"[test {i + 1}] OK" + Style.RESET_ALL)
                    succeeded.append(i)
                else:
                    print(Fore.RED + f"[test {i + 1}] FAIL" + Style.RESET_ALL)
            else:
                print(Fore.RED + f"[test {i + 1}] FAIL" + Style.RESET_ALL)
        else:
            print(Fore.RED + f"[test {i + 1}] FAIL" + Style.RESET_ALL)
    if len(succeeded) == len(TESTCASES):
        print(Fore.GREEN + f"{len(succeeded)}/{len(TESTCASES)} succeeded" + Style.RESET_ALL)
    else:
        print(Fore.RED + f"{len(succeeded)}/{len(TESTCASES)} succeeded" + Style.RESET_ALL)


if __name__ == "__main__":
    main()
