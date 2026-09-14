# =============================================================================
# test_uart_irq.s - End-to-end test: UARTLite -> AXI INTC -> RV32I MEIP trap
#
# Address map used by the current Block Design:
#   IMEM          0x0000_0000
#   DMEM          0x0000_2000
#   AXI UARTLite  0x0004_0000
#   AXI INTC      0x0005_0000
#
# Build and load:
#   build.bat test_uart_irq.s
#   set ::rv_mem_file "test_uart_irq.mem"; source -notrace load_imem.tcl
#   Press and release CPU_RESET, then send characters at 115200 8N1.
#
# Expected UART output:
#   "IRQ ready"
#   Each received character is echoed by the interrupt handler.
#
# DMEM markers (optional, useful once JTAG-to-AXI is mapped to Data BRAM):
#   0x2000 = 0x49525131  firmware reached main
#   0x2004 = number of entries into the external-interrupt handler
#   0x2008 = last mcause (must be 0x8000000B)
#   0x200C = last received character (low byte)
# =============================================================================

.equ DMEM_BASE,       0x00002000
.equ UART_BASE,       0x00040000
.equ INTC_BASE,       0x00050000

.equ UART_RX_FIFO,    0x00
.equ UART_TX_FIFO,    0x04
.equ UART_STATUS,     0x08
.equ UART_CONTROL,    0x0C
.equ UART_RX_VALID,   0x01
.equ UART_TX_FULL,    0x08
.equ UART_INT_ENABLE, 0x10

.equ INTC_IER,        0x08
.equ INTC_IAR,        0x0C
.equ INTC_MER,        0x1C
.equ INTC_INT0,       0x01
.equ INTC_ME_HIE,     0x03

.equ MSTATUS_MIE,     0x08
.equ MIE_MEIE,        0x800

.section .text
.global _start

_start:
    # Record that the CPU reached firmware before interrupts are enabled.
    li   t0, DMEM_BASE
    li   t1, 0x49525131             # ASCII-ish marker: "IRQ1"
    sw   t1, 0(t0)
    sw   zero, 4(t0)
    sw   zero, 8(t0)
    sw   zero, 12(t0)

    # Reset UART FIFOs, then print a polling marker.  The marker is encoded as
    # instruction immediates: M_AXI_DMEM intentionally cannot read IMEM, so a
    # string placed in .rodata at an IMEM address would cause a load fault.
    # At this point UART and CPU global interrupts are still disabled.
    li   t0, UART_BASE
    li   t1, 3
    sw   t1, UART_CONTROL(t0)
    li   a0, 'I'
    jal  ra, putc_polling
    li   a0, 'R'
    jal  ra, putc_polling
    li   a0, 'Q'
    jal  ra, putc_polling
    li   a0, ' '
    jal  ra, putc_polling
    li   a0, 'r'
    jal  ra, putc_polling
    li   a0, 'e'
    jal  ra, putc_polling
    li   a0, 'a'
    jal  ra, putc_polling
    li   a0, 'd'
    jal  ra, putc_polling
    li   a0, 'y'
    jal  ra, putc_polling
    li   a0, 13
    jal  ra, putc_polling
    li   a0, 10
    jal  ra, putc_polling

    # Install the machine-mode external-interrupt handler at 0x100.
    li   t0, 0x100
    csrw mtvec, t0

    # Configure AXI INTC input 0 (UART) before enabling the UART source.
    # IER[0] enables the input; MER[1:0] = HIE | ME enables hardware IRQs.
    li   t0, INTC_BASE
    li   t1, INTC_INT0
    sw   t1, INTC_IER(t0)
    sw   t1, INTC_IAR(t0)           # discard a stale pending edge
    li   t1, INTC_ME_HIE
    sw   t1, INTC_MER(t0)

    # Enabling UARTLite interrupt can itself create a TX-empty interrupt.
    # The handler acknowledges it.  A received byte later creates another
    # edge and is read+echoed from the handler.
    li   t0, UART_BASE
    li   t1, UART_INT_ENABLE
    sw   t1, UART_CONTROL(t0)

    # Enable machine external interrupts in the core, last of all.
    li   t0, MIE_MEIE
    csrs mie, t0
    li   t0, MSTATUS_MIE
    csrs mstatus, t0

main_loop:
    j    main_loop

# -----------------------------------------------------------------------------
# Machine external-interrupt handler.  The main loop has no live registers,
# so this self-contained test needs no stack save/restore.  A real firmware
# handler must preserve any registers used by interrupted application code.
# -----------------------------------------------------------------------------
.org 0x100
irq_handler:
    li   t0, DMEM_BASE
    lw   t1, 4(t0)
    addi t1, t1, 1
    sw   t1, 4(t0)                  # count all controller IRQ entries
    csrr t1, mcause
    sw   t1, 8(t0)                  # expected: 0x8000000B

    # Service UART first: reading RX FIFO removes the RX-not-empty condition.
    li   t2, UART_BASE
    lw   t3, UART_STATUS(t2)
    andi t4, t3, UART_RX_VALID
    beq  t4, zero, acknowledge_intc

    lw   t4, UART_RX_FIFO(t2)
    andi t4, t4, 0xFF
    sw   t4, 12(t0)                 # last received byte

tx_wait:
    lw   t3, UART_STATUS(t2)
    andi t3, t3, UART_TX_FULL
    bne  t3, zero, tx_wait
    sw   t4, UART_TX_FIFO(t2)       # echo byte from the IRQ handler

acknowledge_intc:
    # Ack AXI INTC only after servicing UART.  TX becoming empty can cause a
    # separate edge; it is harmless and increments the handler counter.
    li   t0, INTC_BASE
    li   t1, INTC_INT0
    sw   t1, INTC_IAR(t0)
    mret

# -----------------------------------------------------------------------------
# a0 = one character. Used only before global interrupts are on.
# -----------------------------------------------------------------------------
putc_polling:
    li   t0, UART_BASE
putc_wait:
    lw   t2, UART_STATUS(t0)
    andi t2, t2, UART_TX_FULL
    bne  t2, zero, putc_wait
    sw   a0, UART_TX_FIFO(t0)
    ret
