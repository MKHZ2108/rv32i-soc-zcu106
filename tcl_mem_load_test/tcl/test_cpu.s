# =============================================================================
# test_cpu.s - RV32I SELF-TEST, BAO CAO QUA UART
#
# JTAG chi can nap file nay vao IMEM. CPU tu dung M_AXI_DMEM de truy cap
# Data BRAM va UARTLite; khong can JTAG truy cap DMEM.
#
# Cach dung: build.bat test_cpu.s -> nap test_cpu.mem -> nhan-tha CPU_RESET.
# Hercules: 115200, 8N1, Handshake OFF, Local Echo OFF.
#
# Ket qua mau: CPU TEST\r\nT1 ALU: PASS\r\n...\r\nT9 HAZARD: PASS\r\nPASS\r\n
# Moi dong cho biet ten nhom va PASS/FAIL cua nhom do.
# Nhom: 1=x0/add/sub/addi, 2=logic, 3=shift, 4=compare, 5=branch,
#        6=load/store B/H/W, 7=LUI/AUIPC, 8=JAL/JALR, 9=forwarding/load-use.
# =============================================================================

.equ UART_BASE, 0x00040000
.equ UART_TX,   4
.equ UART_STAT, 8
.equ TX_FULL,   8
.equ DMEM_BASE, 0x00002000

.section .text
.global _start

_start:
    li   s0, 0
    li   s1, DMEM_BASE
    li   s2, UART_BASE

    li a0, 'C'; jal ra, putc
    li a0, 'P'; jal ra, putc
    li a0, 'U'; jal ra, putc
    li a0, ' '; jal ra, putc
    li a0, 'T'; jal ra, putc
    li a0, 'E'; jal ra, putc
    li a0, 'S'; jal ra, putc
    li a0, 'T'; jal ra, putc
    jal ra, crlf

# 1. x0, ADD, ADDI, SUB
    addi s3, s0, 0
    li   t0, 99
    addi x0, t0, 1
    bne  x0, zero, fail1
    li   t0, 5
    addi t0, t0, 3
    li   t1, 8
    bne  t0, t1, fail1
    sub  t0, t0, t1
    bne  t0, zero, fail1
    li   t0, 0x7fffffff
    addi t0, t0, 1             # RV32I wraparound, khong co overflow trap
    li   t1, 0x80000000
    bne  t0, t1, fail1
    li   t0, -7
    addi t0, t0, -9
    li   t1, -16
    bne  t0, t1, fail1
    jal  zero, pass1
fail1:
    ori  s0, s0, 0x001
pass1:
    li   a0, 1
    jal  ra, report

# 2. AND, OR, XOR va immediate
    addi s3, s0, 0
    li   t0, 0x0F0F
    li   t1, 0x00FF
    and  t2, t0, t1
    li   t3, 0x000F
    bne  t2, t3, fail2
    or   t2, t0, t1
    li   t3, 0x0FFF
    bne  t2, t3, fail2
    xor  t2, t0, t1
    li   t3, 0x0FF0
    bne  t2, t3, fail2
    andi t2, t0, 0x0F0
    bne  t2, zero, fail2
    ori  t2, zero, 0x55
    xori t2, t2, 0x0FF
    li   t3, 0x0AA
    bne  t2, t3, fail2
    jal  zero, pass2
fail2:
    ori  s0, s0, 0x002
pass2:
    li   a0, 2
    jal  ra, report

# 3. SLL/SRL/SRA, dang register va immediate
    addi s3, s0, 0
    li   t0, 1
    li   t1, 4
    sll  t2, t0, t1
    li   t3, 16
    bne  t2, t3, fail3
    srli t2, t2, 2
    li   t3, 4
    bne  t2, t3, fail3
    li   t0, -16
    srai t2, t0, 2
    li   t3, -4
    bne  t2, t3, fail3
    sra  t2, t0, t1
    li   t3, -1
    bne  t2, t3, fail3
    li   t0, 1
    slli t2, t0, 31            # bien cao nhat
    li   t3, 0x80000000
    bne  t2, t3, fail3
    srli t2, t3, 31
    li   t0, 1
    bne  t2, t0, fail3
    jal  zero, pass3
fail3:
    ori  s0, s0, 0x004
pass3:
    li   a0, 3
    jal  ra, report

# 4. SLT/SLTU/SLTI/SLTIU
    addi s3, s0, 0
    li   t0, -1
    li   t1, 1
    slt  t2, t0, t1
    li   t3, 1
    bne  t2, t3, fail4
    sltu t2, t0, t1
    bne  t2, zero, fail4
    slti t2, t0, 0
    bne  t2, t3, fail4
    sltiu t2, t1, 2
    bne  t2, t3, fail4
    li   t0, 0x80000000
    li   t1, 0
    slt  t2, t0, t1
    bne  t2, t3, fail4
    sltu t2, t0, t1
    bne  t2, zero, fail4
    jal  zero, pass4
