`timescale 1ns/1ps

module reg_pc_wb_ext_tb;
    reg clk;
    reg rst_n;

    reg  [4:0]  rs1_addr;
    reg  [4:0]  rs2_addr;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    reg         rd_we;
    reg  [4:0]  rd_addr;
    reg  [31:0] rd_data;

    reg         stall;
    reg         pc_redirect_valid;
    reg  [31:0] pc_redirect_target;
    wire [31:0] pc_current;
    wire [31:0] pc_plus4;

    reg         wb_valid;
    reg         wb_fault;
    reg  [4:0]  wb_rd;
    reg         wb_reg_write_in;
    reg  [1:0]  wb_wb_sel;
    reg  [31:0] wb_alu_result;
    reg  [31:0] wb_load_data;
    reg  [31:0] wb_pc_plus4;
    reg  [31:0] wb_csr_rdata;
    wire        rf_we;
    wire [4:0]  rf_waddr;
    wire [31:0] wb_data;

    integer errors;
    integer idx;

    reg_file u_reg_file (
        .clk(clk), .rst_n(rst_n),
        .rs1_addr(rs1_addr), .rs2_addr(rs2_addr),
        .rs1_data(rs1_data), .rs2_data(rs2_data),
        .rd_we(rd_we), .rd_addr(rd_addr), .rd_data(rd_data)
    );

    pc_unit #(.RESET_PC(32'h0000_0080)) u_pc (
        .clk(clk), .rst_n(rst_n), .stall(stall),
        .pc_redirect_valid(pc_redirect_valid),
        .pc_redirect_target(pc_redirect_target),
        .pc_current(pc_current), .pc_plus4(pc_plus4)
    );

    wb_stage u_wb (
        .wb_valid(wb_valid), .wb_fault(wb_fault), .wb_rd(wb_rd),
        .wb_reg_write_in(wb_reg_write_in), .wb_wb_sel(wb_wb_sel),
        .wb_alu_result(wb_alu_result), .wb_load_data(wb_load_data),
        .wb_pc_plus4(wb_pc_plus4), .wb_csr_rdata(wb_csr_rdata),
        .rf_we(rf_we), .rf_waddr(rf_waddr), .wb_data(wb_data)
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

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        for (idx = 0; idx < 32; idx = idx + 1) begin
            u_reg_file.regs[idx] = 32'b0;
        end
        rs1_addr = 5'd0;
        rs2_addr = 5'd0;
        rd_we = 1'b0;
        rd_addr = 5'd0;
        rd_data = 32'b0;
        stall = 1'b0;
        pc_redirect_valid = 1'b0;
        pc_redirect_target = 32'b0;
        wb_valid = 1'b0;
        wb_fault = 1'b0;
        wb_rd = 5'd0;
        wb_reg_write_in = 1'b0;
        wb_wb_sel = 2'd0;
        wb_alu_result = 32'hAAAA_0000;
        wb_load_data = 32'hBBBB_1111;
        wb_pc_plus4 = 32'hCCCC_2222;
        wb_csr_rdata = 32'hDDDD_3333;
        errors = 0;

        repeat (2) @(posedge clk);
        #1;
        check(rs1_data == 32'b0 && rs2_data == 32'b0, "reg_file reset/x0");
        check(pc_current == 32'h0000_0080 && pc_plus4 == 32'h0000_0084, "pc reset");

        rst_n = 1'b1;
        @(posedge clk);
        #1;
        check(pc_current == 32'h0000_0084, "pc increments");

        stall = 1'b1;
        @(posedge clk);
        #1;
        check(pc_current == 32'h0000_0084, "pc stall holds value");

        stall = 1'b0;
        pc_redirect_valid = 1'b1;
        pc_redirect_target = 32'h0000_0200;
        @(posedge clk);
        #1;
        check(pc_current == 32'h0000_0200, "pc redirect");
        pc_redirect_valid = 1'b0;

        rd_we = 1'b1;
        rd_addr = 5'd0;
        rd_data = 32'hFFFF_FFFF;
        rs1_addr = 5'd0;
        @(posedge clk);
        #1;
        check(rs1_data == 32'b0, "x0 write ignored");

        rd_addr = 5'd5;
        rd_data = 32'h1234_5678;
        rs1_addr = 5'd5;
        #1;
        check(rs1_data == 32'h1234_5678, "same-cycle bypass rs1");
        @(posedge clk);
        #1;
        rd_we = 1'b0;
        check(rs1_data == 32'h1234_5678, "registered writeback");

        wb_valid = 1'b1;
        wb_fault = 1'b0;
        wb_rd = 5'd10;
        wb_reg_write_in = 1'b1;

        wb_wb_sel = 2'd0; #1; check(wb_data == wb_alu_result, "wb ALU select");
        wb_wb_sel = 2'd1; #1; check(wb_data == wb_load_data, "wb MEM select");
        wb_wb_sel = 2'd2; #1; check(wb_data == wb_pc_plus4, "wb PC+4 select");
        wb_wb_sel = 2'd3; #1; check(wb_data == wb_csr_rdata, "wb CSR select");
        check(rf_we && rf_waddr == 5'd10, "wb rf write enable");

        wb_fault = 1'b1; #1; check(!rf_we, "wb fault disables write");
        wb_fault = 1'b0; wb_rd = 5'd0; #1; check(!rf_we, "wb x0 disables write");
        wb_rd = 5'd10; wb_valid = 1'b0; #1; check(!rf_we, "wb invalid disables write");

        if (errors == 0) begin
            $display("PASS: reg_pc_wb_ext_tb");
            $finish;
        end

        $display("FAIL: reg_pc_wb_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
