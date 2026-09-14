`timescale 1ns/1ps

module csr_file_tb;
    reg clk;
    reg rst_n;
    reg external_irq;
    reg retire;
    reg [11:0] read_addr;
    wire [31:0] read_data;
    wire read_valid;
    wire read_only;
    reg write_en;
    reg [11:0] write_addr;
    reg [31:0] write_data;
    reg trap_en;
    reg [31:0] trap_mepc;
    reg [31:0] trap_mcause;
    reg [31:0] trap_mtval;
    reg mret_en;
    wire [31:0] mtvec_value;
    wire [31:0] mepc_value;
    wire external_irq_enabled;
    integer errors;

    csr_file dut (
        .clk(clk),
        .rst_n(rst_n),
        .external_irq(external_irq),
        .retire(retire),
        .read_addr(read_addr),
        .read_data(read_data),
        .read_valid(read_valid),
        .read_only(read_only),
        .write_en(write_en),
        .write_addr(write_addr),
        .write_data(write_data),
        .trap_en(trap_en),
        .trap_mepc(trap_mepc),
        .trap_mcause(trap_mcause),
        .trap_mtval(trap_mtval),
        .mret_en(mret_en),
        .mtvec_value(mtvec_value),
        .mepc_value(mepc_value),
        .external_irq_enabled(external_irq_enabled)
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
        external_irq = 1'b0;
        retire = 1'b0;
        read_addr = 12'h000;
        write_en = 1'b0;
        write_addr = 12'h000;
        write_data = 32'b0;
        trap_en = 1'b0;
        trap_mepc = 32'b0;
        trap_mcause = 32'b0;
        trap_mtval = 32'b0;
        mret_en = 1'b0;
        errors = 0;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        read_addr = 12'h300;
        #1;
        check(read_valid && !read_only && read_data[12:11] == 2'b11 &&
              read_data[7] == 1'b0 && read_data[3] == 1'b0, "mstatus reset/read");

        read_addr = 12'h344;
        external_irq = 1'b1;
        #1;
        check(read_data[11] == 1'b1, "mip.MEIP follows external IRQ");
        external_irq = 1'b0;

        write_addr = 12'h300;
        write_data = 32'hA5A5_5A5A;
        write_en = 1'b1;
        @(posedge clk);
        #1;
        write_en = 1'b0;
        read_addr = 12'h300;
        #1;
        check(read_data[12:11] == 2'b11 && read_data[7] == write_data[7] &&
              read_data[3] == write_data[3], "mstatus write/read sanitized");

        write_addr = 12'h304;
        write_data = 32'hFFFF_FFFF;
        write_en = 1'b1;
        @(posedge clk);
        #1;
        write_en = 1'b0;
        read_addr = 12'h304;
        #1;
        check(read_data == 32'h0000_0800, "mie implements only MEIE");
        check(external_irq_enabled == 1'b1, "global MIE and MEIE enable external IRQ");

        write_addr = 12'h300;
        write_data = 32'h0000_0000;
        write_en = 1'b1;
        @(posedge clk);
        #1;
        write_en = 1'b0;
        read_addr = 12'h300;
        #1;
        check(read_data[12:11] == 2'b11, "mstatus MPP is M-mode-only WARL");

        read_addr = 12'h301;
        #1;
        check(read_valid && !read_only && read_data == 32'h4000_0100, "misa reports RV32I");

        write_addr = 12'h301;
        write_data = 32'hFFFF_FFFF;
        write_en = 1'b1;
        @(posedge clk);
        #1;
        write_en = 1'b0;
        #1;
        check(read_data == 32'h4000_0100, "misa writes are ignored");

        read_addr = 12'hC00;
        #1;
        check(read_valid && read_only, "cycle CSR is read-only");

        read_addr = 12'hB00;
        #1;
        check(read_valid && !read_only, "mcycle CSR is machine read/write");

        write_addr = 12'h305;
        write_data = 32'h0000_0083;
        write_en = 1'b1;
        @(posedge clk);
        #1;
        write_en = 1'b0;
        #1;
        check(mtvec_value == 32'h0000_0080, "mtvec illegal mode sanitizes to direct");

        write_addr = 12'h305;
        write_data = 32'h0000_0081;
        write_en = 1'b1;
        @(posedge clk);
        #1;
        write_en = 1'b0;
        #1;
        check(mtvec_value == 32'h0000_0081, "mtvec vectored mode accepted");

        trap_mepc = 32'h0000_0123;
        trap_mcause = 32'd11;
        trap_mtval = 32'h0000_0000;
        trap_en = 1'b1;
        @(posedge clk);
        #1;
        trap_en = 1'b0;
        read_addr = 12'h341;
        #1;
        check(read_data == 32'h0000_0120 && mepc_value == 32'h0000_0120, "trap writes aligned mepc");
        read_addr = 12'h342;
        #1;
        check(read_data == 32'd11, "trap writes mcause");
        read_addr = 12'h343;
        #1;
        check(read_data == 32'h0000_0000, "trap writes mtval");

        mret_en = 1'b1;
        @(posedge clk);
        #1;
        mret_en = 1'b0;

        read_addr = 12'hFFF;
        #1;
        check(!read_valid, "unsupported CSR is invalid");

        read_addr = 12'hF14;
        #1;
        check(read_valid && read_only && read_data == 32'h0000_0000, "mhartid read-only");

        if (errors == 0) begin
            $display("PASS: csr_file basic behavior");
            $finish;
        end

        $display("FAIL: %0d errors", errors);
        $finish;
    end
endmodule