fail4:
    ori  s0, s0, 0x008
pass4:
    li   a0, 4
    jal  ra, report

# 5. Tat ca nhanh co dieu kien RV32I
    addi s3, s0, 0
    li   t0, 1
    li   t1, 2
    beq  t0, t0, br5a
    jal  zero, fail5
br5a:
    bne  t0, t1, br5b
    jal  zero, fail5
br5b:
    blt  t0, t1, br5c
    jal  zero, fail5
br5c:
    bge  t1, t0, br5d
    jal  zero, fail5
br5d:
    bltu t0, t1, br5e
    jal  zero, fail5
br5e:
    bgeu t1, t0, br5f
    jal  zero, fail5
br5f:
    # Cac nhanh khong taken cung phai tiep tuc dung duong.
    beq  t0, t1, fail5
    bne  t0, t0, fail5
    bge  t0, t1, fail5
    blt  t1, t0, fail5
    bgeu t0, t1, fail5
    bltu t1, t0, fail5
    jal  zero, pass5
fail5:
    ori  s0, s0, 0x010
pass5:
    li   a0, 5
    jal  ra, report

# 6. Load/store word, half, byte; signed va unsigned
    addi s3, s0, 0
    li   t0, 0x80FF7F01
    sw   t0, 0(s1)
    lw   t1, 0(s1)
    bne  t0, t1, fail6
    lb   t1, 1(s1)
    li   t2, 127
    bne  t1, t2, fail6
    lb   t1, 2(s1)
    li   t2, -1
    bne  t1, t2, fail6
    lbu  t1, 3(s1)
    li   t2, 128
    bne  t1, t2, fail6
    li   t0, 0x8001
    sh   t0, 4(s1)
    lh   t1, 4(s1)
    li   t2, -32767
    bne  t1, t2, fail6
    lhu  t1, 4(s1)
    li   t2, 0x8001
    bne  t1, t2, fail6
    li   t0, 0xA5
    sb   t0, 7(s1)
    lbu  t1, 7(s1)
    bne  t0, t1, fail6
    li   t0, 0x12
    sb   t0, 1(s1)             # kiem tra byte-enable o lane 1
    lbu  t1, 1(s1)
    bne  t0, t1, fail6
    lbu  t1, 0(s1)             # lane ke ben phai khong bi sua
    li   t2, 1
    bne  t1, t2, fail6
    li   t0, 0xABCD
    sh   t0, 6(s1)             # half-word lane cao
    lhu  t1, 6(s1)
    bne  t0, t1, fail6
    jal  zero, pass6
fail6:
    ori  s0, s0, 0x020
pass6:
    li   a0, 6
    jal  ra, report

# 7. LUI va AUIPC
    addi s3, s0, 0
    lui  t0, 0x12345
    li   t1, 0x12345000
    bne  t0, t1, fail7
    auipc t0, 0
    auipc t1, 0
    addi t0, t0, 4
    bne  t0, t1, fail7
    jal  zero, pass7
fail7:
    ori  s0, s0, 0x040
pass7:
    li   a0, 7
    jal  ra, report

# 8. JAL/JALR
    addi s3, s0, 0
    li   t2, 0
    jal  t0, jal_target
jal_return:
    li   t1, 0xA5
    bne  t2, t1, fail8
    jal  zero, pass8
fail8:
    ori  s0, s0, 0x080
pass8:
    li   a0, 8
    jal  ra, report
    jal  zero, group9
jal_target:
    li   t2, 0xA5
    addi t0, t0, 1             # JALR phai xoa bit 0 cua dich
    jalr zero, 0(t0)

# 9. Forwarding: ALU chain va load-use lien nhau
group9:
    addi s3, s0, 0
    li   t0, 1
    addi t0, t0, 1
    addi t0, t0, 1
    add  t0, t0, t0
    li   t1, 6
    bne  t0, t1, fail9
    li   t0, 0x55
    sw   t0, 16(s1)
    lw   t1, 16(s1)
    addi t1, t1, 1
    li   t2, 0x56
    bne  t1, t2, fail9
    jal  zero, pass9
fail9:
    li   t0, 1
    slli t0, t0, 8
    or   s0, s0, t0
pass9:
    li   a0, 9
    jal  ra, report
    jal  ra, crlf

    beq  s0, zero, report_pass
report_fail:
    li a0, 'F'; jal ra, putc
    li a0, 'A'; jal ra, putc
    li a0, 'I'; jal ra, putc
    li a0, 'L'; jal ra, putc
    jal ra, crlf
    jal zero, halt
