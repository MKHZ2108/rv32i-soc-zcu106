`timescale 1ns/1ps

module bus_interconnect_tb;
    reg clk;
    reg rst_n;
    reg m_valid;
    reg m_we;
    reg [3:0] m_be;
    reg [31:0] m_addr;
    reg [31:0] m_wdata;
    wire m_ready;
    wire [31:0] m_rdata;
    wire m_err;

    wire dmem_valid;
    wire dmem_we;
    wire [3:0] dmem_be;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    reg dmem_ready;
    reg [31:0] dmem_rdata;
    reg dmem_err;

    reg observed_err;
    reg [31:0] observed_rdata;
    integer errors;
    integer dmem_handshake_count;

    bus_interconnect dut (
        .clk(clk),
        .rst_n(rst_n),
        .m_valid(m_valid),
        .m_we(m_we),
        .m_be(m_be),
        .m_addr(m_addr),
        .m_wdata(m_wdata),
        .m_ready(m_ready),
        .m_rdata(m_rdata),
        .m_err(m_err),
        .dmem_valid(dmem_valid),
        .dmem_we(dmem_we),
        .dmem_be(dmem_be),
        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_ready(dmem_ready),
        .dmem_rdata(dmem_rdata),
        .dmem_err(dmem_err)
    );

    always #5 clk = ~clk;

    task wait_master_ready;
        begin
            while (m_ready !== 1'b1) begin
                @(posedge clk);
                #1;
            end
            observed_err = m_err;
            observed_rdata = m_rdata;
        end
    endtask

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dmem_ready <= 1'b0;
            dmem_rdata <= 32'b0;
            dmem_err <= 1'b0;
            dmem_handshake_count <= 0;
        end else begin
            dmem_ready <= dmem_valid;
            dmem_rdata <= 32'hCAFE_0123;
            dmem_err <= 1'b0;
            if (dmem_valid && dmem_ready)
                dmem_handshake_count <= dmem_handshake_count + 1;
        end
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        m_valid = 1'b0;
        m_we = 1'b0;
        m_be = 4'b0;
        m_addr = 32'b0;
        m_wdata = 32'b0;
        dmem_ready = 1'b0;
        dmem_rdata = 32'b0;
        dmem_err = 1'b0;
        observed_err = 1'b0;
        observed_rdata = 32'b0;
        errors = 0;

        repeat (2) @(posedge clk);
        #1;
        rst_n = 1'b1;
        @(negedge clk);

        m_valid = 1'b1;
        m_we = 1'b1;
        m_be = 4'b1111;
        m_addr = 32'h0001_0000;
        m_wdata = 32'h0000_005A;

        wait_master_ready();
        @(negedge clk);
        m_valid = 1'b0;
        m_we = 1'b0;
        @(posedge clk);
        #1;

        if (dmem_handshake_count != 1) begin
            $display("FAIL: dmem_handshake_count=%0d expected=1", dmem_handshake_count);
            errors = errors + 1;
        end

        if (observed_err) begin
            $display("FAIL: unexpected master error");
            errors = errors + 1;
        end

        if (observed_rdata != 32'hCAFE_0123) begin
            $display("FAIL: m_rdata=%08h expected=CAFE_0123", observed_rdata);
            errors = errors + 1;
        end

        @(negedge clk);
        m_valid = 1'b1;
        m_we = 1'b0;
        m_be = 4'b0000;
        m_addr = 32'h1000_0000;
        m_wdata = 32'b0;

        wait_master_ready();
        @(negedge clk);
        m_valid = 1'b0;
        @(posedge clk);
        #1;

        if (!observed_err || observed_rdata != 32'b0) begin
            $display("FAIL: invalid address did not report clean error");
            errors = errors + 1;
        end

        if (dmem_handshake_count != 1) begin
            $display("FAIL: invalid address reached DMEM");
            errors = errors + 1;
        end

        if (errors == 0) begin
            $display("PASS: bus_interconnect registered-ready handshake");
            $finish;
        end

        $display("FAIL: %0d errors", errors);
        $finish;
    end
endmodule
