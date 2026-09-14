`timescale 1ns/1ps

module memory_ext_tb;
    reg clk;
    reg rst_n;

    reg         d_valid;
    reg         d_we;
    reg  [3:0]  d_be;
    reg  [31:0] d_addr;
    reg  [31:0] d_wdata;
    wire        d_ready;
    wire [31:0] d_rdata;
    wire        d_err;

    reg         i_valid;
    reg  [31:0] i_addr;
    wire        i_ready;
    wire [31:0] i_rdata;
    wire        i_err;

    integer errors;
    reg [31:0] observed_rdata;
    reg        observed_err;

    data_bram #(.ADDR_WIDTH(8), .BASE_ADDR(32'h0001_0000)) u_dmem (
        .clk(clk), .rst_n(rst_n), .valid(d_valid), .we(d_we),
        .be(d_be), .addr(d_addr), .wdata(d_wdata),
        .ready(d_ready), .rdata(d_rdata), .err(d_err)
    );

    instr_bram #(.ADDR_WIDTH(8)) u_imem (
        .clk(clk), .rst_n(rst_n), .valid(i_valid), .addr(i_addr),
        .ready(i_ready), .rdata(i_rdata), .err(i_err)
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

    task dmem_access;
        input        we_i;
        input [3:0]  be_i;
        input [31:0] addr_i;
        input [31:0] wdata_i;
        begin
            @(negedge clk);
            d_valid = 1'b1;
            d_we = we_i;
            d_be = be_i;
            d_addr = addr_i;
            d_wdata = wdata_i;
            @(posedge clk);
            #1;
            observed_rdata = d_rdata;
            observed_err = d_err;
            @(negedge clk);
            d_valid = 1'b0;
            d_we = 1'b0;
            d_be = 4'b0;
        end
    endtask

    task imem_access;
        input [31:0] addr_i;
        begin
            @(negedge clk);
            i_valid = 1'b1;
            i_addr = addr_i;
            @(posedge clk);
            #1;
            observed_rdata = i_rdata;
            observed_err = i_err;
            @(negedge clk);
            i_valid = 1'b0;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        d_valid = 1'b0;
        d_we = 1'b0;
        d_be = 4'b0;
        d_addr = 32'b0;
        d_wdata = 32'b0;
        i_valid = 1'b0;
        i_addr = 32'b0;
        observed_rdata = 32'b0;
        observed_err = 1'b0;
        errors = 0;

        u_imem.mem[0] = 32'h1234_5678;
        u_imem.mem[1] = 32'h89AB_CDEF;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        dmem_access(1'b1, 4'b1111, 32'h0001_0000, 32'h1122_3344);
        dmem_access(1'b0, 4'b0000, 32'h0001_0000, 32'b0);
        check(observed_rdata == 32'h1122_3344 && !observed_err, "data_bram word write/read");

        dmem_access(1'b1, 4'b0010, 32'h0001_0000, 32'h0000_AA00);
        dmem_access(1'b0, 4'b0000, 32'h0001_0000, 32'b0);
        check(observed_rdata == 32'h1122_AA44, "data_bram byte enable lane 1");

        dmem_access(1'b0, 4'b0000, 32'h0002_0000, 32'b0);
        check(observed_err, "data_bram out-of-range error");

        imem_access(32'h0000_0000);
        check(observed_rdata == 32'h1234_5678 && !observed_err, "instr_bram read word 0");
        imem_access(32'h0000_0004);
        check(observed_rdata == 32'h89AB_CDEF && !observed_err, "instr_bram read word 1");
        imem_access(32'h0001_0000);
        check(observed_err, "instr_bram out-of-range error");

        if (errors == 0) begin
            $display("PASS: memory_ext_tb");
            $finish;
        end

        $display("FAIL: memory_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
