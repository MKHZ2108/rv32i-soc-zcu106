`timescale 1ns/1ps

module imem_axi_lite_adapter_tb;
    reg clk;
    reg rst_n;
    reg core_valid;
    reg [31:0] core_addr;
    reg core_cancel;
    wire core_ready;
    wire [31:0] core_rdata;
    wire core_err;

    wire [31:0] awaddr;
    wire [2:0] awprot;
    wire awvalid;
    reg awready;
    wire [31:0] wdata;
    wire [3:0] wstrb;
    wire wvalid;
    reg wready;
    reg [1:0] bresp;
    reg bvalid;
    wire bready;
    wire [31:0] araddr;
    wire [2:0] arprot;
    wire arvalid;
    reg arready;
    reg [31:0] rdata;
    reg [1:0] rresp;
    reg rvalid;
    wire rready;
    integer errors;

    imem_axi_lite_adapter dut (
        .clk(clk), .rst_n(rst_n),
        .core_valid(core_valid), .core_addr(core_addr), .core_cancel(core_cancel),
        .core_ready(core_ready), .core_rdata(core_rdata), .core_err(core_err),
        .m_axi_awaddr(awaddr), .m_axi_awprot(awprot), .m_axi_awvalid(awvalid), .m_axi_awready(awready),
        .m_axi_wdata(wdata), .m_axi_wstrb(wstrb), .m_axi_wvalid(wvalid), .m_axi_wready(wready),
        .m_axi_bresp(bresp), .m_axi_bvalid(bvalid), .m_axi_bready(bready),
        .m_axi_araddr(araddr), .m_axi_arprot(arprot), .m_axi_arvalid(arvalid), .m_axi_arready(arready),
        .m_axi_rdata(rdata), .m_axi_rresp(rresp), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
    );

    always #5 clk = ~clk;

    task tick;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task check;
        input condition;
        input [255:0] message;
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
        core_valid = 1'b0;
        core_addr = 32'b0;
        core_cancel = 1'b0;
        awready = 1'b0;
        wready = 1'b0;
        bresp = 2'b00;
        bvalid = 1'b0;
        arready = 1'b0;
        rdata = 32'b0;
        rresp = 2'b00;
        rvalid = 1'b0;
        errors = 0;

        repeat (2) tick();
        rst_n = 1'b1;
        tick();
        check(!arvalid && !rready && !core_ready, "reset leaves IMEM adapter idle");
        check(!awvalid && !wvalid && awaddr == 0 && wdata == 0 && wstrb == 0,
              "IMEM write channels remain inactive");

        // Normal read with address and data wait states.
        core_valid = 1'b1;
        core_addr = 32'h0000_0040;
        tick();
        check(arvalid && araddr == 32'h0000_0040 && arprot == 3'b100,
              "IMEM latches address and marks instruction access");
        tick();
        check(arvalid && araddr == 32'h0000_0040, "IMEM holds ARVALID and ARADDR under backpressure");
        arready = 1'b1;
        tick();
        arready = 1'b0;
        check(!arvalid && rready, "IMEM waits for R channel after AR handshake");
        tick();
        check(rready && !core_ready, "IMEM holds RREADY while response is delayed");
        rdata = 32'h1234_5678;
        rresp = 2'b00;
        rvalid = 1'b1;
        tick();
        rvalid = 1'b0;
        check(core_ready && core_rdata == 32'h1234_5678 && !core_err,
              "IMEM returns successful AXI read response");
        core_valid = 1'b0;
        tick();
        check(!core_ready && !arvalid, "IMEM ready is a single response cycle");

        // Error response.
        core_valid = 1'b1;
        core_addr = 32'h0000_0080;
        tick();
        arready = 1'b1;
        tick();
        arready = 1'b0;
        rdata = 32'hDEAD_BEEF;
        rresp = 2'b10;
        rvalid = 1'b1;
        tick();
        rvalid = 1'b0;
        check(core_ready && core_err, "IMEM maps SLVERR to core_err");
        core_valid = 1'b0;
        tick();

        // Redirect after address acceptance: consume but discard old response.
        core_valid = 1'b1;
        core_addr = 32'h0000_0100;
        tick();
        arready = 1'b1;
        tick();
        arready = 1'b0;
        core_cancel = 1'b1;
        core_addr = 32'h0000_0200;
        tick();
        core_cancel = 1'b0;
        rdata = 32'hAAAA_AAAA;
        rresp = 2'b00;
        rvalid = 1'b1;
        tick();
        rvalid = 1'b0;
        check(!core_ready, "IMEM discards stale response after redirect");
        tick();
        check(arvalid && araddr == 32'h0000_0200, "IMEM requests redirected PC after stale response");
        arready = 1'b1;
        tick();
        arready = 1'b0;
        rdata = 32'h0000_0013;
        rvalid = 1'b1;
        tick();
        rvalid = 1'b0;
        check(core_ready && core_rdata == 32'h0000_0013 && !core_err,
              "IMEM returns redirected instruction");
        core_valid = 1'b0;
        tick();

        // Reset aborts local state and removes VALID/READY outputs.
        core_valid = 1'b1;
        core_addr = 32'h0000_0300;
        tick();
        check(arvalid, "IMEM transaction active before reset");
        rst_n = 1'b0;
        #1;
        check(!arvalid && !rready && !core_ready, "IMEM reset clears outstanding local transaction");
        tick();
        rst_n = 1'b1;
        core_valid = 1'b0;
        tick();

        if (errors == 0) begin
            $display("PASS: imem_axi_lite_adapter_tb");
            $finish;
        end
        $display("FAIL: imem_axi_lite_adapter_tb %0d errors", errors);
        $finish;
    end
endmodule
