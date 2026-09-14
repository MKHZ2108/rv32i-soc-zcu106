# UART calculator: A,B = 0..9999, each followed by Enter.
# Operation: 1:+  2:-  3:*  4:/ (integer division). Hercules: 115200 8N1.

.equ UART_BASE,0x00040000
.equ RX_FIFO,0x00
.equ TX_FIFO,0x04
.equ STATUS,0x08
.equ CTRL,0x0C
.equ RX_VALID,1
.equ TX_FULL,8

.macro P ch
 li a0,\ch
 jal ra,putc
.endm

.section .text
.global _start
_start:
 li sp,0x00004000
 li t0,UART_BASE
 li t1,3
 sw t1,CTRL(t0)

again:
 P '\r'; P '\n'; P 'A'; P ' '; P '('; P '0'; P '-'; P '9'; P '9'; P '9'; P '9'; P ')'; P ':'; P ' '
 jal ra,get_number
 mv s0,a0

op_again:
 P '\r'; P '\n'; P 'O'; P 'p'; P ' '; P '1'; P ':'; P '+'; P ' '; P '2'; P ':'; P '-'; P ' '; P '3'; P ':'; P '*'; P ' '; P '4'; P ':'; P '/'; P ' '; P '>'; P ' '
 jal ra,get_number
 li t0,1
 bltu a0,t0,op_again
 li t0,5
 bgeu a0,t0,op_again
 mv s1,a0

 P '\r'; P '\n'; P 'B'; P ' '; P '('; P '0'; P '-'; P '9'; P '9'; P '9'; P '9'; P ')'; P ':'; P ' '
 jal ra,get_number
 mv s2,a0

 li t0,1
 beq s1,t0,add
 li t0,2
 beq s1,t0,sub
 li t0,3
 beq s1,t0,mul
 beq s2,zero,div_zero
 mv a0,s0
 mv a1,s2
 jal ra,div_u
 j result
add: add a0,s0,s2; j result
sub: sub a0,s0,s2; j result
mul: mv a0,s0; mv a1,s2; jal ra,mul_u

result:
 mv s3,a0
 P '\r'; P '\n'; P 'R'; P 'e'; P 's'; P 'u'; P 'l'; P 't'; P ':'; P ' '
 mv a0,s3
 jal ra,print_signed
 P '\r'; P '\n'
 j again

div_zero:
 P '\r'; P '\n'; P 'E'; P 'r'; P 'r'; P 'o'; P 'r'; P ':'; P ' '; P 'd'; P 'i'; P 'v'; P ' '; P 'b'; P 'y'; P ' '; P '0'; P '\r'; P '\n'
 j again

# Read 1..4 decimal digits; Enter accepts. Invalid characters and values >9999
# are ignored. Returns value in a0.
get_number:
 addi sp,sp,-16
 sw ra,12(sp)
 sw zero,8(sp)                 # value
 sw zero,4(sp)                 # digit count
num_wait:
 li t0,UART_BASE
 lw t1,STATUS(t0)
 andi t1,t1,RX_VALID
 beq t1,zero,num_wait
 lw a0,RX_FIFO(t0)
 andi a0,a0,0xFF
 li t0,13
 beq a0,t0,num_enter
 li t0,10
 beq a0,t0,num_enter
 li t0,'0'
 bltu a0,t0,num_wait
 li t1,'9'
 bltu t1,a0,num_wait
 lw t2,8(sp)
 li t3,1000
 bgeu t2,t3,num_wait           # max 9999
 jal ra,putc                    # echo valid digit
 addi a0,a0,-'0'
 slli t4,t2,3
 slli t5,t2,1
 add t2,t4,t5                   # old value * 10
 add t2,t2,a0
 sw t2,8(sp)
 lw t3,4(sp)
 addi t3,t3,1
 sw t3,4(sp)
 j num_wait
num_enter:
 lw t2,4(sp)
 beq t2,zero,num_wait
 P '\r'; P '\n'
 lw a0,8(sp)
 lw ra,12(sp)
 addi sp,sp,16
 ret

putc:
 li t0,UART_BASE
putc_wait:
 lw t1,STATUS(t0)
 andi t1,t1,TX_FULL
 bne t1,zero,putc_wait
 sw a0,TX_FIFO(t0)
 ret

# a0=a, a1=b, both nonnegative; result a*b.
mul_u:
 li t0,0
mul_loop:
 beq a1,zero,mul_done
 add t0,t0,a0
 addi a1,a1,-1
 j mul_loop
mul_done: mv a0,t0; ret

# a0=a, a1=b>0; result floor(a/b).
div_u:
 li t0,0
div_loop:
 bltu a0,a1,div_done
 sub a0,a0,a1
 addi t0,t0,1
 j div_loop
div_done: mv a0,t0; ret

# Print signed result in range -9999..99980001 without hardware division.
print_signed:
 addi sp,sp,-24
 sw ra,20(sp); sw s4,16(sp); sw s5,12(sp); sw s6,8(sp); sw s7,4(sp)
 bge a0,zero,print_abs
 P '-'
 sub a0,zero,a0
print_abs:
 mv s4,a0
 li s5,0                        # printed a nonzero digit yet
 li s6,10000000
 jal ra,print_digit
 li s6,1000000
 jal ra,print_digit
 li s6,100000
 jal ra,print_digit
 li s6,10000
 jal ra,print_digit
 li s6,1000
 jal ra,print_digit
 li s6,100
 jal ra,print_digit
 li s6,10
 jal ra,print_digit
 # Always emit the final ones digit.
 addi a0,s4,'0'
 jal ra,putc
 lw ra,20(sp); lw s4,16(sp); lw s5,12(sp); lw s6,8(sp); lw s7,4(sp)
 addi sp,sp,24
 ret

# s4 = remaining magnitude, s6 = decimal divisor, s5 = started flag.
print_digit:
 addi sp,sp,-4
 sw ra,0(sp)
 li s7,0
digit_sub:
 bltu s4,s6,digit_ready
 sub s4,s4,s6
 addi s7,s7,1
 j digit_sub
digit_ready:
 bne s5,zero,digit_emit
 beq s7,zero,digit_return
 li s5,1
digit_emit:
 addi a0,s7,'0'
 jal ra,putc
digit_return:
 lw ra,0(sp)
 addi sp,sp,4
 ret
