`timescale 1ns/1ps

module pipeline_regs_ext_tb;
    reg clk;
    reg rst_n;
    integer errors;

    reg         if_id_stall;
    reg         if_id_flush;
    reg         if_valid;
    reg  [31:0] if_pc;
    reg  [31:0] if_pc_plus4;
    reg  [31:0] if_instr;
    reg         if_fault;
    reg  [31:0] if_fault_cause;
    reg  [31:0] if_fault_tval;
    wire        id_valid_o;
    wire [31:0] id_pc_o;
    wire [31:0] id_pc_plus4_o;
    wire [31:0] id_instr_o;
    wire        id_fault_o;
    wire [31:0] id_fault_cause_o;
    wire [31:0] id_fault_tval_o;

    reg         id_ex_stall;
    reg         id_ex_flush;
    reg         id_valid;
    reg  [31:0] id_pc;
    reg  [31:0] id_pc_plus4;
    reg  [31:0] id_instr;
    reg         id_fault;
    reg  [31:0] id_fault_cause;
    reg  [31:0] id_fault_tval;
    reg  [4:0]  id_rs1;
    reg  [4:0]  id_rs2;
    reg  [4:0]  id_rd;
    reg  [31:0] id_rs1_data;
    reg  [31:0] id_rs2_data;
    reg  [31:0] id_imm;
    reg         id_reg_write;
    reg         id_mem_read;
    reg         id_mem_write;
    reg  [1:0]  id_wb_sel;
    reg  [4:0]  id_alu_op;
    reg  [1:0]  id_alu_src_a_sel;
    reg  [1:0]  id_alu_src_b_sel;
    reg  [2:0]  id_branch_type;
    reg         id_jump;
    reg         id_jalr;
    reg  [1:0]  id_mem_size;
    reg         id_mem_unsigned;
    reg         id_csr_en;
    reg  [1:0]  id_csr_op;
    reg         id_csr_use_imm;
    reg         id_mret;
    wire        ex_valid_o;
    wire [31:0] ex_pc_o;
    wire [31:0] ex_pc_plus4_o;
    wire [31:0] ex_instr_o;
    wire        ex_fault_o;
    wire [31:0] ex_fault_cause_o;
    wire [31:0] ex_fault_tval_o;
    wire [4:0]  ex_rs1_o;
    wire [4:0]  ex_rs2_o;
    wire [4:0]  ex_rd_o;
    wire [31:0] ex_rs1_data_o;
    wire [31:0] ex_rs2_data_o;
    wire [31:0] ex_imm_o;
    wire        ex_reg_write_o;
    wire        ex_mem_read_o;
    wire        ex_mem_write_o;
    wire [1:0]  ex_wb_sel_o;
    wire [4:0]  ex_alu_op_o;
    wire [1:0]  ex_alu_src_a_sel_o;
    wire [1:0]  ex_alu_src_b_sel_o;
    wire [2:0]  ex_branch_type_o;
    wire        ex_jump_o;
    wire        ex_jalr_o;
    wire [1:0]  ex_mem_size_o;
    wire        ex_mem_unsigned_o;
    wire        ex_csr_en_o;
    wire [1:0]  ex_csr_op_o;
    wire        ex_csr_use_imm_o;
    wire        ex_mret_o;

    reg         ex_mem_stall;
    reg         ex_mem_flush;
    reg  [31:0] ex_alu_result;
    reg  [31:0] ex_store_data;
    reg  [31:0] ex_csr_rdata;
    reg  [31:0] ex_csr_wdata;
    reg  [11:0] ex_csr_addr;
    reg         ex_csr_we;
    reg         ex_mret;
    wire        mem_valid_o;
    wire [31:0] mem_pc_o;
    wire [31:0] mem_pc_plus4_o;
    wire [31:0] mem_instr_o;
    wire        mem_fault_o;
    wire [31:0] mem_fault_cause_o;
    wire [31:0] mem_fault_tval_o;
    wire [4:0]  mem_rd_o;
    wire [31:0] mem_alu_result_o;
    wire [31:0] mem_store_data_o;
    wire [31:0] mem_csr_rdata_o;
    wire [31:0] mem_csr_wdata_o;
    wire [11:0] mem_csr_addr_o;
    wire        mem_csr_we_o;
    wire        mem_mret_o;
    wire        mem_reg_write_o;
    wire        mem_mem_read_o;
    wire        mem_mem_write_o;
    wire [1:0]  mem_wb_sel_o;
    wire [1:0]  mem_mem_size_o;
    wire        mem_mem_unsigned_o;

    reg         mem_wb_stall;
    reg         mem_wb_flush;
    reg         mem_valid;
    reg  [31:0] mem_pc;
    reg  [31:0] mem_pc_plus4;
    reg  [31:0] mem_instr;
    reg         mem_fault;
    reg  [31:0] mem_fault_cause;
    reg  [31:0] mem_fault_tval;
    reg  [4:0]  mem_rd;
    reg  [31:0] mem_alu_result;
    reg  [31:0] mem_load_data;
    reg  [31:0] mem_csr_rdata;
    reg  [31:0] mem_csr_wdata;
    reg  [11:0] mem_csr_addr;
    reg         mem_csr_we;
    reg         mem_mret;
    reg         mem_reg_write;
    reg  [1:0]  mem_wb_sel;
    wire        wb_valid_o;
    wire [31:0] wb_pc_o;
    wire [31:0] wb_pc_plus4_o;
    wire [31:0] wb_instr_o;
    wire        wb_fault_o;
    wire [31:0] wb_fault_cause_o;
    wire [31:0] wb_fault_tval_o;
    wire [4:0]  wb_rd_o;
    wire [31:0] wb_alu_result_o;
    wire [31:0] wb_load_data_o;
    wire [31:0] wb_csr_rdata_o;
    wire [31:0] wb_csr_wdata_o;
    wire [11:0] wb_csr_addr_o;
    wire        wb_csr_we_o;
    wire        wb_mret_o;
    wire        wb_reg_write_o;
    wire [1:0]  wb_wb_sel_o;

    if_id_reg u_if_id (
        .clk(clk), .rst_n(rst_n), .stall(if_id_stall), .flush(if_id_flush),
        .if_valid(if_valid), .if_pc(if_pc), .if_pc_plus4(if_pc_plus4),
        .if_instr(if_instr), .if_fault(if_fault),
        .if_fault_cause(if_fault_cause), .if_fault_tval(if_fault_tval),
        .id_valid(id_valid_o), .id_pc(id_pc_o), .id_pc_plus4(id_pc_plus4_o),
        .id_instr(id_instr_o), .id_fault(id_fault_o),
        .id_fault_cause(id_fault_cause_o), .id_fault_tval(id_fault_tval_o)
    );

    id_ex_reg u_id_ex (
        .clk(clk), .rst_n(rst_n), .stall(id_ex_stall), .flush(id_ex_flush),
        .id_valid(id_valid), .id_pc(id_pc), .id_pc_plus4(id_pc_plus4),
        .id_instr(id_instr), .id_fault(id_fault),
        .id_fault_cause(id_fault_cause), .id_fault_tval(id_fault_tval),
        .id_rs1(id_rs1), .id_rs2(id_rs2), .id_rd(id_rd),
        .id_rs1_data(id_rs1_data), .id_rs2_data(id_rs2_data), .id_imm(id_imm),
        .id_reg_write(id_reg_write), .id_mem_read(id_mem_read),
        .id_mem_write(id_mem_write), .id_wb_sel(id_wb_sel),
        .id_alu_op(id_alu_op), .id_alu_src_a_sel(id_alu_src_a_sel),
        .id_alu_src_b_sel(id_alu_src_b_sel), .id_branch_type(id_branch_type),
        .id_jump(id_jump), .id_jalr(id_jalr), .id_mem_size(id_mem_size),
        .id_mem_unsigned(id_mem_unsigned), .id_csr_en(id_csr_en),
        .id_csr_op(id_csr_op), .id_csr_use_imm(id_csr_use_imm), .id_mret(id_mret),
        .ex_valid(ex_valid_o), .ex_pc(ex_pc_o), .ex_pc_plus4(ex_pc_plus4_o),
        .ex_instr(ex_instr_o), .ex_fault(ex_fault_o),
        .ex_fault_cause(ex_fault_cause_o), .ex_fault_tval(ex_fault_tval_o),
        .ex_rs1(ex_rs1_o), .ex_rs2(ex_rs2_o), .ex_rd(ex_rd_o),
        .ex_rs1_data(ex_rs1_data_o), .ex_rs2_data(ex_rs2_data_o),
        .ex_imm(ex_imm_o), .ex_reg_write(ex_reg_write_o),
        .ex_mem_read(ex_mem_read_o), .ex_mem_write(ex_mem_write_o),
        .ex_wb_sel(ex_wb_sel_o), .ex_alu_op(ex_alu_op_o),
        .ex_alu_src_a_sel(ex_alu_src_a_sel_o),
        .ex_alu_src_b_sel(ex_alu_src_b_sel_o),
        .ex_branch_type(ex_branch_type_o), .ex_jump(ex_jump_o),
        .ex_jalr(ex_jalr_o), .ex_mem_size(ex_mem_size_o),
        .ex_mem_unsigned(ex_mem_unsigned_o), .ex_csr_en(ex_csr_en_o),
        .ex_csr_op(ex_csr_op_o), .ex_csr_use_imm(ex_csr_use_imm_o),
        .ex_mret(ex_mret_o)
    );

    ex_mem_reg u_ex_mem (
        .clk(clk), .rst_n(rst_n), .stall(ex_mem_stall), .flush(ex_mem_flush),
        .ex_valid(ex_valid_o), .ex_pc(ex_pc_o), .ex_pc_plus4(ex_pc_plus4_o),
        .ex_instr(ex_instr_o), .ex_fault(ex_fault_o),
        .ex_fault_cause(ex_fault_cause_o), .ex_fault_tval(ex_fault_tval_o),
        .ex_rd(ex_rd_o), .ex_alu_result(ex_alu_result),
        .ex_store_data(ex_store_data), .ex_csr_rdata(ex_csr_rdata),
        .ex_csr_wdata(ex_csr_wdata), .ex_csr_addr(ex_csr_addr),
        .ex_csr_we(ex_csr_we), .ex_mret(ex_mret), .ex_reg_write(ex_reg_write_o),
        .ex_mem_read(ex_mem_read_o), .ex_mem_write(ex_mem_write_o),
        .ex_wb_sel(ex_wb_sel_o), .ex_mem_size(ex_mem_size_o),
        .ex_mem_unsigned(ex_mem_unsigned_o),
        .mem_valid(mem_valid_o), .mem_pc(mem_pc_o),
        .mem_pc_plus4(mem_pc_plus4_o), .mem_instr(mem_instr_o),
        .mem_fault(mem_fault_o), .mem_fault_cause(mem_fault_cause_o),
        .mem_fault_tval(mem_fault_tval_o), .mem_rd(mem_rd_o),
        .mem_alu_result(mem_alu_result_o), .mem_store_data(mem_store_data_o),
        .mem_csr_rdata(mem_csr_rdata_o), .mem_csr_wdata(mem_csr_wdata_o),
        .mem_csr_addr(mem_csr_addr_o), .mem_csr_we(mem_csr_we_o),
        .mem_mret(mem_mret_o),
        .mem_reg_write(mem_reg_write_o), .mem_mem_read(mem_mem_read_o),
        .mem_mem_write(mem_mem_write_o), .mem_wb_sel(mem_wb_sel_o),
        .mem_mem_size(mem_mem_size_o), .mem_mem_unsigned(mem_mem_unsigned_o)
    );

    mem_wb_reg u_mem_wb (
        .clk(clk), .rst_n(rst_n), .stall(mem_wb_stall), .flush(mem_wb_flush),
        .mem_valid(mem_valid), .mem_pc(mem_pc), .mem_pc_plus4(mem_pc_plus4),
        .mem_instr(mem_instr), .mem_fault(mem_fault),
        .mem_fault_cause(mem_fault_cause), .mem_fault_tval(mem_fault_tval),
        .mem_rd(mem_rd), .mem_alu_result(mem_alu_result),
        .mem_load_data(mem_load_data), .mem_csr_rdata(mem_csr_rdata),
        .mem_csr_wdata(mem_csr_wdata), .mem_csr_addr(mem_csr_addr),
        .mem_csr_we(mem_csr_we), .mem_mret(mem_mret), .mem_reg_write(mem_reg_write),
        .mem_wb_sel(mem_wb_sel),
        .wb_valid(wb_valid_o), .wb_pc(wb_pc_o), .wb_pc_plus4(wb_pc_plus4_o),
        .wb_instr(wb_instr_o), .wb_fault(wb_fault_o),
        .wb_fault_cause(wb_fault_cause_o), .wb_fault_tval(wb_fault_tval_o),
        .wb_rd(wb_rd_o), .wb_alu_result(wb_alu_result_o),
        .wb_load_data(wb_load_data_o), .wb_csr_rdata(wb_csr_rdata_o),
        .wb_csr_wdata(wb_csr_wdata_o), .wb_csr_addr(wb_csr_addr_o),
        .wb_csr_we(wb_csr_we_o), .wb_mret(wb_mret_o), .wb_reg_write(wb_reg_write_o),
        .wb_wb_sel(wb_wb_sel_o)
    );

    always #5 clk = ~clk;

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

    task drive_if_id;
        input [31:0] base;
        begin
            if_valid = 1'b1;
            if_pc = base;
            if_pc_plus4 = base + 32'd4;
            if_instr = 32'h1111_0000 | base[15:0];
            if_fault = 1'b1;
            if_fault_cause = 32'd1;
            if_fault_tval = base;
        end
    endtask

    task drive_id_ex;
        input [31:0] base;
        begin
            id_valid = 1'b1;
            id_pc = base;
            id_pc_plus4 = base + 32'd4;
            id_instr = 32'h2222_0000 | base[15:0];
            id_fault = 1'b0;
            id_fault_cause = 32'd2;
            id_fault_tval = base + 32'd8;
            id_rs1 = 5'd1;
            id_rs2 = 5'd2;
            id_rd = 5'd3;
            id_rs1_data = 32'hAAAA_0001;
            id_rs2_data = 32'hBBBB_0002;
            id_imm = 32'hCCCC_0003;
            id_reg_write = 1'b1;
            id_mem_read = 1'b1;
            id_mem_write = 1'b0;
            id_wb_sel = 2'd1;
            id_alu_op = 5'd4;
            id_alu_src_a_sel = 2'd1;
            id_alu_src_b_sel = 2'd1;
            id_branch_type = 3'd2;
            id_jump = 1'b1;
            id_jalr = 1'b0;
            id_mem_size = 2'd2;
            id_mem_unsigned = 1'b1;
            id_csr_en = 1'b1;
            id_csr_op = 2'd2;
            id_csr_use_imm = 1'b1;
            id_mret = 1'b0;
        end
    endtask

    task drive_mem_wb;
        input [31:0] base;
        begin
            mem_valid = 1'b1;
            mem_pc = base;
            mem_pc_plus4 = base + 32'd4;
            mem_instr = 32'h4444_0000 | base[15:0];
            mem_fault = 1'b0;
            mem_fault_cause = 32'd5;
            mem_fault_tval = base + 32'd8;
            mem_rd = 5'd9;
            mem_alu_result = 32'h1111_2222;
            mem_load_data = 32'h3333_4444;
            mem_csr_rdata = 32'h5555_6666;
            mem_csr_wdata = 32'h7777_8888;
            mem_csr_addr = 12'h341;
            mem_csr_we = 1'b1;
            mem_mret = 1'b0;
            mem_reg_write = 1'b1;
            mem_wb_sel = 2'd3;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        errors = 0;

        if_id_stall = 1'b0;
        if_id_flush = 1'b0;
        id_ex_stall = 1'b0;
        id_ex_flush = 1'b0;
        ex_mem_stall = 1'b0;
        ex_mem_flush = 1'b0;
        mem_wb_stall = 1'b0;
        mem_wb_flush = 1'b0;

        drive_if_id(32'h0000_0010);
        drive_id_ex(32'h0000_0020);
        ex_alu_result = 32'hAAAA_BBBB;
        ex_store_data = 32'hCCCC_DDDD;
        ex_csr_rdata = 32'h0000_0300;
        ex_csr_wdata = 32'h0000_0301;
        ex_csr_addr = 12'h300;
        ex_csr_we = 1'b1;
        ex_mret = 1'b0;
        drive_mem_wb(32'h0000_0040);

        repeat (2) @(posedge clk);
        #1;
        check(!id_valid_o && id_instr_o == 32'h0000_0013, "if_id reset");
        check(!ex_valid_o && ex_instr_o == 32'h0000_0013, "id_ex reset");
        check(!mem_valid_o && mem_instr_o == 32'h0000_0013, "ex_mem reset");
        check(!wb_valid_o && wb_instr_o == 32'h0000_0013, "mem_wb reset");

        rst_n = 1'b1;
        @(posedge clk);
        #1;
        check(id_valid_o && id_pc_o == 32'h0000_0010 && id_fault_o, "if_id pass");
        check(ex_valid_o && ex_pc_o == 32'h0000_0020 && ex_rd_o == 5'd3 &&
              ex_reg_write_o && ex_mem_read_o && ex_csr_en_o, "id_ex pass");
        check(wb_valid_o && wb_pc_o == 32'h0000_0040 && wb_rd_o == 5'd9 &&
              wb_load_data_o == 32'h3333_4444 && wb_csr_we_o, "mem_wb pass");
        @(posedge clk);
        #1;
        check(mem_valid_o && mem_pc_o == 32'h0000_0020 && mem_rd_o == 5'd3 &&
              mem_alu_result_o == 32'hAAAA_BBBB && mem_csr_we_o, "ex_mem pass");

        if_id_stall = 1'b1;
        drive_if_id(32'h0000_0100);
        @(posedge clk);
        #1;
        check(id_pc_o == 32'h0000_0010, "if_id stall holds");
        if_id_stall = 1'b0;
        if_id_flush = 1'b1;
        @(posedge clk);
        #1;
        check(!id_valid_o && id_instr_o == 32'h0000_0013, "if_id flush clears");
        if_id_flush = 1'b0;

        id_ex_stall = 1'b1;
        drive_id_ex(32'h0000_0200);
        @(posedge clk);
        #1;
        check(ex_pc_o == 32'h0000_0020, "id_ex stall holds");
        id_ex_stall = 1'b0;
        id_ex_flush = 1'b1;
        @(posedge clk);
        #1;
        check(!ex_valid_o && ex_instr_o == 32'h0000_0013 && ex_mem_size_o == 2'd2,
              "id_ex flush clears defaults");
        id_ex_flush = 1'b0;

        drive_id_ex(32'h0000_0300);
        @(posedge clk);
        #1;
        ex_mem_stall = 1'b1;
        ex_alu_result = 32'h1234_5678;
        @(posedge clk);
        #1;
        check(mem_alu_result_o != 32'h1234_5678, "ex_mem stall holds");
        ex_mem_stall = 1'b0;
        ex_mem_flush = 1'b1;
        @(posedge clk);
        #1;
        check(!mem_valid_o && mem_instr_o == 32'h0000_0013 && mem_mem_size_o == 2'd2,
              "ex_mem flush clears defaults");
        ex_mem_flush = 1'b0;

        mem_wb_stall = 1'b1;
        drive_mem_wb(32'h0000_0500);
        @(posedge clk);
        #1;
        check(wb_pc_o == 32'h0000_0040, "mem_wb stall holds");
        mem_wb_stall = 1'b0;
        mem_wb_flush = 1'b1;
        @(posedge clk);
        #1;
        check(!wb_valid_o && wb_instr_o == 32'h0000_0013, "mem_wb flush clears");

        if (errors == 0) begin
            $display("PASS: pipeline_regs_ext_tb");
            $finish;
        end

        $display("FAIL: pipeline_regs_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
