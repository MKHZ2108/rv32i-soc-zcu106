# =============================================================================
# test_uart.s - ECHO UART: nhan ky tu tu Hercules, tra lai y nguyen
#
#   build.bat test_uart.s
#   set ::rv_mem_file "test_uart.mem"   ->  source load_imem.tcl
#   nhap NHE nut Reset ~0.5s roi tha
#   mo Hercules -> tab Serial -> dung COM port -> 115200, 8N1, khong handshake
#   go "hello" -> man hinh Hercules hien lai "hello"
#
# BAN DO THANH GHI AXI Uartlite (goc 0x00040000):
#   +0x00  RX FIFO   doc ra ky tu vua nhan
#   +0x04  TX FIFO   ghi vao de phat di
#   +0x08  STAT      bit0 RX_VALID (co ky tu de doc)
#                    bit3 TX_FULL  (FIFO phat da day, phai cho)
#   +0x0C  CTRL      bit0 reset TX FIFO, bit1 reset RX FIFO
# =============================================================================

.section .text
.global _start

_start:
    li   x1, 0x00040000        # goc thanh ghi uartlite

rx_wait:
    lw   x5, 8(x1)             # doc STAT
    andi x5, x5, 1             # tach bit RX_VALID
    beq  x5, x0, rx_wait       # chua co ky tu -> cho tiep

    lw   x6, 0(x1)             # lay ky tu tu RX FIFO
    andi x6, x6, 0xFF          # chi giu 8 bit thap

tx_wait:
    lw   x5, 8(x1)             # doc lai STAT
    andi x5, x5, 8             # tach bit TX_FULL
    bne  x5, x0, tx_wait       # FIFO phat con day -> cho

    sw   x6, 4(x1)             # phat ky tu ra TX FIFO
    j    rx_wait               # quay lai cho ky tu ke tiep
