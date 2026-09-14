`timescale 1ns / 1ps

module tb_rv32i_bd_wrapper();

    // Tín hiệu kích thích (Inputs cho DUT)
    reg clk_in1_p_0;
    reg clk_in1_n_0;
    reg ext_reset_in_0;
    reg rx_0;

    // Tín hiệu quan sát (Outputs từ DUT)
    wire [0:0] interconnect_aresetn;
    wire [0:0] peripheral_aresetn;
    wire pll_locked;
    wire tx_0;

    // Khởi tạo Device Under Test (DUT)
    rv32i_bd_wrapper dut (
        .clk_in1_p_0(clk_in1_p_0),
        .clk_in1_n_0(clk_in1_n_0),
        .ext_reset_in_0(ext_reset_in_0),
        .interconnect_aresetn(interconnect_aresetn),
        .peripheral_aresetn(peripheral_aresetn),
        .pll_locked(pll_locked),
        .rx_0(rx_0),
        .tx_0(tx_0)
    );

    // 1. Tạo xung clock vi sai 125 MHz (Chu kỳ 8ns -> đảo trạng thái mỗi 4ns)
    initial begin
        clk_in1_p_0 = 1'b0;
        clk_in1_n_0 = 1'b1;
        forever #4 begin
            clk_in1_p_0 = ~clk_in1_p_0;
            clk_in1_n_0 = ~clk_in1_n_0;
        end
    end

    // 2. Kịch bản Reset: Kích hoạt -> Tắt -> Kích hoạt lại
    initial begin
        // Trạng thái ban đầu
        rx_0 = 1'b1; // UART Idle
        
        // [Lần 1] Kích hoạt Reset ban đầu
        ext_reset_in_0 = 1'b1;
        #100;

        // Tắt Reset (Cho PLL khóa và hệ thống chạy)
        // Lưu ý: PLL của Xilinx cần khoảng vài microsecond để locked hoàn toàn trong simulation.
        ext_reset_in_0 = 1'b0;
        #2000; // Giữ 2000ns (2us) để thấy rõ pll_locked = 1 và aresetn = 1

        // [Lần 2] Kích hoạt lại Reset
        ext_reset_in_0 = 1'b1;
        #500;  // Giữ reset 200ns
        ext_reset_in_0 = 1'b0;
        #2000;
        ext_reset_in_0 = 1'b1;
        #500
         ext_reset_in_0 = 1'b0;
        #2000;
        ext_reset_in_0 = 1'b1;
        #500;
        
        // Tắt Reset lần cuối
        ext_reset_in_0 = 1'b0;
        #2000; // Quan sát hệ thống khởi chạy lại sau reset
        #20000
        $display("Mo phong hoan tat!");
        $finish;
    end

endmodule