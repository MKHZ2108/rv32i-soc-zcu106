# RISC-V RV32I CPU & SoC Design and Verification on AMD ZCU106 FPGA

<p align="center">
  <b>Language / Ngôn ngữ:</b>
  <a href="README_EN.md"><b>🇬🇧 English</b></a> |
  <a href="README.md"><b>🇻🇳 Tiếng Việt</b></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/ISA-RV32I__Zicsr-blue.svg" alt="ISA">
  <img src="https://img.shields.io/badge/FPGA-AMD%20ZCU106%20Zynq%20UltraScale+-red.svg" alt="FPGA">
  <img src="https://img.shields.io/badge/Frequency-100%20MHz%20(WNS%20%2B3.733ns)-brightgreen.svg" alt="Clock">
  <img src="https://img.shields.io/badge/Verification-101%2F101%20PASS%20(100%25)-success.svg" alt="Tests">
  <img src="https://img.shields.io/badge/Language-Verilog%20HDL-orange.svg" alt="HDL">
  <img src="https://img.shields.io/badge/Toolchain-Vivado%202025.2%20%7C%20Icarus%20Verilog-purple.svg" alt="Tools">
</p>

---

## 📌 1. Project Overview

This project presents a complete **RISC-V RV32I** processor core implemented in synthesizable pure Verilog HDL and integrated into a fully operational **System-on-Chip (SoC)** deployed on the **AMD ZCU106** evaluation board (Zynq UltraScale+ `xczu7ev-ffvc1156-2-e`).

The hardware design prioritizes architectural compliance, cycle accuracy, and robust timing closure:
- In-order, single-issue 5-stage pipeline (IF – ID – EX – MEM – WB) based on a Harvard architecture.
- Full support for the standard **RV32I Base Integer ISA**, the **Zicsr** extension, and a tailored **Machine-mode Privileged ISA** subset (ECALL, EBREAK, MRET).
- **Single Architectural Commit Boundary at Writeback (WB)**: Ensures precise exceptions, in-order retirement, and deterministic state updates.
- Memory subsystem decoupled through two independent **AXI4-Lite Master Adapters** for Instruction (`M_AXI_IMEM`) and Data (`M_AXI_DMEM`).
- In-system live firmware deployment via **JTAG-to-AXI** using Vivado Tcl scripting without re-generating FPGA bitstreams.

---

## 🏛️ 2. SoC System Architecture

The FPGA SoC subsystem is assembled using AMD Vivado Block Design (`rv32i_bd`). The processor core interfaces with memory controllers and peripherals via an **AMD SmartConnect** crossbar interconnect orchestrating 3 independent AXI Masters:

<p align="center">
  <img src="docs/images/soc_block_design.png" alt="SoC Block Design on AMD ZCU106" width="95%">
  <br>
  <em>Figure 1: SoC Subsystem Block Design on AMD ZCU106 FPGA (Vivado Block Design)</em>
</p>

### Key SoC Components:
- **Core Subsystem (`rv32i_axi_integration_top`)**: Encapsulates `rv32i_core` alongside dual AXI4-Lite master adapters (`M_AXI_IMEM` and `M_AXI_DMEM`).
- **AMD AXI SmartConnect**: Arbitration crossbar routing transactions between 3 AXI Masters (Core I-AXI, Core D-AXI, JTAG-to-AXI) and peripheral slaves.
- **Instruction BRAM (IMEM)**: 8 KiB local memory (`0x0000_0000`), storing main program code and trap handlers.
- **Data BRAM (DMEM)**: 8 KiB local memory (`0x0000_2000`), storing global variables, heap, stack, and debug markers.
- **AXI UARTLite**: Base address `0x0004_0000`, 115200 baud 8N1, supporting serial I/O communication and interrupt assertion.
- **AXI INTC (Interrupt Controller)**: Base address `0x0005_0000`, receives peripheral interrupt requests from UARTLite and asserts `irq_external` to the core.
- **Clocking & Reset**: Ingests the 125 MHz board reference oscillator to generate a clean 100 MHz system clock; synchronizes system-wide resets via `proc_sys_reset_0`.

### System Address Map:

| Region / Peripheral | Address Range | Size | Description |
|---|---|---|---|
| **Instruction BRAM (IMEM)** | `0x0000_0000 – 0x0000_1FFF` | 8 KiB | Main application code & trap handler routine |
| **Data BRAM (DMEM)** | `0x0000_2000 – 0x0000_3FFF` | 8 KiB | Data, stack memory, buffers, and debug markers |
| **AXI UARTLite** | `0x0004_0000 – 0x0004_FFFF` | 64 KiB | Serial RX/TX FIFO registers & interrupt source |
| **AXI Interrupt Controller** | `0x0005_0000 – 0x0005_FFFF` | 64 KiB | Interrupt Enable / Status / Acknowledge registers |

---

## ⚙️ 3. RV32I Core Microarchitecture

The `rv32i_core` is architected with a 5-stage classic RISC pipeline:

