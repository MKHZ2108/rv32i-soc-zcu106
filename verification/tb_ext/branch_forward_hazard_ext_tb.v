`timescale 1ns/1ps

module branch_forward_hazard_ext_tb;
    reg  [31:0] rs1_value;
    reg  [31:0] rs2_value;
    reg  [2:0]  branch_type;
    wire        branch_taken;

    reg  [4:0] ex_rs1;
    reg  [4:0] ex_rs2;
    reg        mem_reg_write;
    reg  [4:0] mem_rd;
    reg        wb_reg_write;
    reg  [4:0] wb_rd;
    wire [1:0] forward_a_sel;
    wire [1:0] forward_b_sel;

    reg        id_valid;
    reg  [31:0] id_instr;
    reg  [4:0] id_rs1;
    reg  [4:0] id_rs2;
    reg        ex_valid;
    reg        ex_mem_read;
    reg  [4:0] ex_rd;
    reg        mem_wait;
    reg        pc_redirect_valid;
    reg        trap_valid;
    reg  [2:0] trap_stage;
    wire       stall_pc;
    wire       stall_if_id;
    wire       stall_id_ex;
    wire       stall_ex_mem;
    wire       stall_mem_wb;
    wire       flush_if_id;
    wire       flush_id_ex;
    wire       flush_ex_mem;
    wire       flush_mem_wb;

    integer errors;

    branch_unit u_branch (
        .rs1_value(rs1_value), .rs2_value(rs2_value),
        .branch_type(branch_type), .branch_taken(branch_taken)
    );

    forwarding_unit u_forwarding (
        .ex_rs1(ex_rs1), .ex_rs2(ex_rs2),
        .mem_reg_write(mem_reg_write), .mem_rd(mem_rd),
        .wb_reg_write(wb_reg_write), .wb_rd(wb_rd),
        .forward_a_sel(forward_a_sel), .forward_b_sel(forward_b_sel)
    );

    hazard_unit u_hazard (
        .id_valid(id_valid), .id_instr(id_instr), .id_rs1(id_rs1), .id_rs2(id_rs2),
        .ex_valid(ex_valid), .ex_mem_read(ex_mem_read), .ex_rd(ex_rd),
        .mem_wait(mem_wait), .pc_redirect_valid(pc_redirect_valid),
        .trap_valid(trap_valid), .trap_stage(trap_stage),
        .stall_pc(stall_pc), .stall_if_id(stall_if_id),
        .stall_id_ex(stall_id_ex), .stall_ex_mem(stall_ex_mem),
        .stall_mem_wb(stall_mem_wb), .flush_if_id(flush_if_id),
        .flush_id_ex(flush_id_ex), .flush_ex_mem(flush_ex_mem),
        .flush_mem_wb(flush_mem_wb)
    );

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

    task clear_hazard;
        begin
            id_valid = 1'b0;
            id_rs1 = 5'd0;
            id_rs2 = 5'd0;
            ex_valid = 1'b0;
            ex_mem_read = 1'b0;
            ex_rd = 5'd0;
            mem_wait = 1'b0;
            pc_redirect_valid = 1'b0;
            trap_valid = 1'b0;
            trap_stage = 3'd0;
        end
    endtask

    initial begin
        errors = 0;
        id_instr = 32'h0000_0033; // Default to instruction using both rs1 and rs2 (e.g. add x0, x0, x0)

        rs1_value = 32'h0000_0005;
        rs2_value = 32'h0000_0005;
        branch_type = 3'd1; #1; check(branch_taken, "BEQ taken");
        branch_type = 3'd2; #1; check(!branch_taken, "BNE not taken");

        rs1_value = 32'hFFFF_FFFE;
        rs2_value = 32'h0000_0001;
        branch_type = 3'd3; #1; check(branch_taken, "BLT signed taken");
        branch_type = 3'd5; #1; check(!branch_taken, "BLTU unsigned not taken");
        branch_type = 3'd4; #1; check(!branch_taken, "BGE signed not taken");
        branch_type = 3'd6; #1; check(branch_taken, "BGEU unsigned taken");
        branch_type = 3'd0; #1; check(!branch_taken, "BR_NONE not taken");

        ex_rs1 = 5'd4;
        ex_rs2 = 5'd5;
        mem_reg_write = 1'b1;
        mem_rd = 5'd4;
        wb_reg_write = 1'b1;
        wb_rd = 5'd4;
        #1;
        check(forward_a_sel == 2'd1, "MEM forwarding priority over WB");
        check(forward_b_sel == 2'd0, "no forward B");

        mem_rd = 5'd0;
        wb_rd = 5'd5;
        #1;
        check(forward_a_sel == 2'd0, "x0 MEM forward ignored");
        check(forward_b_sel == 2'd2, "WB forward B");

        mem_reg_write = 1'b0;
        wb_reg_write = 1'b0;
        #1;
        check(forward_a_sel == 2'd0 && forward_b_sel == 2'd0, "no forwarding default");

        clear_hazard();
        #1;
        check(!stall_pc && !flush_if_id && !flush_id_ex, "hazard idle");

        id_valid = 1'b1;
        id_rs1 = 5'd7;
        id_rs2 = 5'd8;
        ex_valid = 1'b1;
        ex_mem_read = 1'b1;
        ex_rd = 5'd7;
        #1;
        check(stall_pc && stall_if_id && flush_id_ex, "load-use stalls IF/ID and flushes ID/EX");
        check(!stall_id_ex && !stall_ex_mem && !stall_mem_wb, "load-use does not stall later stages");

        mem_wait = 1'b1;
        #1;
        check(stall_pc && stall_if_id && stall_id_ex && stall_ex_mem && stall_mem_wb,
              "mem_wait stalls all pipeline registers");

        mem_wait = 1'b0;
        pc_redirect_valid = 1'b1;
        #1;
        check(!stall_pc && flush_if_id && flush_id_ex, "redirect flushes younger stages");

        pc_redirect_valid = 1'b0;
        trap_valid = 1'b1;
        trap_stage = 3'd2;
        #1;
        check(flush_if_id && !flush_id_ex && !flush_ex_mem && !flush_mem_wb,
              "ID trap preserves faulting instruction and flushes IF");

        trap_stage = 3'd4;
        #1;
        check(flush_if_id && flush_id_ex && flush_ex_mem && !flush_mem_wb,
              "MEM trap preserves faulting instruction into WB");

        trap_stage = 3'd5;
        #1;
        check(flush_if_id && flush_id_ex && flush_ex_mem && flush_mem_wb,
              "WB trap flushes all younger stages and clears WB");

        if (errors == 0) begin
            $display("PASS: branch_forward_hazard_ext_tb");
            $finish;
        end

        $display("FAIL: branch_forward_hazard_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
