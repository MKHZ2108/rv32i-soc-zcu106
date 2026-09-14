`timescale 1ns/1ps

module dmem_axi_lite_adapter_tb;
    reg clk;
    reg rst_n;
    reg core_valid;
    reg core_we;
    reg [3:0] core_be;
    reg [31:0] core_addr;
    reg [31:0] core_wdata;
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

    dmem_axi_lite_adapter dut (
        .clk(clk), .rst_n(rst_n),
        .core_valid(core_valid), .core_we(core_we), .core_be(core_be),
        .core_addr(core_addr), .core_wdata(core_wdata),
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
        core_we = 1'b0;
        core_be = 4'b0;
        core_addr = 32'b0;
        core_wdata = 32'b0;
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
        check(!awvalid && !wvalid && !arvalid && !core_ready, "reset leaves DMEM adapter idle");

        // Read with independent AR and R delays.
        core_valid = 1'b1;
        core_we = 1'b0;
        core_addr = 32'h0001_0013;
        tick();
        check(arvalid && araddr == 32'h0001_0010 && arprot == 3'b000,
              "DMEM aligns and latches read address");
        tick();
        check(arvalid && araddr == 32'h0001_0010, "DMEM holds AR channel under backpressure");
        arready = 1'b1;
        tick();
        arready = 1'b0;
        check(rready && !core_ready, "DMEM waits for read data");
        rdata = 32'hCAFE_BABE;
        rresp = 2'b00;
        rvalid = 1'b1;
        tick();
        rvalid = 1'b0;
        check(core_ready && core_rdata == 32'hCAFE_BABE && !core_err,
              "DMEM returns successful read response");
        core_valid = 1'b0;
        tick();
        check(!core_ready, "DMEM read ready is one cycle");

        // Write where AW is accepted before W.
        core_valid = 1'b1;
        core_we = 1'b1;
        core_addr = 32'h4000_0005;
        core_wdata = 32'h0000_4100;
        core_be = 4'b0010;
        tick();
        check(awvalid && wvalid && awaddr == 32'h4000_0004 && wdata == 32'h0000_4100 && wstrb == 4'b0010,
              "DMEM presents write address, data, and strobe");
        awready = 1'b1;
        tick();
        awready = 1'b0;
        check(!awvalid && wvalid && awaddr == 32'h4000_0004 && wdata == 32'h0000_4100,
              "DMEM remembers AW handshake while waiting for W");
        wready = 1'b1;
        tick();
        wready = 1'b0;
        check(!awvalid && !wvalid && bready, "DMEM waits for B only after both AW and W handshakes");
        bresp = 2'b00;
        bvalid = 1'b1;
        tick();
        bvalid = 1'b0;
        check(core_ready && !core_err, "DMEM completes write only after B response");
        core_valid = 1'b0;
        tick();
        check(!awvalid && !wvalid && !bready && !core_ready,
              "DMEM does not duplicate completed store");

        // Write where W is accepted before AW, with DECERR response.
        core_valid = 1'b1;
        core_we = 1'b1;
        core_addr = 32'h4002_0020;
        core_wdata = 32'h1122_3344;
        core_be = 4'b1111;
        tick();
        wready = 1'b1;
        tick();
        wready = 1'b0;
        check(awvalid && !wvalid, "DMEM remembers W handshake while waiting for AW");
        awready = 1'b1;
        tick();
        awready = 1'b0;
        check(bready, "DMEM enters write response after delayed AW");
        bresp = 2'b11;
        bvalid = 1'b1;
        tick();
        bvalid = 1'b0;
        check(core_ready && core_err, "DMEM maps DECERR write response to core_err");
        core_valid = 1'b0;
        tick();

        // Read error.
        core_valid = 1'b1;
        core_we = 1'b0;
        core_addr = 32'h5000_0000;
        tick();
        arready = 1'b1;
        tick();
        arready = 1'b0;
        rdata = 32'h0;
        rresp = 2'b10;
        rvalid = 1'b1;
        tick();
        rvalid = 1'b0;
        check(core_ready && core_err, "DMEM maps read SLVERR to core_err");
        core_valid = 1'b0;
        tick();

        // Reset during an outstanding write removes all local VALID state.
        core_valid = 1'b1;
        core_we = 1'b1;
        core_addr = 32'h0001_0020;
        core_wdata = 32'h55AA_55AA;
        core_be = 4'b1111;
        tick();
        check(awvalid && wvalid, "DMEM write active before reset");
        rst_n = 1'b0;
        #1;
        check(!awvalid && !wvalid && !bready && !core_ready,
              "DMEM reset clears outstanding local transaction");
        tick();
        rst_n = 1'b1;
        core_valid = 1'b0;
        tick();

        if (errors == 0) begin
            $display("PASS: dmem_axi_lite_adapter_tb");
            $finish;
        end
        $display("FAIL: dmem_axi_lite_adapter_tb %0d errors", errors);
        $finish;
    end
endmodule