<p align="center">
  <img src="docs/images/pipeline_architecture.png" alt="5-Stage Pipeline Microarchitecture of RV32I Core" width="95%">
  <br>
  <em>Figure 2: Comprehensive 5-stage pipeline microarchitecture (IF – ID – EX – MEM – WB)</em>
</p>

### Pipeline Stage Details:
1. **Instruction Fetch (IF)**:
   - Maintains the Program Counter (`pc_unit.v`), incorporates an instruction hold buffer, and handles fetch request cancellation during branch redirection or trap injection.
   - Non-blocking back-pressure mechanism: Stalls the entire pipeline gracefully under variable memory access latency.
2. **Instruction Decode (ID)**:
   - The `decoder` and `imm_gen` modules parse instruction fields and generate sign-extended immediates across all 5 instruction formats (I, S, B, U, J).
   - Register File (`reg_file`): 32 x 32-bit registers synthesized using Flip-Flops (not BRAM), featuring 2 asynchronous read ports, 1 synchronous write port, internal write-through forwarding (same-cycle read-after-write), and hardwired `x0 = 0`.
   - Traps illegal opcodes, `ECALL`, and `EBREAK` immediately at decode time.
3. **Execute (EX)**:
   - Arithmetic Logic Unit (`alu`): Implements 11 basic operations (ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND). SUB, SLT, and SLTU share a unified carry chain to minimize area.
   - Branch Resolution (`branch_unit`): Evaluates all 6 conditional branch comparisons (BEQ, BNE, BLT, BGE, BLTU, BGEU) and calculates branch/jump targets at EX.
   - Forwarding Unit (`forwarding_unit`): Forwards updated operands from MEM and WB stages directly to EX inputs, prioritizing the newest result in MEM.
   - Hazard Detection Unit (`hazard_unit`): Detects load-use data dependencies and dynamically inserts a single-cycle bubble (`stall`).
4. **Memory Access (MEM)**:
   - Generates byte-enable strobes and sign/zero extensions for byte, half-word, and word loads/stores (`LB`, `LH`, `LW`, `LBU`, `LHU`, `SB`, `SH`, `SW`).
   - Detects misaligned access and bus faults, forwarding the faulting address to the trap unit.
5. **Writeback (WB) — Single Architectural Commit Boundary**:
   - All architectural state mutations (`reg_file` write, `CSR` updates, `minstret` increment, and trap context commit `mcause`/`mepc`) **only take effect at WB**.
   - Faults and interrupts are prioritized strictly by instruction age (older instructions take precedence over younger ones), eliminating race conditions between traps and asynchronous interrupts.

---

## 🧪 4. 3-Tier Verification Strategy (101/101 PASS)

The core underwent rigorous multi-layer self-checking regression testing powered by Icarus Verilog (`iverilog` & `vvp`):

<p align="center">
  <img src="docs/images/regression_summary.png" alt="3-Tier Verification Results - 101/101 PASS" width="85%">
  <br>
  <em>Figure 3: Execution summary of all three regression suites (100% PASS rate)</em>
</p>

| Verification Tier | Device Under Test (DUT) | Test Runner Script | Tests Count | Status |
|---|---|---|:---:|:---:|
| **1. Unit, Extended & Integration** | Submodules, pipeline registers, AXI adapters, full SoC RAM integration | `verification/run_all_tests.ps1` | 21 | **21 / 21 PASS** |
| **2. Mini Architectural Tests** | Core microarchitectural scenarios (tested under both 0-cycle and high-latency RAM) | `verification/tb_arch/run_mini_arch_tests.ps1` | 30 | **30 / 30 PASS** |
| **3. Official riscv-tests** | Third-party compliance suite (40 `rv32ui` unprivileged + 10 `rv32mi` privileged) | `verification/tb_official/run_official.ps1` | 50 | **50 / 50 PASS** |
| **TOTAL** | **Entire RV32I Core & SoC Platform** | — | **101** | **101 / 101 PASS (100%)** |

---

## 🚀 5. Hardware Implementation on AMD ZCU106 FPGA

The design was fully synthesized, placed, routed, and demonstrated on physical **AMD ZCU106** silicon.

### 5.1 In-Hardware Live Demonstration
Application firmware is cross-compiled using `riscv-none-elf-gcc` and loaded into the instruction memory in seconds via JTAG-to-AXI and Vivado Tcl **without re-generating bitstreams**:

<p align="center">
  <img src="docs/images/hardware_demo.png" alt="Hardware execution on ZCU106: JTAG load & UART terminal" width="95%">
  <br>
  <em>Figure 4: JTAG memory programming via Vivado Tcl (left) and interactive UART calculator over Hercules Terminal at 115200 baud (right)</em>
</p>

### 5.2 Post-Implementation Timing Closure (100 MHz)
The processor comfortably meets timing constraints at **100 MHz** with generous positive slack:

<p align="center">
  <img src="docs/images/timing_summary.png" alt="Design Timing Summary Post Route" width="90%">
  <br>
  <em>Figure 5: Vivado Design Timing Summary report post-route (WNS = +3.733 ns, TNS = 0.000 ns)</em>
</p>

