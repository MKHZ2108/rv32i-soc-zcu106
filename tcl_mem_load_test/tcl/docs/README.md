# RV32I: JTAG, UART và Interrupt

## 1. Bảng lệnh đơn

Chạy các lệnh Tcl trong **Vivado Tcl Console**, trừ các lệnh `build.bat` chạy
trong **Command Prompt** tại `Tutorial/tcl`.

| Chức năng | Lệnh đơn |
|---|---|
| Vào thư mục làm việc | <pre><code>cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl</code></pre> |
| Build firmware interrupt | <pre><code>build.bat test_uart_irq.s</code></pre> |
| Chọn firmware interrupt để nạp | <pre><code>set ::rv_mem_file "test_uart_irq.mem"</code></pre> |
| Nạp file `.mem` đã chọn vào IMEM | <pre><code>source -notrace load_imem.tcl</code></pre> |
| Đọc 16 word IMEM từ địa chỉ 0 | <pre><code>source -notrace read_imem.tcl</code></pre> |
| Chọn vùng IMEM để đọc | <pre><code>set ::rv_imem_start 0x00000100
set ::rv_imem_words 16</code></pre> |
| Đọc marker DMEM | <pre><code>source -notrace read_dmem.tcl</code></pre> |
| Khôi phục Hardware Target/JTAG-AXI | <pre><code>source -notrace reconnect_hw.tcl</code></pre> |
| Chạy CPU với firmware vừa nạp | Nhấn giữ **SW20 / CPU_RESET** khoảng 0.5 giây, rồi thả. |

## 2. Cụm lệnh test nhanh

### Test UART interrupt — dùng trước tiên

Mục tiêu: xác minh đường `UARTLite → AXI INTC → irq_external → ISR`.

**A. Nếu vừa đổi Block Design:** Save → Validate Design → Generate Output
Products → Create Bitstream → Program Device.

**B. Command Prompt tại `Tutorial/tcl`:**

```bat
build.bat test_uart_irq.s
```

**C. Vivado Tcl Console:**

```tcl
cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl
set ::rv_mem_file "test_uart_irq.mem"
source -notrace load_imem.tcl
```

**D. Board và Hercules:**

1. Nhấn-thả SW20.
2. Mở Hercules Serial: `115200`, `8N1`, `Handshake OFF`, `Local Echo OFF`.
3. Phải nhận dòng `IRQ ready`.
4. Nhập `a` vào ô Send rồi bấm Send. Board phải echo `a`.

### Test CPU đầy đủ — kết quả qua UART, không cần JTAG → DMEM

Kiểm tra ALU, logic, shift, so sánh, branch, load/store byte-half-word,
LUI/AUIPC, JAL/JALR và pipeline hazards. Mỗi nhóm tự báo `PASS` hoặc `FAIL`.

```bat
build.bat test_cpu.s
```

```tcl
cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl
set ::rv_mem_file "test_cpu.mem"
source -notrace load_imem.tcl
```

Nhấn-thả SW20, sau đó xem Hercules (`115200`, `8N1`, `Handshake OFF`,
`Local Echo OFF`). Kết quả tốt kết thúc bằng dòng `PASS`.

### Test UART polling echo — không dùng interrupt

```bat
build.bat test_uart.s
```

```tcl
cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl
set ::rv_mem_file "test_uart.mem"
source -notrace load_imem.tcl
```

Nhấn-thả SW20, sau đó gửi ký tự trong Hercules; board echo lại bằng polling.

### Test UART calculator — nhập A, chọn phép tính, nhập B

Hỗ trợ số nguyên không âm `0–9999`; nhập mỗi số rồi bấm Enter. Chọn `1:+`,
`2:-`, `3:*`, `4:/`. Phép chia lấy phần nguyên; chia cho 0 báo lỗi.

```bat
build.bat test_uart_calculator.s
```

```tcl
cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl
set ::rv_mem_file "test_uart_calculator.mem"
source -notrace load_imem.tcl
```

Nhấn-thả SW20, sau đó dùng Hercules (`115200`, `8N1`, `Local Echo OFF`). Ví dụ
nhập `123`, bấm Enter, chọn `3`, bấm Enter, nhập `45`, bấm Enter; board trả
`Result: 5535`.

### Xác minh handler interrupt trong IMEM

```tcl
set ::rv_imem_start 0x00000100
set ::rv_imem_words 16
source -notrace read_imem.tcl
```

## 3. Kiến thức tối thiểu

### Memory map

| Vùng | Địa chỉ | Vai trò |
|---|---:|---|
| Instruction BRAM | `0x0000_0000–0x0000_1FFF` | Main và interrupt handler |
| Data BRAM | `0x0000_2000–0x0000_3FFF` | Biến, stack, marker debug |
| AXI UARTLite | `0x0004_0000–0x0004_FFFF` | UART RX/TX, nguồn interrupt |
| AXI INTC | `0x0005_0000–0x0005_FFFF` | Enable/pending/acknowledge interrupt |

### Luồng interrupt

```text
Hercules gửi byte
→ UARTLite RX FIFO
→ AXI INTC pending + irq
→ core irq_external
→ core nhảy tới mtvec = 0x100
→ ISR trong IMEM đọc RX, echo, acknowledge INTC
→ mret quay lại main
```

`mtvec = 0x100` là do firmware test chọn. Code handler đã được nạp sẵn tại
`IMEM[0x100]`, không có bộ nhớ interrupt riêng.

### Marker debug của test interrupt

Chỉ đọc được khi JTAG map Data BRAM:

| Địa chỉ | Ý nghĩa |
|---:|---|
| `0x2000` | `49525131`: firmware đã chạy |
| `0x2004` | Số lần vào ISR |
| `0x2008` | `8000000B`: machine external interrupt (`mcause`) |
| `0x200C` | Ký tự RX gần nhất |

## 4. Lỗi thường gặp

| Hiện tượng | Xử lý |
|---|---|
| Không có `IRQ ready` | Nạp lại `test_uart_irq.mem`, nhấn-thả SW20, kiểm tra UART 115200 8N1. |
| Có `IRQ ready` nhưng không echo | Kiểm tra `M_AXI_DMEM` map UART `0x40000`, INTC `0x50000`; Program bitstream mới nếu vừa đổi map. |
| Không có `U` ở TX test | Kiểm tra COM, baud, chân TX và bitstream/map UART. |
| JTAG/AXI timeout | Chạy `source -notrace reconnect_hw.tcl`. |
| `read_dmem.tcl` timeout | Bỏ Excluded cho Data BRAM dưới `jtag_axi_0/Data`, hoặc không dùng đọc DMEM. |
