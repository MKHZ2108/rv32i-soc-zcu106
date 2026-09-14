.section .text
.global _start

_start:
    # 1. Khởi tạo thanh ghi
    li x1, 0x00002000      # x1 = Địa chỉ gốc DMEM (8KB bắt đầu từ 0x2000)
    li x2, 0x00000008      # x2 = Giá trị test ban đầu
    li x3, 0               # x3 = Đếm số lần lặp

loop:
    # 2. Ghi giá trị ra DMEM
    sw x2, 0(x1)           # Ghi x2 vào DMEM[0x00002000]

    # 3. Đọc lại từ DMEM để kiểm tra
    lw x4, 0(x1)           # Đọc lại từ DMEM[0x00002000] vào x4

    # 4. Biến đổi dữ liệu cho lần lặp tiếp theo
    addi x3, x3, 1         # Tăng biến đếm
    add  x2, x2, x3        # Thay đổi giá trị x2

    # 5. Lặp vô tận
    j loop