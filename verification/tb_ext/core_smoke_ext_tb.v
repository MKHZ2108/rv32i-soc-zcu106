`timescale 1ns/1ps

module core_smoke_ext_tb;
    reg clk;
    reg rst_n;
    wire        imem_valid;
    wire [31:0] imem_addr;
    reg         imem_ready;
    reg  [31:0] imem_rdata;
    reg         imem_err;
    wire        dmem_valid;
    wire        dmem_we;
    wire [3:0]  dmem_be;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    reg         dmem_ready;
    reg  [31:0] dmem_rdata;
    reg         dmem_err;
    wire        debug_halted;
    wire [31:0] debug_pc;
    wire [31:0] debug_instr;

    reg [31:0] imem [0:63];
    reg [31:0] dmem [0:63];
    integer i;
    integer errors;
    wire [31:0] dmem_index;

    assign dmem_index = (dmem_addr - 32'h0001_0000) >> 2;

    rv32i_core dut (
        .clk(clk), .rst_n(rst_n),
        .irq_external(1'b0),
        .imem_valid(imem_valid), .imem_addr(imem_addr),
        .imem_ready(imem_ready), .imem_rdata(imem_rdata), .imem_err(imem_err),
        .dmem_valid(dmem_valid), .dmem_we(dmem_we), .dmem_be(dmem_be),
        .dmem_addr(dmem_addr), .dmem_wdata(dmem_wdata),
        .dmem_ready(dmem_ready), .dmem_rdata(dmem_rdata), .dmem_err(dmem_err),
        .debug_halted(debug_halted), .debug_pc(debug_pc), .debug_instr(debug_instr)
    );

    always #5 clk = ~clk;

    function [31:0] r_type;
        input [6:0] f7;
        input [4:0] rs2_i;
        input [4:0] rs1_i;
        input [2:0] f3;
        input [4:0] rd_i;
        begin
            r_type = {f7, rs2_i, rs1_i, f3, rd_i, 7'b0110011};
        end
    endfunction

    function [31:0] i_type;
        input [31:0] imm_i;
        input [4:0]  rs1_i;
        input [2:0]  f3;
        input [4:0]  rd_i;
        input [6:0]  opcode_i;
        begin
            i_type = {imm_i[11:0], rs1_i, f3, rd_i, opcode_i};
        end
    endfunction

    function [31:0] s_type;
        input [31:0] imm_i;
        input [4:0]  rs2_i;
        input [4:0]  rs1_i;
        input [2:0]  f3;
        begin
            s_type = {imm_i[11:5], rs2_i, rs1_i, f3, imm_i[4:0], 7'b0100011};
        end
    endfunction

    function [31:0] b_type;
        input [31:0] imm_i;
        input [4:0]  rs2_i;
        input [4:0]  rs1_i;
        input [2:0]  f3;
        begin
            b_type = {imm_i[12], imm_i[10:5], rs2_i, rs1_i,
                      f3, imm_i[4:1], imm_i[11], 7'b1100011};
        end
    endfunction

    function [31:0] u_type;
        input [19:0] imm20_i;
        input [4:0]  rd_i;
        input [6:0]  opcode_i;
        begin
            u_type = {imm20_i, rd_i, opcode_i};
        end
    endfunction

    function [31:0] j_type;
        input [31:0] imm_i;
        input [4:0]  rd_i;
        begin
            j_type = {imm_i[20], imm_i[10:1], imm_i[11], imm_i[19:12], rd_i, 7'b1101111};
        end
    endfunction

    task check;
        input condition;
        input [127:0] message;
        begin
            if (!condition) begin
                $display("FAIL: %0s", message);
                errors = errors + 1;
            end
        end
    endtask

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            imem_ready <= 1'b0;
            imem_rdata <= 32'h0000_0013;
            imem_err <= 1'b0;
        end else begin
            imem_ready <= imem_valid;
            imem_err <= |imem_addr[31:8];
            if (imem_valid && !(|imem_addr[31:8]))
                imem_rdata <= imem[imem_addr[7:2]];
            else
                imem_rdata <= 32'h0000_0013;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dmem_ready <= 1'b0;
            dmem_rdata <= 32'b0;
            dmem_err <= 1'b0;
        end else begin
            dmem_ready <= dmem_valid;
            dmem_err <= dmem_valid && ((dmem_addr & 32'hFFFF_0000) != 32'h0001_0000);
            if (dmem_valid && ((dmem_addr & 32'hFFFF_0000) == 32'h0001_0000)) begin
                dmem_rdata <= dmem[dmem_index[5:0]];
                if (dmem_we) begin
                    if (dmem_be[0]) dmem[dmem_index[5:0]][7:0] <= dmem_wdata[7:0];
                    if (dmem_be[1]) dmem[dmem_index[5:0]][15:8] <= dmem_wdata[15:8];
                    if (dmem_be[2]) dmem[dmem_index[5:0]][23:16] <= dmem_wdata[23:16];
                    if (dmem_be[3]) dmem[dmem_index[5:0]][31:24] <= dmem_wdata[31:24];
                end
            end else begin
                dmem_rdata <= 32'b0;
            end
        end
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        errors = 0;
        for (i = 0; i < 32; i = i + 1) begin
            dut.u_id.u_reg_file.regs[i] = 32'b0;
        end
        for (i = 0; i < 64; i = i + 1) begin
            imem[i] = 32'h0000_0013;
            dmem[i] = 32'b0;
        end

        imem[0]  = i_type(32'd5, 5'd0, 3'b000, 5'd1, 7'b0010011);
        imem[1]  = i_type(32'd7, 5'd1, 3'b000, 5'd2, 7'b0010011);
        imem[2]  = r_type(7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3);
        imem[3]  = i_type(32'd18, 5'd0, 3'b000, 5'd7, 7'b0010011);
        imem[4]  = u_type(20'h00010, 5'd4, 7'b0110111);
        imem[5]  = s_type(32'd0, 5'd3, 5'd4, 3'b010);
        imem[6]  = i_type(32'd0, 5'd4, 3'b010, 5'd5, 7'b0000011);
        imem[7]  = i_type(32'd1, 5'd5, 3'b000, 5'd6, 7'b0010011);
        imem[8]  = b_type(32'd16, 5'd7, 5'd6, 3'b001);
        imem[9]  = i_type(32'd1, 5'd0, 3'b000, 5'd8, 7'b0010011);
        imem[10] = s_type(32'd4, 5'd8, 5'd4, 3'b010);
        imem[11] = j_type(32'd0, 5'd0);
        imem[12] = i_type(32'd2, 5'd0, 3'b000, 5'd8, 7'b0010011);
        imem[13] = s_type(32'd4, 5'd8, 5'd4, 3'b010);
        imem[14] = j_type(32'd0, 5'd0);

        repeat (3) @(posedge clk);
        rst_n = 1'b1;
        repeat (180) @(posedge clk);

        check(dmem[0] == 32'd17, "core stored ADD result to DMEM");
        check(dmem[1] == 32'd1, "core branch/load-use path stored pass marker");
        check(dut.u_id.u_reg_file.regs[6] == 32'd18, "core load-use result in x6");
        check(dut.u_id.u_reg_file.regs[0] == 32'd0, "core keeps x0 zero");
        check(debug_halted == 1'b0, "debug_halted stays low");

        if (errors == 0) begin
            $display("PASS: core_smoke_ext_tb");
            $finish;
        end

        $display("FAIL: core_smoke_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
