`timescale 1ns/1ps
//
// AXI4-Lite integration test cho rv32i_axi_integration_top.
//
// Vi sao co bai test nay: cac testbench hanh vi khac lai imem_ready tu 1 thanh ghi
// va KHONG bao gio noi imem_cancel, nen duong `core_ready = ... && !core_cancel`
// trong imem_axi_lite_adapter (dung noi comb-loop LUTLP-1) khong bao gio bi tap.
// Bai test nay noi core -> 2 AXI-Lite adapter -> 2 slave BRAM AXI-Lite don gian,
// chay chuong trinh CO NHIEU nhanh/nhay de moi lan redirect deu kich imem_cancel
// tren bus that. Day la muc kiem thu gan nhat voi thiet ke tong hop tren FPGA.
//
module axi_integration_ext_tb;
    reg clk;
    reg rst_n;

    wire        debug_halted;
    wire [31:0] debug_pc;
    wire [31:0] debug_instr;

    // ---- IMEM AXI-Lite (read-only) ----
    wire [31:0] i_awaddr;  wire [2:0] i_awprot; wire i_awvalid; wire i_awready;
    wire [31:0] i_wdata;   wire [3:0] i_wstrb;  wire i_wvalid;  wire i_wready;
    wire [1:0]  i_bresp;   wire i_bvalid; wire i_bready;
    wire [31:0] i_araddr;  wire [2:0] i_arprot; wire i_arvalid; wire i_arready;
    wire [31:0] i_rdata;   wire [1:0] i_rresp;  wire i_rvalid;  wire i_rready;

    // ---- DMEM AXI-Lite (read-write) ----
    wire [31:0] d_awaddr;  wire [2:0] d_awprot; wire d_awvalid; wire d_awready;
    wire [31:0] d_wdata;   wire [3:0] d_wstrb;  wire d_wvalid;  wire d_wready;
    wire [1:0]  d_bresp;   wire d_bvalid; wire d_bready;
    wire [31:0] d_araddr;  wire [2:0] d_arprot; wire d_arvalid; wire d_arready;
    wire [31:0] d_rdata;   wire [1:0] d_rresp;  wire d_rvalid;  wire d_rready;

    integer errors;
    integer i;

    rv32i_axi_integration_top #(.RESET_PC(32'h0)) dut (
        .aclk(clk), .aresetn(rst_n),
        .irq_external(1'b0),
        .debug_halted(debug_halted), .debug_pc(debug_pc), .debug_instr(debug_instr),
        .m_axi_imem_awaddr(i_awaddr), .m_axi_imem_awprot(i_awprot),
        .m_axi_imem_awvalid(i_awvalid), .m_axi_imem_awready(i_awready),
        .m_axi_imem_wdata(i_wdata), .m_axi_imem_wstrb(i_wstrb),
        .m_axi_imem_wvalid(i_wvalid), .m_axi_imem_wready(i_wready),
        .m_axi_imem_bresp(i_bresp), .m_axi_imem_bvalid(i_bvalid), .m_axi_imem_bready(i_bready),
        .m_axi_imem_araddr(i_araddr), .m_axi_imem_arprot(i_arprot),
        .m_axi_imem_arvalid(i_arvalid), .m_axi_imem_arready(i_arready),
        .m_axi_imem_rdata(i_rdata), .m_axi_imem_rresp(i_rresp),
        .m_axi_imem_rvalid(i_rvalid), .m_axi_imem_rready(i_rready),
        .m_axi_dmem_awaddr(d_awaddr), .m_axi_dmem_awprot(d_awprot),
        .m_axi_dmem_awvalid(d_awvalid), .m_axi_dmem_awready(d_awready),
        .m_axi_dmem_wdata(d_wdata), .m_axi_dmem_wstrb(d_wstrb),
        .m_axi_dmem_wvalid(d_wvalid), .m_axi_dmem_wready(d_wready),
        .m_axi_dmem_bresp(d_bresp), .m_axi_dmem_bvalid(d_bvalid), .m_axi_dmem_bready(d_bready),
        .m_axi_dmem_araddr(d_araddr), .m_axi_dmem_arprot(d_arprot),
        .m_axi_dmem_arvalid(d_arvalid), .m_axi_dmem_arready(d_arready),
        .m_axi_dmem_rdata(d_rdata), .m_axi_dmem_rresp(d_rresp),
        .m_axi_dmem_rvalid(d_rvalid), .m_axi_dmem_rready(d_rready)
    );

    axi_lite_ram #(.WORDS(256), .RW(0)) u_imem (
        .clk(clk), .rst_n(rst_n),
        .awaddr(i_awaddr), .awvalid(i_awvalid), .awready(i_awready),
        .wdata(i_wdata), .wstrb(i_wstrb), .wvalid(i_wvalid), .wready(i_wready),
        .bresp(i_bresp), .bvalid(i_bvalid), .bready(i_bready),
        .araddr(i_araddr), .arvalid(i_arvalid), .arready(i_arready),
        .rdata(i_rdata), .rresp(i_rresp), .rvalid(i_rvalid), .rready(i_rready)
    );

    axi_lite_ram #(.WORDS(256), .RW(1), .BASE(32'h0001_0000)) u_dmem (
        .clk(clk), .rst_n(rst_n),
        .awaddr(d_awaddr), .awvalid(d_awvalid), .awready(d_awready),
        .wdata(d_wdata), .wstrb(d_wstrb), .wvalid(d_wvalid), .wready(d_wready),
        .bresp(d_bresp), .bvalid(d_bvalid), .bready(d_bready),
        .araddr(d_araddr), .arvalid(d_arvalid), .arready(d_arready),
        .rdata(d_rdata), .rresp(d_rresp), .rvalid(d_rvalid), .rready(d_rready)
    );

    always #5 clk = ~clk;

    function [31:0] i_type;
        input [31:0] imm_i; input [4:0] rs1_i; input [2:0] f3; input [4:0] rd_i; input [6:0] op;
        begin i_type = {imm_i[11:0], rs1_i, f3, rd_i, op}; end
    endfunction
    function [31:0] r_type;
        input [6:0] f7; input [4:0] rs2_i; input [4:0] rs1_i; input [2:0] f3; input [4:0] rd_i;
        begin r_type = {f7, rs2_i, rs1_i, f3, rd_i, 7'b0110011}; end
    endfunction
    function [31:0] s_type;
        input [31:0] imm_i; input [4:0] rs2_i; input [4:0] rs1_i; input [2:0] f3;
        begin s_type = {imm_i[11:5], rs2_i, rs1_i, f3, imm_i[4:0], 7'b0100011}; end
    endfunction
    function [31:0] b_type;
        input [31:0] imm_i; input [4:0] rs2_i; input [4:0] rs1_i; input [2:0] f3;
        begin b_type = {imm_i[12], imm_i[10:5], rs2_i, rs1_i, f3, imm_i[4:1], imm_i[11], 7'b1100011}; end
    endfunction
    function [31:0] j_type;
        input [31:0] imm_i; input [4:0] rd_i;
        begin j_type = {imm_i[20], imm_i[10:1], imm_i[11], imm_i[19:12], rd_i, 7'b1101111}; end
    endfunction
    function [31:0] u_type;
        input [19:0] imm20_i; input [4:0] rd_i; input [6:0] op;
        begin u_type = {imm20_i, rd_i, op}; end
    endfunction

    task check;
        input condition;
        input [255:0] message;
        begin
            if (!condition) begin
                $display("FAIL: %0s", message);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        errors = 0;

        for (i = 0; i < 256; i = i + 1) begin
            u_imem.mem[i] = 32'h0000_0013;   // NOP
            u_dmem.mem[i] = 32'b0;
        end
        for (i = 0; i < 32; i = i + 1)
            dut.u_core.u_id.u_reg_file.regs[i] = 32'b0;

        // Chuong trinh: nhieu nhanh + nhay de moi redirect kich imem_cancel tren bus AXI.
        //  x1 = 5; x2 = 7; x3 = x1+x2 (=12)
        //  taken branch (bat buoc redirect) nhay qua 1 lenh "poison"
        //  x4 = 0x10000 base; store x3 -> [x4]
        //  jal nhay toi khoi ket thuc; store marker 1 -> [x4+4]; loop.
        u_imem.mem[0] = i_type(32'd5, 5'd0, 3'b000, 5'd1, 7'b0010011);   // addi x1,x0,5
        u_imem.mem[1] = i_type(32'd7, 5'd0, 3'b000, 5'd2, 7'b0010011);   // addi x2,x0,7
        u_imem.mem[2] = r_type(7'b0, 5'd2, 5'd1, 3'b000, 5'd3);          // add  x3,x1,x2 =12
        u_imem.mem[3] = b_type(32'd8, 5'd0, 5'd0, 3'b000);              // beq  x0,x0,+8 -> mem[5]
        u_imem.mem[4] = i_type(32'hFFF, 5'd0, 3'b000, 5'd3, 7'b0010011); // POISON: x3=-1 (phai bi bo)
        u_imem.mem[5] = u_type(20'h00010, 5'd4, 7'b0110111);            // lui  x4,0x10
        u_imem.mem[6] = s_type(32'd0, 5'd3, 5'd4, 3'b010);              // sw   x3,0(x4)
        u_imem.mem[7] = j_type(32'd8, 5'd0);                           // jal  x0,+8 -> mem[9]
        u_imem.mem[8] = i_type(32'hFFF, 5'd0, 3'b000, 5'd3, 7'b0010011); // POISON (phai bi bo)
        u_imem.mem[9] = i_type(32'd1, 5'd0, 3'b000, 5'd8, 7'b0010011);   // addi x8,x0,1
        u_imem.mem[10] = s_type(32'd4, 5'd8, 5'd4, 3'b010);            // sw   x8,4(x4) (marker)
        u_imem.mem[11] = j_type(32'd0, 5'd0);                          // self loop

        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (600) @(posedge clk);

        // [0x10000] = 12 -> add dung, POISON x3=-1 (mem[4]) da bi nhanh bo qua.
        check(u_dmem.mem[0] == 32'd12, "AXI: store add-result qua DMEM (branch da bo POISON)");
        // [0x10004] = 1 -> jal da bo qua POISON mem[8] va toi duoc marker.
        check(u_dmem.mem[1] == 32'd1, "AXI: jal redirect toi duoc marker (bo POISON)");
        check(dut.u_core.u_id.u_reg_file.regs[3] == 32'd12, "AXI: x3 giu gia tri dung, khong bi POISON");
        check(debug_halted == 1'b0, "AXI: debug_halted stays low");

        if (errors == 0) begin
            $display("PASS: axi_integration_ext_tb");
            $finish;
        end
        $display("FAIL: axi_integration_ext_tb %0d errors", errors);
        $finish;
    end
endmodule

// -----------------------------------------------------------------------------
// AXI4-Lite slave RAM don gian (1 giao dich mot luc). RW=0 -> read-only (IMEM).
// Dia chi noi bo = (addr - BASE) >> 2. Ready xac lap trong 1 chu ky.
// -----------------------------------------------------------------------------
module axi_lite_ram #(
    parameter WORDS = 256,
    parameter RW    = 1,
    parameter [31:0] BASE = 32'h0000_0000
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [31:0] awaddr, input wire awvalid, output reg awready,
    input  wire [31:0] wdata,  input wire [3:0] wstrb, input wire wvalid, output reg wready,
    output reg  [1:0]  bresp,  output reg bvalid, input wire bready,
    input  wire [31:0] araddr, input wire arvalid, output reg arready,
    output reg  [31:0] rdata,  output reg [1:0] rresp, output reg rvalid, input wire rready
);
    reg [31:0] mem [0:WORDS-1];

    wire [31:0] widx = (awaddr - BASE) >> 2;
    wire [31:0] ridx = (araddr - BASE) >> 2;

    reg aw_seen, w_seen;
    reg [31:0] waddr_l, wdata_l;
    reg [3:0]  wstrb_l;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            awready <= 1'b0; wready <= 1'b0; bvalid <= 1'b0; bresp <= 2'b0;
            arready <= 1'b0; rvalid <= 1'b0; rresp <= 2'b0; rdata <= 32'b0;
            aw_seen <= 1'b0; w_seen <= 1'b0;
            waddr_l <= 32'b0; wdata_l <= 32'b0; wstrb_l <= 4'b0;
        end else begin
            // ---- write address / data capture ----
            awready <= 1'b0;
            wready  <= 1'b0;
            if (RW != 0) begin
                if (awvalid && !aw_seen) begin
                    awready <= 1'b1; aw_seen <= 1'b1; waddr_l <= awaddr;
                end
                if (wvalid && !w_seen) begin
                    wready <= 1'b1; w_seen <= 1'b1; wdata_l <= wdata; wstrb_l <= wstrb;
                end
                // ca hai da bat tay -> commit + bresp
                if (aw_seen && w_seen && !bvalid) begin
                    if (wstrb_l[0]) mem[(waddr_l - BASE) >> 2][7:0]   <= wdata_l[7:0];
                    if (wstrb_l[1]) mem[(waddr_l - BASE) >> 2][15:8]  <= wdata_l[15:8];
                    if (wstrb_l[2]) mem[(waddr_l - BASE) >> 2][23:16] <= wdata_l[23:16];
                    if (wstrb_l[3]) mem[(waddr_l - BASE) >> 2][31:24] <= wdata_l[31:24];
                    bvalid <= 1'b1; bresp <= 2'b00;
                end
                if (bvalid && bready) begin
                    bvalid <= 1'b0; aw_seen <= 1'b0; w_seen <= 1'b0;
                end
            end

            // ---- read ----
            arready <= 1'b0;
            if (arvalid && !rvalid && !arready) begin
                arready <= 1'b1;
                rdata   <= mem[ridx[$clog2(WORDS)-1:0]];
                rresp   <= 2'b00;
                rvalid  <= 1'b1;
            end
            if (rvalid && rready) begin
                rvalid <= 1'b0;
            end
        end
    end
endmodule
