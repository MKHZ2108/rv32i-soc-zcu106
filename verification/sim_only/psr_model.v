`timescale 1ns/1ps
//
// psr_model.v -- behavioral APPROXIMATION of xilinx.com:ip:proc_sys_reset:5.0
//
// IP goc (rv32i_bd_rst_clk_wiz_100M_0) bi Xilinx ma hoa (VHDL protected envelope),
// khong the mo phong bang iverilog. Model nay chi bat dung Y NGHIA logic da cong bo
// trong PG164 (Processor System Reset Module Product Guide):
//   - Cac nguyen nhan reset (ext_reset_in sau khi chuan hoa polarity, aux_reset_in,
//     mb_debug_sys_rst, mat lock cua dcm_locked) duoc OR lai thanh 1 nguyen nhan tho.
//   - Reset duoc dong bo qua flip-flop tren slowest_sync_clk.
//   - Sau khi het nguyen nhan, reset van duoc GIU toi thieu HOLD_CYCLES de tranh
//     glitch/deassert qua nhanh (day la co che duoc PG164 mo ta, khong phai bit-exact
//     so voi IP thuc te).
//
// Muc dich: kiem tra SO DO NOI DAY (ext_reset_in/aux/debug/dcm_locked) va polarity,
// KHONG dung de khang dinh so cycle chinh xac cua IP thuc.
//
module psr_model #(
    parameter C_EXT_RESET_HIGH = 1,   // 1 = ext_reset_in active-High, 0 = active-Low
    parameter HOLD_CYCLES      = 8    // so cycle giu reset toi thieu sau khi het nguyen nhan
) (
    input  wire slowest_sync_clk,
    input  wire ext_reset_in,
    input  wire aux_reset_in,
    input  wire mb_debug_sys_rst,
    input  wire dcm_locked,
    output wire mb_reset,
    output wire bus_struct_reset,
    output wire peripheral_reset,
    output wire interconnect_aresetn,
    output wire peripheral_aresetn
);

    wire ext_reset_asserted = C_EXT_RESET_HIGH ? ext_reset_in : ~ext_reset_in;
    wire raw_reset = ext_reset_asserted | aux_reset_in | mb_debug_sys_rst | ~dcm_locked;

    reg [1:0] sync_ff;
    reg [31:0] hold_cnt;

    always @(posedge slowest_sync_clk) begin
        sync_ff <= {sync_ff[0], raw_reset};
        if (raw_reset)
            hold_cnt <= HOLD_CYCLES;
        else if (hold_cnt != 0)
            hold_cnt <= hold_cnt - 1;
    end

    wire reset_active = raw_reset | sync_ff[0] | sync_ff[1] | (hold_cnt != 0);

    assign mb_reset             = reset_active;
    assign bus_struct_reset     = reset_active;
    assign peripheral_reset     = reset_active;
    assign interconnect_aresetn = ~reset_active;
    assign peripheral_aresetn   = ~reset_active;

endmodule
