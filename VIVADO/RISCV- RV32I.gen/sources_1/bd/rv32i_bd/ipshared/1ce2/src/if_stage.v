`timescale 1ns/1ps

module if_stage #(
    parameter RESET_PC = 32'h0000_0000
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall_pc,
    input  wire        pc_redirect_valid,
    input  wire [31:0] pc_redirect_target,
    output wire        imem_valid,
    output wire [31:0] imem_addr,
    input  wire        imem_ready,
    input  wire [31:0] imem_rdata,
    input  wire        imem_err,
    output wire        if_valid,
    output wire [31:0] if_pc,
    output wire [31:0] if_pc_plus4,
    output wire [31:0] if_instr,
    output wire        if_fault,
    output wire [31:0] if_fault_cause,
    output wire [31:0] if_fault_tval
);
    wire [31:0] pc_current;
    wire [31:0] pc_plus4;
    reg  [31:0] pc_req_q;
    reg  [31:0] pc_plus4_req_q;
    reg         imem_valid_q;
    reg         pc_misaligned_q;
    reg         hold_valid_q;
    reg  [31:0] hold_pc_q;
    reg  [31:0] hold_pc_plus4_q;
    reg  [31:0] hold_instr_q;
    reg         hold_fault_q;
    reg  [31:0] hold_fault_cause_q;
    reg  [31:0] hold_fault_tval_q;
    reg         kill_fetch_q;
    wire        current_valid;
    wire        current_fault;
    wire        fetch_wait;
    wire        pc_stall;

    pc_unit #(.RESET_PC(RESET_PC)) u_pc (
        .clk(clk),
        .rst_n(rst_n),
        .stall(pc_stall),
        .pc_redirect_valid(pc_redirect_valid),
        .pc_redirect_target(pc_redirect_target),
        .pc_current(pc_current),
        .pc_plus4(pc_plus4)
    );

    assign imem_valid = 1'b1;
    assign imem_addr = fetch_wait ? pc_req_q : pc_current;
    assign current_valid = imem_ready && imem_valid_q && !kill_fetch_q;
    assign current_fault = (current_valid && imem_err) | pc_misaligned_q;
    assign fetch_wait = imem_valid_q && !imem_ready && !kill_fetch_q && !hold_valid_q;
    assign pc_stall = stall_pc || fetch_wait;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_req_q <= RESET_PC;
            pc_plus4_req_q <= RESET_PC + 32'd4;
            imem_valid_q <= 1'b0;
            pc_misaligned_q <= 1'b0;
        end else if ((!stall_pc && !fetch_wait) || pc_redirect_valid) begin
            pc_req_q <= pc_current;
            pc_plus4_req_q <= pc_plus4;
            imem_valid_q <= imem_valid;
            pc_misaligned_q <= |pc_current[1:0];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            kill_fetch_q <= 1'b0;
        else if (pc_redirect_valid)
            kill_fetch_q <= 1'b1;
        else if (kill_fetch_q && ((imem_ready && imem_valid_q) || !imem_ready))
            kill_fetch_q <= 1'b0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hold_valid_q <= 1'b0;
            hold_pc_q <= 32'b0;
            hold_pc_plus4_q <= 32'b0;
            hold_instr_q <= 32'h0000_0013;
            hold_fault_q <= 1'b0;
            hold_fault_cause_q <= 32'b0;
            hold_fault_tval_q <= 32'b0;
        end else if (pc_redirect_valid) begin
            hold_valid_q <= 1'b0;
        end else if (stall_pc && current_valid && !hold_valid_q) begin
            hold_valid_q <= 1'b1;
            hold_pc_q <= pc_req_q;
            hold_pc_plus4_q <= pc_plus4_req_q;
            hold_instr_q <= imem_rdata;
            hold_fault_q <= current_fault;
            hold_fault_cause_q <= pc_misaligned_q ? 32'd0 : 32'd1;
            hold_fault_tval_q <= pc_req_q;
        end else if (!stall_pc && hold_valid_q) begin
            hold_valid_q <= 1'b0;
        end
    end

    assign if_valid = hold_valid_q || current_valid;
    assign if_pc = hold_valid_q ? hold_pc_q : pc_req_q;
    assign if_pc_plus4 = hold_valid_q ? hold_pc_plus4_q : pc_plus4_req_q;
    assign if_instr = hold_valid_q ? hold_instr_q : (imem_ready ? imem_rdata : 32'h0000_0013);
    assign if_fault = hold_valid_q ? hold_fault_q : current_fault;
    assign if_fault_cause = hold_valid_q ? hold_fault_cause_q : (pc_misaligned_q ? 32'd0 : 32'd1);
    assign if_fault_tval = hold_valid_q ? hold_fault_tval_q : pc_req_q;
endmodule
