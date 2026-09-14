`timescale 1ns/1ps

module rv32i_core #(
    parameter XLEN         = 32,
    parameter RESET_PC     = 32'h0000_0000,
    parameter ADDER_IMPL   = 0,
    parameter SHIFTER_IMPL = 0
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        irq_external,
    output wire        imem_valid,
    output wire [31:0] imem_addr,
    output wire        imem_cancel,
    input  wire        imem_ready,
    input  wire [31:0] imem_rdata,
    input  wire        imem_err,
    output wire        dmem_valid,
    output wire        dmem_we,
    output wire [3:0]  dmem_be,
    output wire [31:0] dmem_addr,
    output wire [31:0] dmem_wdata,
    input  wire        dmem_ready,
    input  wire [31:0] dmem_rdata,
    input  wire        dmem_err,
    output wire        debug_halted,
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instr
);
    wire stall_pc;
    wire stall_if_id;
    wire stall_id_ex;
    wire stall_ex_mem;
    wire stall_mem_wb;
    wire flush_if_id;
    wire flush_id_ex;
    wire flush_ex_mem;
    wire flush_mem_wb;

    wire if_valid;
    wire [31:0] if_pc;
    wire [31:0] if_pc_plus4;
    wire [31:0] if_instr;
    wire if_fault;
    wire if_fault_raw;
    wire [31:0] if_fault_cause;
    wire [31:0] if_fault_cause_raw;
    wire [31:0] if_fault_tval;
    wire [31:0] if_fault_tval_raw;

    wire id_valid;
    wire [31:0] id_pc;
    wire [31:0] id_pc_plus4;
    wire [31:0] id_instr;
    wire id_fault_in;
    wire [31:0] id_fault_cause_in;
    wire [31:0] id_fault_tval_in;
    wire id_fault;
    wire [31:0] id_fault_cause;
    wire [31:0] id_fault_tval;
    wire id_illegal_instr;
    wire id_ecall;
    wire id_ebreak;
    wire id_mret;
    wire [4:0] id_rs1;
    wire [4:0] id_rs2;
    wire [4:0] id_rd;
    wire [31:0] id_rs1_data;
    wire [31:0] id_rs2_data;
    wire [31:0] id_imm;
    wire id_reg_write;
    wire id_mem_read;
    wire id_mem_write;
    wire [1:0] id_wb_sel;
    wire [4:0] id_alu_op;
    wire [1:0] id_alu_src_a_sel;
    wire [1:0] id_alu_src_b_sel;
    wire [2:0] id_branch_type;
    wire id_jump;
    wire id_jalr;
    wire [1:0] id_mem_size;
    wire id_mem_unsigned;
    wire id_csr_en;
    wire [1:0] id_csr_op;
    wire id_csr_use_imm;

    wire ex_valid;
    wire [31:0] ex_pc;
    wire [31:0] ex_pc_plus4;
    wire [31:0] ex_instr;
    wire ex_fault;
    wire [31:0] ex_fault_cause_in;
    wire [31:0] ex_fault_tval_in;
    wire [4:0] ex_rs1;
    wire [4:0] ex_rs2;
    wire [4:0] ex_rd;
    wire [31:0] ex_rs1_data;
    wire [31:0] ex_rs2_data;
    wire [31:0] ex_imm;
    wire ex_reg_write;
    wire ex_mem_read;
    wire ex_mem_write;
    wire [1:0] ex_wb_sel;
    wire [4:0] ex_alu_op;
    wire [1:0] ex_alu_src_a_sel;
    wire [1:0] ex_alu_src_b_sel;
    wire [2:0] ex_branch_type;
    wire ex_jump;
    wire ex_jalr;
    wire [1:0] ex_mem_size;
    wire ex_mem_unsigned;
    wire ex_csr_en;
    wire [1:0] ex_csr_op;
    wire ex_csr_use_imm;
    wire ex_mret;
    wire [1:0] forward_a_sel;
    wire [1:0] forward_b_sel;
    wire pc_redirect_valid;
    wire [31:0] pc_redirect_target;
    wire ex_redirect_valid;
    wire [31:0] ex_redirect_target;
    wire ex_fault_out;
    wire [31:0] ex_fault_cause;
    wire [31:0] ex_fault_tval;
    wire [31:0] ex_alu_result;
    wire [31:0] ex_store_data;
    wire [31:0] ex_csr_rdata;
    wire [31:0] ex_csr_wdata;
    wire [11:0] ex_csr_addr;
    wire ex_csr_we;
    wire [31:0] csr_rdata;
    wire [31:0] csr_rdata_forwarded;
    wire [31:0] mepc_value_forwarded;
    wire [31:0] mtvec_value_forwarded;
    wire [31:0] mtvec_value;
    wire [31:0] mepc_value;
    wire csr_valid;
    wire csr_read_only;

    wire mem_valid;
    wire [31:0] mem_pc;
    wire [31:0] mem_pc_plus4;
    wire [31:0] mem_instr;
    wire mem_fault_reg;
    wire [31:0] mem_fault_cause_reg;
    wire [31:0] mem_fault_tval_reg;
    wire [4:0] mem_rd;
    wire [31:0] mem_alu_result;
    wire [31:0] mem_store_data;
    wire [31:0] mem_csr_rdata;
    wire [31:0] mem_csr_wdata;
    wire [11:0] mem_csr_addr;
    wire mem_csr_we;
    wire mem_mret;
    wire mem_reg_write;
    wire mem_mem_read;
    wire mem_mem_write;
    wire [1:0] mem_wb_sel;
    wire [1:0] mem_mem_size;
    wire mem_mem_unsigned;
    wire mem_wait;
    wire mem_fault;
    wire [31:0] mem_fault_cause;
    wire [31:0] mem_fault_tval;
    wire [31:0] mem_load_data;
    wire [31:0] forward_mem_data;

    wire wb_valid;
    wire [31:0] wb_pc;
    wire [31:0] wb_pc_plus4;
    wire [31:0] wb_instr;
    wire wb_fault;
    wire [31:0] wb_fault_cause;
    wire [31:0] wb_fault_tval;
    wire [4:0] wb_rd;
    wire [31:0] wb_alu_result;
    wire [31:0] wb_load_data;
    wire [31:0] wb_csr_rdata;
    wire [31:0] wb_csr_wdata;
    wire [11:0] wb_csr_addr;
    wire wb_csr_we;
    wire wb_mret;
    wire wb_reg_write;
    wire [1:0] wb_wb_sel;
    wire rf_we;
    wire [4:0] rf_waddr;
    wire [31:0] wb_data;

    wire trap_valid;
    wire [31:0] trap_pc;
    wire [31:0] trap_cause;
    wire [31:0] trap_tval;
    wire [31:0] trap_target;
    wire [2:0] trap_stage;
    reg  wb_committed_q;
    wire commit_fire;
    wire retire_fire;
    wire csr_write_fire;
    wire trap_fire;
    wire mret_fire;
    wire external_irq_enabled;
    wire external_irq_inject;

    localparam [31:0] MCAUSE_MACHINE_EXTERNAL_INTERRUPT = 32'h8000_000B;

    function [31:0] csr_effective_wdata;
        input [11:0] csr_addr;
        input [31:0] csr_wdata;
        begin
            case (csr_addr)
                12'h300: begin
                    csr_effective_wdata = 32'b0;
                    csr_effective_wdata[3] = csr_wdata[3];
                    csr_effective_wdata[7] = csr_wdata[7];
                    csr_effective_wdata[12:11] = 2'b11;
                end
                12'h304: begin
                    csr_effective_wdata = 32'b0;
                    csr_effective_wdata[11] = csr_wdata[11];
                end
                12'h301: csr_effective_wdata = 32'h4000_0100;
                12'h305: csr_effective_wdata =
                    (csr_wdata[1:0] == 2'b01) ? {csr_wdata[31:2], 2'b01} :
                                                 {csr_wdata[31:2], 2'b00};
                12'h341: csr_effective_wdata = {csr_wdata[31:2], 2'b00};
                12'h344: csr_effective_wdata = 32'b0;
                default: csr_effective_wdata = csr_wdata;
            endcase
        end
    endfunction

    function [11:0] csr_forward_key;
        input [11:0] csr_addr;
        begin
            case (csr_addr)
                12'hB00, 12'hC00, 12'hC01: csr_forward_key = 12'hB00;
                12'hB80, 12'hC80, 12'hC81: csr_forward_key = 12'hB80;
                12'hB02, 12'hC02:          csr_forward_key = 12'hB02;
                12'hB82, 12'hC82:          csr_forward_key = 12'hB82;
                default:                   csr_forward_key = csr_addr;
            endcase
        end
    endfunction

    wire [31:0] mem_csr_effective_wdata;
    wire [31:0] wb_csr_effective_wdata;

    assign mem_csr_effective_wdata = csr_effective_wdata(mem_csr_addr, mem_csr_wdata);
    assign wb_csr_effective_wdata = csr_effective_wdata(wb_csr_addr, wb_csr_wdata);
    assign commit_fire = wb_valid && !wb_committed_q;
    assign retire_fire = commit_fire && !wb_fault;
    assign csr_write_fire = retire_fire && wb_csr_we;
    assign trap_fire = commit_fire && wb_fault;
    assign mret_fire = retire_fire && wb_mret;

    // Inject an enabled level-high external IRQ as a fault-like token at IF.
    // Older instructions retire normally; the interrupted instruction and all
    // younger work are flushed before they can cause architectural side effects.
    assign external_irq_inject =
        if_valid && irq_external && external_irq_enabled &&
        !if_fault_raw &&
        !(id_valid && id_fault) &&
        !(ex_valid && ex_fault_out) &&
        !(mem_valid && mem_fault) &&
        !(wb_valid && wb_fault);
    assign if_fault = if_fault_raw || external_irq_inject;
    assign if_fault_cause = external_irq_inject ?
                            MCAUSE_MACHINE_EXTERNAL_INTERRUPT :
                            if_fault_cause_raw;
    assign if_fault_tval = external_irq_inject ? 32'b0 : if_fault_tval_raw;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wb_committed_q <= 1'b0;
        else if (flush_mem_wb || !stall_mem_wb)
            wb_committed_q <= 1'b0;
        else if (commit_fire)
            wb_committed_q <= 1'b1;
    end

    if_stage #(.RESET_PC(RESET_PC)) u_if (
        .clk(clk), .rst_n(rst_n), .stall_pc(stall_pc),
        .pc_redirect_valid(pc_redirect_valid), .pc_redirect_target(pc_redirect_target),
        .imem_valid(imem_valid), .imem_addr(imem_addr),
        .imem_ready(imem_ready), .imem_rdata(imem_rdata), .imem_err(imem_err),
        .if_valid(if_valid), .if_pc(if_pc), .if_pc_plus4(if_pc_plus4),
        .if_instr(if_instr), .if_fault(if_fault_raw),
        .if_fault_cause(if_fault_cause_raw), .if_fault_tval(if_fault_tval_raw)
    );

    if_id_reg u_if_id (
        .clk(clk), .rst_n(rst_n), .stall(stall_if_id), .flush(flush_if_id),
        .if_valid(if_valid), .if_pc(if_pc), .if_pc_plus4(if_pc_plus4),
        .if_instr(if_instr), .if_fault(if_fault),
        .if_fault_cause(if_fault_cause), .if_fault_tval(if_fault_tval),
        .id_valid(id_valid), .id_pc(id_pc), .id_pc_plus4(id_pc_plus4),
        .id_instr(id_instr), .id_fault(id_fault_in),
        .id_fault_cause(id_fault_cause_in), .id_fault_tval(id_fault_tval_in)
    );

    id_stage #(.XLEN(XLEN)) u_id (
        .clk(clk), .rst_n(rst_n), .id_valid(id_valid), .id_pc(id_pc),
        .id_instr(id_instr), .id_fault_in(id_fault_in),
        .id_fault_cause_in(id_fault_cause_in), .id_fault_tval_in(id_fault_tval_in),
        .wb_reg_write(rf_we), .wb_rd(rf_waddr), .wb_data(wb_data),
        .id_fault_out(id_fault), .id_illegal_instr(id_illegal_instr),
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

    id_ex_reg u_id_ex (
        .clk(clk), .rst_n(rst_n), .stall(stall_id_ex), .flush(flush_id_ex),
        .id_valid(id_valid), .id_pc(id_pc), .id_pc_plus4(id_pc_plus4),
        .id_instr(id_instr), .id_fault(id_fault),
        .id_fault_cause(id_fault_cause), .id_fault_tval(id_fault_tval),
        .id_rs1(id_rs1), .id_rs2(id_rs2),
        .id_rd(id_rd), .id_rs1_data(id_rs1_data), .id_rs2_data(id_rs2_data),
        .id_imm(id_imm), .id_reg_write(id_reg_write), .id_mem_read(id_mem_read),
        .id_mem_write(id_mem_write), .id_wb_sel(id_wb_sel), .id_alu_op(id_alu_op),
        .id_alu_src_a_sel(id_alu_src_a_sel), .id_alu_src_b_sel(id_alu_src_b_sel),
        .id_branch_type(id_branch_type), .id_jump(id_jump), .id_jalr(id_jalr),
        .id_mem_size(id_mem_size), .id_mem_unsigned(id_mem_unsigned),
        .id_csr_en(id_csr_en), .id_csr_op(id_csr_op), .id_csr_use_imm(id_csr_use_imm),
        .id_mret(id_mret),
        .ex_valid(ex_valid), .ex_pc(ex_pc), .ex_pc_plus4(ex_pc_plus4),
        .ex_instr(ex_instr), .ex_fault(ex_fault),
        .ex_fault_cause(ex_fault_cause_in), .ex_fault_tval(ex_fault_tval_in),
        .ex_rs1(ex_rs1), .ex_rs2(ex_rs2),
        .ex_rd(ex_rd), .ex_rs1_data(ex_rs1_data), .ex_rs2_data(ex_rs2_data),
        .ex_imm(ex_imm), .ex_reg_write(ex_reg_write), .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write), .ex_wb_sel(ex_wb_sel), .ex_alu_op(ex_alu_op),
        .ex_alu_src_a_sel(ex_alu_src_a_sel), .ex_alu_src_b_sel(ex_alu_src_b_sel),
        .ex_branch_type(ex_branch_type), .ex_jump(ex_jump), .ex_jalr(ex_jalr),
        .ex_mem_size(ex_mem_size), .ex_mem_unsigned(ex_mem_unsigned),
        .ex_csr_en(ex_csr_en), .ex_csr_op(ex_csr_op), .ex_csr_use_imm(ex_csr_use_imm),
        .ex_mret(ex_mret)
    );

    forwarding_unit u_forward (
        .ex_rs1(ex_rs1), .ex_rs2(ex_rs2),
        .mem_reg_write(mem_reg_write && !mem_mem_read), .mem_rd(mem_rd),
        .wb_reg_write(wb_valid && !wb_fault && wb_reg_write), .wb_rd(wb_rd),
        .forward_a_sel(forward_a_sel), .forward_b_sel(forward_b_sel)
    );

    assign forward_mem_data = (mem_wb_sel == 2'd2) ? mem_pc_plus4 :
                              (mem_wb_sel == 2'd3) ? mem_csr_rdata : mem_alu_result;

    assign csr_rdata_forwarded =
        (mem_valid && !mem_fault_reg && mem_csr_we &&
         csr_forward_key(mem_csr_addr) == csr_forward_key(ex_instr[31:20])) ? mem_csr_effective_wdata :
        (wb_valid && !wb_fault && wb_csr_we &&
         csr_forward_key(wb_csr_addr) == csr_forward_key(ex_instr[31:20])) ? wb_csr_effective_wdata :
        csr_rdata;

    assign mepc_value_forwarded =
        (mem_valid && !mem_fault_reg && mem_csr_we && mem_csr_addr == 12'h341) ? mem_csr_effective_wdata :
        (wb_valid && !wb_fault && wb_csr_we && wb_csr_addr == 12'h341) ? wb_csr_effective_wdata :
        mepc_value;

    assign mtvec_value_forwarded =
        (ex_valid && !ex_fault_out && ex_csr_we && ex_csr_addr == 12'h305) ? csr_effective_wdata(ex_csr_addr, ex_csr_wdata) :
        (mem_valid && !mem_fault_reg && mem_csr_we && mem_csr_addr == 12'h305) ? mem_csr_effective_wdata :
        (wb_valid && !wb_fault && wb_csr_we && wb_csr_addr == 12'h305) ? wb_csr_effective_wdata :
        mtvec_value;

    ex_stage #(
        .XLEN(XLEN), .ADDER_IMPL(ADDER_IMPL),
        .SHIFTER_IMPL(SHIFTER_IMPL)
    ) u_ex (
        .ex_valid(ex_valid), .ex_pc(ex_pc), .ex_pc_plus4(ex_pc_plus4),
        .ex_instr(ex_instr), .ex_fault_in(ex_fault),
        .ex_fault_cause_in(ex_fault_cause_in), .ex_fault_tval_in(ex_fault_tval_in),
        .ex_rs1(ex_rs1), .ex_rs1_data(ex_rs1_data), .ex_rs2_data(ex_rs2_data),
        .ex_imm(ex_imm), .ex_alu_op(ex_alu_op),
        .ex_alu_src_a_sel(ex_alu_src_a_sel), .ex_alu_src_b_sel(ex_alu_src_b_sel),
        .ex_branch_type(ex_branch_type), .ex_jump(ex_jump), .ex_jalr(ex_jalr),
        .ex_csr_en(ex_csr_en), .ex_csr_op(ex_csr_op), .ex_csr_use_imm(ex_csr_use_imm),
        .ex_mret(ex_mret),
        .forward_a_sel(forward_a_sel), .forward_b_sel(forward_b_sel),
        .forward_mem_data(forward_mem_data), .forward_wb_data(wb_data),
        .csr_rdata(csr_rdata_forwarded), .mepc_value(mepc_value_forwarded),
        .csr_valid(csr_valid), .csr_read_only(csr_read_only),
        .pc_redirect_valid(ex_redirect_valid), .pc_redirect_target(ex_redirect_target),
        .ex_fault_out(ex_fault_out), .ex_fault_cause(ex_fault_cause),
        .ex_fault_tval(ex_fault_tval), .ex_alu_result(ex_alu_result),
        .ex_store_data(ex_store_data),
        .ex_csr_rdata(ex_csr_rdata), .ex_csr_wdata(ex_csr_wdata),
        .ex_csr_addr(ex_csr_addr), .ex_csr_we(ex_csr_we)
    );

    ex_mem_reg u_ex_mem (
        .clk(clk), .rst_n(rst_n), .stall(stall_ex_mem), .flush(flush_ex_mem),
        .ex_valid(ex_valid), .ex_pc(ex_pc), .ex_pc_plus4(ex_pc_plus4),
        .ex_instr(ex_instr), .ex_fault(ex_fault_out),
        .ex_fault_cause(ex_fault_cause), .ex_fault_tval(ex_fault_tval),
        .ex_rd(ex_rd),
        .ex_alu_result(ex_alu_result), .ex_store_data(ex_store_data),
        .ex_csr_rdata(ex_csr_rdata), .ex_csr_wdata(ex_csr_wdata),
        .ex_csr_addr(ex_csr_addr), .ex_csr_we(ex_csr_we),
        .ex_mret(ex_mret),
        .ex_reg_write(ex_reg_write), .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write), .ex_wb_sel(ex_wb_sel),
        .ex_mem_size(ex_mem_size), .ex_mem_unsigned(ex_mem_unsigned),
        .mem_valid(mem_valid), .mem_pc(mem_pc), .mem_pc_plus4(mem_pc_plus4),
        .mem_instr(mem_instr), .mem_fault(mem_fault_reg),
        .mem_fault_cause(mem_fault_cause_reg), .mem_fault_tval(mem_fault_tval_reg),
        .mem_rd(mem_rd),
        .mem_alu_result(mem_alu_result), .mem_store_data(mem_store_data),
        .mem_csr_rdata(mem_csr_rdata), .mem_csr_wdata(mem_csr_wdata),
        .mem_csr_addr(mem_csr_addr), .mem_csr_we(mem_csr_we),
        .mem_mret(mem_mret),
        .mem_reg_write(mem_reg_write), .mem_mem_read(mem_mem_read),
        .mem_mem_write(mem_mem_write), .mem_wb_sel(mem_wb_sel),
        .mem_mem_size(mem_mem_size), .mem_mem_unsigned(mem_mem_unsigned)
    );

    mem_stage u_mem (
        .mem_valid(mem_valid), .mem_fault_in(mem_fault_reg),
        .mem_fault_cause_in(mem_fault_cause_reg), .mem_fault_tval_in(mem_fault_tval_reg),
        .mem_alu_result(mem_alu_result), .mem_store_data(mem_store_data),
        .mem_mem_read(mem_mem_read), .mem_mem_write(mem_mem_write),
        .mem_mem_size(mem_mem_size), .mem_mem_unsigned(mem_mem_unsigned),
        .dmem_valid(dmem_valid), .dmem_we(dmem_we), .dmem_be(dmem_be),
        .dmem_addr(dmem_addr), .dmem_wdata(dmem_wdata),
        .dmem_ready(dmem_ready), .dmem_rdata(dmem_rdata), .dmem_err(dmem_err),
        .mem_wait(mem_wait), .mem_fault_out(mem_fault),
        .mem_fault_cause(mem_fault_cause), .mem_fault_tval(mem_fault_tval),
        .mem_load_data(mem_load_data)
    );

    mem_wb_reg u_mem_wb (
        .clk(clk), .rst_n(rst_n), .stall(stall_mem_wb), .flush(flush_mem_wb),
        .mem_valid(mem_valid && !mem_wait), .mem_pc(mem_pc), .mem_pc_plus4(mem_pc_plus4),
        .mem_instr(mem_instr), .mem_fault(mem_fault),
        .mem_fault_cause(mem_fault_cause), .mem_fault_tval(mem_fault_tval),
        .mem_rd(mem_rd),
        .mem_alu_result(mem_alu_result), .mem_load_data(mem_load_data),
        .mem_csr_rdata(mem_csr_rdata), .mem_csr_wdata(mem_csr_wdata),
        .mem_csr_addr(mem_csr_addr), .mem_csr_we(mem_csr_we),
        .mem_mret(mem_mret),
        .mem_reg_write(mem_reg_write), .mem_wb_sel(mem_wb_sel),
        .wb_valid(wb_valid), .wb_pc(wb_pc), .wb_pc_plus4(wb_pc_plus4),
        .wb_instr(wb_instr), .wb_fault(wb_fault),
        .wb_fault_cause(wb_fault_cause), .wb_fault_tval(wb_fault_tval),
        .wb_rd(wb_rd),
        .wb_alu_result(wb_alu_result), .wb_load_data(wb_load_data),
        .wb_csr_rdata(wb_csr_rdata), .wb_csr_wdata(wb_csr_wdata),
        .wb_csr_addr(wb_csr_addr), .wb_csr_we(wb_csr_we),
        .wb_mret(wb_mret),
        .wb_reg_write(wb_reg_write), .wb_wb_sel(wb_wb_sel)
    );

    wb_stage u_wb (
        .wb_valid(retire_fire), .wb_fault(wb_fault), .wb_rd(wb_rd),
        .wb_reg_write_in(wb_reg_write), .wb_wb_sel(wb_wb_sel),
        .wb_alu_result(wb_alu_result), .wb_load_data(wb_load_data),
        .wb_pc_plus4(wb_pc_plus4), .wb_csr_rdata(wb_csr_rdata),
        .rf_we(rf_we), .rf_waddr(rf_waddr),
        .wb_data(wb_data)
    );

    csr_file #(.XLEN(XLEN)) u_csr_file (
        .clk(clk),
        .rst_n(rst_n),
        .external_irq(irq_external),
        .retire(retire_fire),
        .read_addr(ex_instr[31:20]),
        .read_data(csr_rdata),
        .read_valid(csr_valid),
        .read_only(csr_read_only),
        .write_en(csr_write_fire),
        .write_addr(wb_csr_addr),
        .write_data(wb_csr_wdata),
        .trap_en(trap_fire),
        .trap_mepc(wb_pc),
        .trap_mcause(wb_fault_cause),
        .trap_mtval(wb_fault_tval),
        .mret_en(mret_fire),
        .mtvec_value(mtvec_value),
        .mepc_value(mepc_value),
        .external_irq_enabled(external_irq_enabled)
    );

    trap_unit u_trap (
        .if_valid(if_valid && !ex_redirect_valid), .if_fault(if_fault), .if_pc(if_pc),
        .if_fault_cause(if_fault_cause), .if_fault_tval(if_fault_tval),
        .id_valid(id_valid && !ex_redirect_valid), .id_fault(id_fault), .id_pc(id_pc),
        .id_fault_cause(id_fault_cause), .id_fault_tval(id_fault_tval),
        .ex_valid(ex_valid), .ex_fault(ex_fault_out), .ex_pc(ex_pc),
        .ex_fault_cause(ex_fault_cause), .ex_fault_tval(ex_fault_tval),
        .mem_valid(mem_valid), .mem_fault(mem_fault), .mem_pc(mem_pc),
        .mem_fault_cause(mem_fault_cause), .mem_fault_tval(mem_fault_tval),
        .wb_valid(wb_valid), .wb_fault(wb_fault), .wb_pc(wb_pc),
        .wb_fault_cause(wb_fault_cause), .wb_fault_tval(wb_fault_tval),
        .mtvec_value(mtvec_value_forwarded),
        .trap_valid(trap_valid), .trap_pc(trap_pc),
        .trap_cause(trap_cause), .trap_tval(trap_tval),
        .trap_target(trap_target)
    );

    assign pc_redirect_valid = trap_fire || (ex_redirect_valid && !trap_valid);
    assign pc_redirect_target = trap_fire ? trap_target : ex_redirect_target;
    // Break the combinatorial loop trap_valid -> pc_redirect_valid ->
    // imem_cancel -> imem_ready -> if_valid -> trap_valid. Both terms are
    // registered; trap-vs-branch priority is still set above via !trap_valid.
    assign imem_cancel = trap_fire || ex_redirect_valid;
    assign trap_stage = (wb_valid && wb_fault)       ? 3'd5 :
                        (mem_valid && mem_fault)     ? 3'd4 :
                        (ex_valid && ex_fault_out)   ? 3'd3 :
                        (id_valid && id_fault)       ? 3'd2 :
                        (if_valid && if_fault)       ? 3'd1 :
                                                       3'd0;

    hazard_unit u_hazard (
        .id_valid(id_valid), .id_instr(id_instr), .id_rs1(id_rs1), .id_rs2(id_rs2),
        .ex_valid(ex_valid), .ex_mem_read(ex_mem_read), .ex_rd(ex_rd),
        .mem_wait(mem_wait), .pc_redirect_valid(pc_redirect_valid),
        .trap_valid(trap_valid), .trap_stage(trap_stage),
        .stall_pc(stall_pc), .stall_if_id(stall_if_id), .stall_id_ex(stall_id_ex),
        .stall_ex_mem(stall_ex_mem), .stall_mem_wb(stall_mem_wb),
        .flush_if_id(flush_if_id), .flush_id_ex(flush_id_ex),
        .flush_ex_mem(flush_ex_mem), .flush_mem_wb(flush_mem_wb)
    );

    assign debug_halted = 1'b0;
    assign debug_pc = trap_valid ? trap_pc : if_pc;
    assign debug_instr = trap_valid ? 32'h0000_0013 : if_instr;
endmodule
