# Tùy chọn tăng tốc đã tách khỏi baseline

Thư mục này lưu các biến thể datapath chưa được chọn trong cấu hình FPGA hiện tại:

- `rtl/cla_4bit.v` và `rtl/cla_32bit_group.v`: carry-lookahead adder 32-bit phân nhóm 4-bit.
- `rtl/carry_select_adder.v`: carry-select adder theo block.
- `rtl/barrel_shifter.v`: custom combinational barrel shifter.

Baseline đang dùng `ADDER_IMPL=0` và `SHIFTER_IMPL=0`, tương ứng với `ripple_adder` và phép dịch do trình tổng hợp suy diễn. Các file trong thư mục này không thuộc Vivado source set hoặc regression mặc định.

Không đổi `ADDER_IMPL` hoặc `SHIFTER_IMPL` sang giá trị khác 0 khi các file tùy chọn chưa được thêm lại vào source set. Để thử nghiệm lại, thêm đúng các file RTL cần dùng vào Vivado và danh sách source của testbench, sau đó chạy toàn bộ regression và synthesis/timing riêng trước khi chọn làm baseline.
