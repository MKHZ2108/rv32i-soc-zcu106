`timescale 1ns/1ps

module stage_ext_tb;
    localparam ALU_ADD = 5'd0;

    reg clk;
    reg rst_n;
    integer errors;

    reg         if_stall_pc;
    reg         if_redirect_valid;
    reg  [31:0] if_redirect_target;
    wire        imem_valid;
    wire [31:0] imem_addr;
    reg         imem_ready;
    reg  [31:0] imem_rdata;
    reg         imem_err;
    wire        if_valid;
    wire [31:0] if_pc;
    wire [31:0] if_pc_plus4;
    wire [31:0] if_instr;
    wire        if_fault;
    wire [31:0] if_fault_cause;
    wire [31:0] if_fault_tval;

    reg         id_valid;
    reg  [31:0] id_pc;
    reg  [31:0] id_instr;
    reg         id_fault_in;
    reg  [31:0] id_fault_cause_in;
    reg  [31:0] id_fault_tval_in;
    reg         wb_reg_write;
    reg  [4:0]  wb_rd;
    reg  [31:0] wb_data;
    wire        id_fault_out;
    wire        id_illegal_instr;
    wire        id_ecall;
    wire        id_ebreak;
    wire        id_mret;
    wire [31:0] id_fault_cause;
    wire [31:0] id_fault_tval;
    wire [4:0]  id_rs1;
    wire [4:0]  id_rs2;
    wire [4:0]  id_rd;
    wire [31:0] id_rs1_data;
    wire [31:0] id_rs2_data;
    wire [31:0] id_imm;
    wire        id_reg_write;
    wire        id_mem_read;
    wire        id_mem_write;
    wire [1:0]  id_wb_sel;
    wire [4:0]  id_alu_op;
    wire [1:0]  id_alu_src_a_sel;
    wire [1:0]  id_alu_src_b_sel;
    wire [2:0]  id_branch_type;
    wire        id_jump;
    wire        id_jalr;
    wire [1:0]  id_mem_size;
    wire        id_mem_unsigned;
    wire        id_csr_en;
    wire [1:0]  id_csr_op;
    wire        id_csr_use_imm;

    reg         ex_valid;
    reg  [31:0] ex_pc;
    reg  [31:0] ex_pc_plus4;
    reg  [31:0] ex_instr;
    reg         ex_fault_in;
    reg  [31:0] ex_fault_cause_in;
    reg  [31:0] ex_fault_tval_in;
    reg  [4:0]  ex_rs1;
    reg  [31:0] ex_rs1_data;
    reg  [31:0] ex_rs2_data;
    reg  [31:0] ex_imm;
    reg  [4:0]  ex_alu_op;
    reg  [1:0]  ex_alu_src_a_sel;
    reg  [1:0]  ex_alu_src_b_sel;
    reg  [2:0]  ex_branch_type;
    reg         ex_jump;
    reg         ex_jalr;
    reg         ex_csr_en;
    reg  [1:0]  ex_csr_op;
    reg         ex_csr_use_imm;
    reg         ex_mret;
    reg  [1:0]  forward_a_sel;
    reg  [1:0]  forward_b_sel;
    reg  [31:0] forward_mem_data;
    reg  [31:0] forward_wb_data;
    reg  [31:0] csr_rdata;
    reg  [31:0] mepc_value;
    reg         csr_valid;
    reg         csr_read_only;
    wire        ex_redirect_valid;
    wire [31:0] ex_redirect_target;
    wire        ex_fault_out;
    wire [31:0] ex_fault_cause;
    wire [31:0] ex_fault_tval;
    wire [31:0] ex_alu_result;
    wire [31:0] ex_store_data;
    wire [31:0] ex_csr_rdata;
    wire [31:0] ex_csr_wdata;
    wire [11:0] ex_csr_addr;
    wire        ex_csr_we;

    if_stage u_if (
        .clk(clk), .rst_n(rst_n), .stall_pc(if_stall_pc),
        .pc_redirect_valid(if_redirect_valid),
        .pc_redirect_target(if_redirect_target),
        .imem_valid(imem_valid), .imem_addr(imem_addr),
        .imem_ready(imem_ready), .imem_rdata(imem_rdata), .imem_err(imem_err),
        .if_valid(if_valid), .if_pc(if_pc), .if_pc_plus4(if_pc_plus4),
        .if_instr(if_instr), .if_fault(if_fault),
        .if_fault_cause(if_fault_cause), .if_fault_tval(if_fault_tval)
    );

    id_stage u_id (
        .clk(clk), .rst_n(rst_n), .id_valid(id_valid), .id_pc(id_pc),
        .id_instr(id_instr), .id_fault_in(id_fault_in),
        .id_fault_cause_in(id_fault_cause_in), .id_fault_tval_in(id_fault_tval_in),
        .wb_reg_write(wb_reg_write), .wb_rd(wb_rd), .wb_data(wb_data),
        .id_fault_out(id_fault_out), .id_illegal_instr(id_illegal_instr),
        .id_ecall(id_ecall), .id_ebreak(id_ebreak), .id_mret(id_mret),
        .id_fault_cause(id_fault_cause), .id_fault_tval(id_fault_tval),
        .id_rs1(id_rs1), .id_rs2(id_rs2), .id_rd(id_rd),
        .id_rs1_data(id_rs1_data), .id_rs2_data(id_rs2_data), .id_imm(id_imm),
        .id_reg_write(id_reg_write), .id_mem_read(id_mem_read),
        .id_mem_write(id_mem_write), .id_wb_sel(id_wb_sel), .id_alu_op(id_alu_op),
        .id_alu_src_a_sel(id_alu_src_a_sel), .id_alu_src_b_sel(id_alu_src_b_sel),
        .id_branch_type(id_branch_type), .id_jump(id_jump), .id_jalr(id_jalr),
        .id_mem_size(id_mem_size), .id_mem_unsigned(id_mem_unsigned),
        .id_csr_en(id_csr_en), .id_csr_op(id_csr_op), .id_csr_use_imm(id_csr_use_imm)
    );

    ex_stage u_ex (
        .ex_valid(ex_valid), .ex_pc(ex_pc), .ex_pc_plus4(ex_pc_plus4),
        .ex_instr(ex_instr), .ex_fault_in(ex_fault_in),
        .ex_fault_cause_in(ex_fault_cause_in), .ex_fault_tval_in(ex_fault_tval_in),
        .ex_rs1(ex_rs1), .ex_rs1_data(ex_rs1_data), .ex_rs2_data(ex_rs2_data),
        .ex_imm(ex_imm), .ex_alu_op(ex_alu_op),
        .ex_alu_src_a_sel(ex_alu_src_a_sel), .ex_alu_src_b_sel(ex_alu_src_b_sel),
        .ex_branch_type(ex_branch_type), .ex_jump(ex_jump), .ex_jalr(ex_jalr),
        .ex_csr_en(ex_csr_en), .ex_csr_op(ex_csr_op), .ex_csr_use_imm(ex_csr_use_imm),
        .ex_mret(ex_mret), .forward_a_sel(forward_a_sel),
        .forward_b_sel(forward_b_sel), .forward_mem_data(forward_mem_data),
        .forward_wb_data(forward_wb_data), .csr_rdata(csr_rdata),
        .mepc_value(mepc_value), .csr_valid(csr_valid),
        .csr_read_only(csr_read_only), .pc_redirect_valid(ex_redirect_valid),
        .pc_redirect_target(ex_redirect_target), .ex_fault_out(ex_fault_out),
        .ex_fault_cause(ex_fault_cause), .ex_fault_tval(ex_fault_tval),
        .ex_alu_result(ex_alu_result), .ex_store_data(ex_store_data),
        .ex_csr_rdata(ex_csr_rdata), .ex_csr_wdata(ex_csr_wdata),
        .ex_csr_addr(ex_csr_addr), .ex_csr_we(ex_csr_we)
    );

    always #5 clk = ~clk;

    function [31:0] i_type;
        input [31:0] imm_i;
        input [4:0]  rs1_i;
        input [2:0]  funct3_i;
        input [4:0]  rd_i;
        input [6:0]  opcode_i;
        begin
            i_type = {imm_i[11:0], rs1_i, funct3_i, rd_i, opcode_i};
        end
    endfunction

    function [31:0] b_type;
        input [31:0] imm_i;
        input [4:0]  rs2_i;
        input [4:0]  rs1_i;
        input [2:0]  funct3_i;
        begin
            b_type = {imm_i[12], imm_i[10:5], rs2_i, rs1_i,
                      funct3_i, imm_i[4:1], imm_i[11], 7'b1100011};
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

    task init_ex;
        begin
            ex_valid = 1'b1;
            ex_pc = 32'h0000_0100;
            ex_pc_plus4 = 32'h0000_0104;
            ex_instr = 32'b0;
            ex_fault_in = 1'b0;
            ex_fault_cause_in = 32'b0;
            ex_fault_tval_in = 32'b0;
            ex_rs1 = 5'd1;
            ex_rs1_data = 32'd5;
            ex_rs2_data = 32'd6;
            ex_imm = 32'd8;
            ex_alu_op = ALU_ADD;
            ex_alu_src_a_sel = 2'd0;
            ex_alu_src_b_sel = 2'd0;
            ex_branch_type = 3'd0;
            ex_jump = 1'b0;
            ex_jalr = 1'b0;
            ex_csr_en = 1'b0;
            ex_csr_op = 2'd0;
            ex_csr_use_imm = 1'b0;
            ex_mret = 1'b0;
            forward_a_sel = 2'd0;
            forward_b_sel = 2'd0;
            forward_mem_data = 32'd10;
            forward_wb_data = 32'd3;
            csr_rdata = 32'h0000_00F0;
            mepc_value = 32'h0000_0400;
            csr_valid = 1'b1;
            csr_read_only = 1'b0;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        errors = 0;

        if_stall_pc = 1'b0;
        if_redirect_valid = 1'b0;
        if_redirect_target = 32'b0;
        imem_ready = 1'b1;
        imem_rdata = i_type(32'd1, 5'd0, 3'b000, 5'd1, 7'b0010011);
        imem_err = 1'b0;

        id_valid = 1'b0;
        id_pc = 32'h0000_0020;
        id_instr = 32'h0000_0013;
        id_fault_in = 1'b0;
        id_fault_cause_in = 32'b0;
        id_fault_tval_in = 32'b0;
        wb_reg_write = 1'b0;
        wb_rd = 5'd0;
        wb_data = 32'b0;

        init_ex();

        repeat (2) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;

        @(posedge clk);
        #1;
        check(imem_valid && imem_addr == 32'h0000_0004, "if_stage request advances PC");
        check(if_valid && if_pc == 32'h0000_0000 && if_instr == i_type(32'd1, 5'd0, 3'b000, 5'd1, 7'b0010011),
              "if_stage returns previous request");

        imem_rdata = i_type(32'd2, 5'd0, 3'b000, 5'd2, 7'b0010011);
        @(posedge clk);
        imem_ready = 1'b0;
        #1;
        check(imem_valid && imem_addr == 32'h0000_0004 && !if_valid,
              "if_stage holds fetch request while imem is not ready");

        @(posedge clk);
        #1;
        check(imem_addr == 32'h0000_0004 && !if_valid,
              "if_stage keeps holding fetch request across imem wait cycles");

        imem_ready = 1'b1;
        #1;
        check(if_valid && if_pc == 32'h0000_0004 &&
              if_instr == i_type(32'd2, 5'd0, 3'b000, 5'd2, 7'b0010011),
              "if_stage returns held request after imem wait");
        @(posedge clk);
        #1;
        imem_rdata = i_type(32'd3, 5'd0, 3'b000, 5'd3, 7'b0010011);

        wb_reg_write = 1'b1;
        wb_rd = 5'd4;
        wb_data = 32'h0000_0055;
        @(posedge clk);
        #1;
        wb_reg_write = 1'b0;

        id_valid = 1'b1;
        id_pc = 32'h0000_0020;
        id_instr = i_type(32'hFFFF_FFFF, 5'd4, 3'b000, 5'd3, 7'b0010011);
        #1;
        check(id_rs1 == 5'd4 && id_rd == 5'd3 && id_imm == 32'hFFFF_FFFF, "id_stage ADDI fields");
        check(id_rs1_data == 32'h0000_0055 && id_reg_write && id_alu_src_b_sel == 2'd1,
              "id_stage regfile read and ADDI control");

        id_instr = 32'hFFFF_FFFF;
        #1;
        check(id_fault_out && id_illegal_instr && id_fault_cause == 32'd2 &&
              id_fault_tval == 32'hFFFF_FFFF, "id_stage illegal instruction fault");

        init_ex();
        forward_a_sel = 2'd1;
        forward_b_sel = 2'd2;
        #1;
        check(ex_alu_result == 32'd13 && ex_store_data == 32'd3, "ex_stage forwarding into ALU/store");

        init_ex();
        ex_branch_type = 3'd1;
        ex_rs2_data = 32'd5;
        ex_imm = 32'd12;
        #1;
        check(ex_redirect_valid && ex_redirect_target == 32'h0000_010C, "ex_stage BEQ redirect");

        init_ex();
        ex_jump = 1'b1;
        ex_jalr = 1'b1;
        ex_rs1_data = 32'h0000_0101;
        ex_imm = 32'd4;
        #1;
        check(ex_redirect_valid && ex_redirect_target == 32'h0000_0104, "ex_stage JALR clears bit 0");

        init_ex();
        ex_csr_en = 1'b1;
        ex_csr_op = 2'd1;
        ex_csr_use_imm = 1'b0;
        ex_rs1_data = 32'h0000_000F;
        ex_instr = {12'h300, 20'b0};
        #1;
        check(ex_csr_we && ex_csr_addr == 12'h300 && ex_csr_wdata == 32'h0000_00FF,
              "ex_stage CSRRS write data");

        csr_read_only = 1'b1;
        #1;
        check(ex_fault_out && ex_fault_cause == 32'd2 && !ex_csr_we,
              "ex_stage read-only CSR write fault");

        init_ex();
        ex_valid = 1'b0;
        ex_csr_en = 1'b1;
        ex_csr_op = 2'd0;
        ex_instr = {12'hC00, 20'b0};
        csr_valid = 1'b1;
        csr_read_only = 1'b1;
        #1;
        check(!ex_fault_out && ex_fault_cause == 32'd0 && ex_fault_tval == 32'd0 && !ex_csr_we,
              "ex_stage ignores stale CSR controls in invalid bubble");

        init_ex();
        ex_mret = 1'b1;
        #1;
        check(ex_redirect_valid && ex_redirect_target == 32'h0000_0400, "ex_stage MRET redirect");

        if (errors == 0) begin
            $display("PASS: stage_ext_tb");
            $finish;
        end

        $display("FAIL: stage_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