- **Worst Negative Slack (WNS)**: `+3.733 ns` (10.0 ns target period, theoretical $F_{max} pprox 160	ext{ MHz}$).
- **Total Negative Slack (TNS)**: `0.000 ns` (Zero timing violations across all 13,658 endpoints).
- **Worst Hold Slack (WHS)**: `+0.011 ns` (Zero hold violations).

### 5.3 FPGA Resource Utilization (`xczu7ev-ffvc1156-2-e`)

| Resource | Used | Available | Utilization (%) |
|---|:---:|:---:|:---:|
| **CLB LUTs (Whole SoC)** | 4,337 | 230,400 | **1.88%** |
| **CLB Registers (Flip-Flops)** | 4,905 | 460,800 | **1.06%** |
| **Block RAM Tile** | 6.5 | 312 | **2.08%** |
| **CARRY8 Primitives** | 57 | 28,800 | **0.20%** |
| **DSP Blocks / URAM** | 0 | 1,728 | **0.00%** |

*(The core alone consumes only 2,425 LUTs and 1,550 FFs, leaving ample FPGA fabric available for accelerators and complex memory subsystems)*.

---

## 📂 6. Repository Structure

```text
.
├── accelerator_options/               # Datapath optimization variants separated from baseline
│   ├── rtl/                           # 32-bit CLA adder, Carry-Select adder, Barrel shifter
│   ├── README.md                      # Vietnamese documentation
│   └── README_EN.md                   # English documentation
├── docs/                              # Technical reports, slides, and project documentation
│   ├── images/                        # Architectural diagrams, simulation, and hardware screenshots
│   ├── PRESENT_RV32I_Core_ZCU106.pptx # Project presentation slides
│   └── REPORT_PROJECT_RV32I_Core_Review.docx # In-depth technical report
├── tcl_mem_load_test/                 # In-system JTAG memory programming & verification environment
│   └── tcl/
│       ├── build.bat                  # Cross-assembly script (.s -> .elf -> .mem)
│       ├── docs/                      # Usage guides (README.md & README_EN.md)
│       ├── load_imem.tcl              # TCL script loading firmware into Instruction BRAM
│       ├── read_dmem.tcl              # TCL script inspecting Data BRAM markers
│       ├── test_cpu.s                 # End-to-end CPU instruction suite via UART
│       ├── test_uart_calculator.s     # Interactive 4-operation UART calculator application
│       └── test_uart_irq.s            # External interrupt verification (UARTLite -> INTC -> Core)
├── verification/                      # 3-Tier self-checking testbenches and regression scripts
│   ├── run_all_tests.ps1              # Unit & Integration test runner (21 tests)
│   ├── sim_only/                      # Behavioral memory/interconnect simulation models
│   ├── tb/                            # Component unit testbenches
│   ├── tb_arch/                       # Microarchitectural signature testbenches (30 tests)
│   ├── tb_ext/                        # Pipeline, hazard, and commit verification testbenches
│   └── tb_official/                   # riscv-tests official compliance testbench (50 tests)
├── VIVADO/                            # Vivado 2025.2 implementation project for ZCU106
│   ├── RISCV- RV32I.xpr               # Vivado project file
│   └── RISCV- RV32I.srcs/sources_1/imports/rtl/ # Golden synthesizable Verilog RTL source tree
├── README.md                          # Project Introduction (Tiếng Việt)
└── README_EN.md                       # Project Introduction (English)
```

---

## ⚡ 7. Quick Start Guide

### 7.1 Running Automated Regression Tests
Requires **Icarus Verilog** (`iverilog` & `vvp`) installed on your PATH:

```powershell
# Run Unit, Extended & Integration test suite (21 tests)
powershell -ExecutionPolicy Bypass -File ./verification/run_all_tests.ps1

# Run Mini Architectural test suite (30 tests)
powershell -ExecutionPolicy Bypass -File ./verification/tb_arch/run_mini_arch_tests.ps1

# Run Official riscv-tests compliance suite (50 tests)
powershell -ExecutionPolicy Bypass -File ./verification/tb_official/run_official.ps1
```

### 7.2 Programming & Running on ZCU106 Board
1. Open the project in AMD Vivado: `VIVADO/RISCV- RV32I.xpr`.
2. Generate Bitstream and program the FPGA using Vivado Hardware Manager.
3. Build your application inside `tcl_mem_load_test/tcl/`:
   ```bat
   build.bat test_uart_calculator.s
   ```
4. In the **Vivado Tcl Console**:
   ```tcl
   cd <path_to_project>/tcl_mem_load_test/tcl
   set ::rv_mem_file "test_uart_calculator.mem"
   source -notrace load_imem.tcl
   ```
5. Open your preferred serial terminal (Hercules / TeraTerm / PuTTY) connected to the ZCU106 UART COM port (`115200 baud, 8N1`), press the **SW20 (CPU_RESET)** pushbutton, and interact with the processor!

---

## 👤 8. Authors & Acknowledgments

- **Author**: Nguyen Tuan Ngoc (Nguyễn Tuấn Ngọc)
- **Advisor**: Dao Thanh Mai (Đào Thanh Mai)
- **Project**: RISC-V RV32I CPU & SoC Design and Verification on AMD ZCU106 FPGA Platform