report_pass:
    li a0, 'P'; jal ra, putc
    li a0, 'A'; jal ra, putc
    li a0, 'S'; jal ra, putc
    li a0, 'S'; jal ra, putc
    jal ra, crlf

halt:
    jal zero, halt

# a0 = so nhom (1..9). In ten nhom va ket qua cua RIENG nhom do.
# s3 la mask truoc nhom, s0 la mask sau nhom.
report:
    addi t4, ra, 0
    addi t5, a0, 0
    li   a0, 'T'; jal ra, putc
    addi a0, t5, 48; jal ra, putc
    li   a0, ' '; jal ra, putc
    li   t0, 1
    beq  t5, t0, report_alu
    li   t0, 2
    beq  t5, t0, report_logic
    li   t0, 3
    beq  t5, t0, report_shift
    li   t0, 4
    beq  t5, t0, report_compare
    li   t0, 5
    beq  t5, t0, report_branch
    li   t0, 6
    beq  t5, t0, report_memory
    li   t0, 7
    beq  t5, t0, report_utype
    li   t0, 8
    beq  t5, t0, report_jump
    # Nhom 9
    li a0, 'H'; jal ra, putc
    li a0, 'A'; jal ra, putc
    li a0, 'Z'; jal ra, putc
    li a0, 'A'; jal ra, putc
    li a0, 'R'; jal ra, putc
    li a0, 'D'; jal ra, putc
    jal zero, report_status
report_alu:
    li a0, 'A'; jal ra, putc
    li a0, 'L'; jal ra, putc
    li a0, 'U'; jal ra, putc
    jal zero, report_status
report_logic:
    li a0, 'L'; jal ra, putc
    li a0, 'O'; jal ra, putc
    li a0, 'G'; jal ra, putc
    li a0, 'I'; jal ra, putc
    li a0, 'C'; jal ra, putc
    jal zero, report_status
report_shift:
    li a0, 'S'; jal ra, putc
    li a0, 'H'; jal ra, putc
    li a0, 'I'; jal ra, putc
    li a0, 'F'; jal ra, putc
    li a0, 'T'; jal ra, putc
    jal zero, report_status
report_compare:
    li a0, 'C'; jal ra, putc
    li a0, 'M'; jal ra, putc
    li a0, 'P'; jal ra, putc
    jal zero, report_status
report_branch:
    li a0, 'B'; jal ra, putc
    li a0, 'R'; jal ra, putc
    li a0, 'A'; jal ra, putc
    li a0, 'N'; jal ra, putc
    li a0, 'C'; jal ra, putc
    li a0, 'H'; jal ra, putc
    jal zero, report_status
report_memory:
    li a0, 'M'; jal ra, putc
    li a0, 'E'; jal ra, putc
    li a0, 'M'; jal ra, putc
    li a0, '-'; jal ra, putc
    li a0, 'B'; jal ra, putc
    li a0, 'H'; jal ra, putc
    li a0, 'W'; jal ra, putc
    jal zero, report_status
report_utype:
    li a0, 'U'; jal ra, putc
    li a0, 'T'; jal ra, putc
    li a0, 'Y'; jal ra, putc
    li a0, 'P'; jal ra, putc
    li a0, 'E'; jal ra, putc
    jal zero, report_status
report_jump:
    li a0, 'J'; jal ra, putc
    li a0, 'U'; jal ra, putc
    li a0, 'M'; jal ra, putc
    li a0, 'P'; jal ra, putc
report_status:
    li a0, ':'; jal ra, putc
    li a0, ' '; jal ra, putc
    bne  s0, s3, report_fail_line
    li a0, 'P'; jal ra, putc
    li a0, 'A'; jal ra, putc
    li a0, 'S'; jal ra, putc
    li a0, 'S'; jal ra, putc
    jal zero, report_done
report_fail_line:
    li a0, 'F'; jal ra, putc
    li a0, 'A'; jal ra, putc
    li a0, 'I'; jal ra, putc
    li a0, 'L'; jal ra, putc
report_done:
    li a0, 13; jal ra, putc
    li a0, 10; jal ra, putc
    jalr zero, 0(t4)

# a0 = ky tu; doi TX FIFO trong roi gui. Su dung t0 lam thanh ghi tam.
putc:
    lw   t0, UART_STAT(s2)
    andi t0, t0, TX_FULL
    bne  t0, zero, putc
    sw   a0, UART_TX(s2)
    jalr zero, 0(ra)

crlf:
    addi t4, ra, 0
    li   a0, 13
    jal  ra, putc
    li   a0, 10
    jal  ra, putc
    jalr zero, 0(t4)
