# RV32I: JTAG, UART, and Interrupts

## 1. Single Command Table

Run Tcl commands in the **Vivado Tcl Console**, except for `build.bat` commands which
run in the **Command Prompt** at `Tutorial/tcl`.

| Function | Single Command |
|---|---|
| Navigate to working directory | <pre><code>cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl</code></pre> |
| Build interrupt firmware | <pre><code>build.bat test_uart_irq.s</code></pre> |
| Select interrupt firmware to load | <pre><code>set ::rv_mem_file "test_uart_irq.mem"</code></pre> |
| Load selected `.mem` file into IMEM | <pre><code>source -notrace load_imem.tcl</code></pre> |
| Read 16 IMEM words starting from address 0 | <pre><code>source -notrace read_imem.tcl</code></pre> |
| Select IMEM region to read | <pre><code>set ::rv_imem_start 0x00000100
set ::rv_imem_words 16</code></pre> |
| Read DMEM markers | <pre><code>source -notrace read_dmem.tcl</code></pre> |
| Reconnect Hardware Target/JTAG-AXI | <pre><code>source -notrace reconnect_hw.tcl</code></pre> |
| Run CPU with newly loaded firmware | Press and hold **SW20 / CPU_RESET** for ~0.5s, then release. |

## 2. Quick Test Command Sequences

### UART Interrupt Test — Recommended First

Objective: verify the path `UARTLite → AXI INTC → irq_external → ISR`.

**A. If Block Design was recently changed:** Save → Validate Design → Generate Output
Products → Create Bitstream → Program Device.

**B. Command Prompt at `Tutorial/tcl`:**

```bat
build.bat test_uart_irq.s
```

**C. Vivado Tcl Console:**

```tcl
cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl
set ::rv_mem_file "test_uart_irq.mem"
source -notrace load_imem.tcl
```

**D. Board and Hercules:**

1. Press and release SW20.
2. Open Hercules Serial: `115200`, `8N1`, `Handshake OFF`, `Local Echo OFF`.
3. Must receive the string `IRQ ready`.
4. Enter `a` into the Send box and click Send. The board must echo `a`.

### Full CPU Test — Results via UART, no JTAG → DMEM needed

Verifies ALU, logic, shift, compare, branch, load/store byte-half-word,
LUI/AUIPC, JAL/JALR, and pipeline hazards. Each group self-reports `PASS` or `FAIL`.

```bat
build.bat test_cpu.s
```

```tcl
cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl
set ::rv_mem_file "test_cpu.mem"
source -notrace load_imem.tcl
```

Press and release SW20, then view Hercules (`115200`, `8N1`, `Handshake OFF`,
`Local Echo OFF`). A successful run ends with `PASS`.

### UART Polling Echo Test — Without Interrupts

```bat
build.bat test_uart.s
```

```tcl
cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl
set ::rv_mem_file "test_uart.mem"
source -notrace load_imem.tcl
```

Press and release SW20, then send characters in Hercules; the board echoes them back via polling.

### UART Calculator Test — Enter A, select operation, enter B

Supports non-negative integers `0–9999`; enter each number then press Enter. Select `1:+`,
`2:-`, `3:*`, `4:/`. Division takes integer quotient; division by zero reports an error.

```bat
build.bat test_uart_calculator.s
```

```tcl
cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl
set ::rv_mem_file "test_uart_calculator.mem"
source -notrace load_imem.tcl
```

Press and release SW20, then use Hercules (`115200`, `8N1`, `Local Echo OFF`). For example,
enter `123`, press Enter, select `3`, press Enter, enter `45`, press Enter; the board returns
`Result: 5535`.

### Verify Interrupt Handler in IMEM

```tcl
set ::rv_imem_start 0x00000100
set ::rv_imem_words 16
source -notrace read_imem.tcl
```

## 3. Essential Knowledge

### Memory Map

| Region | Address | Role |
|---|---:|---|
| Instruction BRAM | `0x0000_0000–0x0000_1FFF` | Main program and interrupt handler |
| Data BRAM | `0x0000_2000–0x0000_3FFF` | Variables, stack, debug markers |
| AXI UARTLite | `0x0004_0000–0x0004_FFFF` | UART RX/TX, interrupt source |
| AXI INTC | `0x0005_0000–0x0005_FFFF` | Enable/pending/acknowledge interrupt |

### Interrupt Flow

```text
Hercules sends byte
→ UARTLite RX FIFO
→ AXI INTC pending + irq
→ core irq_external
→ core jumps to mtvec = 0x100
→ ISR in IMEM reads RX, echoes, acknowledges INTC
→ mret returns to main
```

`mtvec = 0x100` is chosen by the test firmware. The handler code is pre-loaded at
`IMEM[0x100]`; there is no dedicated interrupt memory.

### Debug Markers for Interrupt Test

Only readable when JTAG maps Data BRAM:

| Address | Meaning |
|---:|---|
| `0x2000` | `49525131`: firmware reached main |
| `0x2004` | Number of entries into ISR |
| `0x2008` | `8000000B`: machine external interrupt (`mcause`) |
| `0x200C` | Last received RX character |

## 4. Common Issues and Solutions

| Symptom | Resolution |
|---|---|
| No `IRQ ready` | Reload `test_uart_irq.mem`, press and release SW20, check UART 115200 8N1. |
| `IRQ ready` present but no echo | Check that `M_AXI_DMEM` maps UART to `0x40000`, INTC to `0x50000`; program new bitstream if address map was changed. |
| No `U` in TX test | Check COM port, baud rate, TX pin, and UART bitstream/mapping. |
| JTAG/AXI timeout | Run `source -notrace reconnect_hw.tcl`. |
| `read_dmem.tcl` timeout | Unexclude Data BRAM under `jtag_axi_0/Data`, or do not read DMEM. |