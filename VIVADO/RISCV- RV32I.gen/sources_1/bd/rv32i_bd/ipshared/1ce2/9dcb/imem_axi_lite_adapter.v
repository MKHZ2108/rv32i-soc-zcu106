`timescale 1ns/1ps

module imem_axi_lite_adapter #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,

    input  wire                  core_valid,
    input  wire [ADDR_WIDTH-1:0] core_addr,
    input  wire                  core_cancel,
    output wire                  core_ready,
    output wire [DATA_WIDTH-1:0] core_rdata,
    output wire                  core_err,

    output wire [ADDR_WIDTH-1:0] m_axi_awaddr,
    output wire [2:0]            m_axi_awprot,
    output wire                  m_axi_awvalid,
    input  wire                  m_axi_awready,
    output wire [DATA_WIDTH-1:0] m_axi_wdata,
    output wire [DATA_WIDTH/8-1:0] m_axi_wstrb,
    output wire                  m_axi_wvalid,
    input  wire                  m_axi_wready,
    input  wire [1:0]            m_axi_bresp,
    input  wire                  m_axi_bvalid,
    output wire                  m_axi_bready,

    output wire [ADDR_WIDTH-1:0] m_axi_araddr,
    output wire [2:0]            m_axi_arprot,
    output wire                  m_axi_arvalid,
    input  wire                  m_axi_arready,
    input  wire [DATA_WIDTH-1:0] m_axi_rdata,
    input  wire [1:0]            m_axi_rresp,
    input  wire                  m_axi_rvalid,
    output wire                  m_axi_rready
);
    localparam ST_IDLE      = 3'd0;
    localparam ST_READ_ADDR = 3'd1;
    localparam ST_READ_DATA = 3'd2;
    localparam ST_RESPONSE  = 3'd3;

    reg [2:0] state_q;
    reg [ADDR_WIDTH-1:0] addr_q;
    reg [DATA_WIDTH-1:0] rdata_q;
    reg err_q;
    reg stale_q;

    // The instruction port is read-only. Keeping the write-channel pins present
    // lets Vivado bundle this module as a complete AXI4-Lite master interface.
    assign m_axi_awaddr  = {ADDR_WIDTH{1'b0}};
    assign m_axi_awprot  = 3'b100;
    assign m_axi_awvalid = 1'b0;
    assign m_axi_wdata   = {DATA_WIDTH{1'b0}};
    assign m_axi_wstrb   = {(DATA_WIDTH/8){1'b0}};
    assign m_axi_wvalid  = 1'b0;
    assign m_axi_bready  = 1'b0;

    assign m_axi_araddr  = addr_q;
    assign m_axi_arprot  = 3'b100; // Instruction access, secure, unprivileged.
    assign m_axi_arvalid = (state_q == ST_READ_ADDR);
    assign m_axi_rready  = (state_q == ST_READ_DATA);

    // Suppress a response if a redirect arrives after AXI data was captured but
    // before the core consumes the response pulse.
    assign core_ready = (state_q == ST_RESPONSE) && !core_cancel;
    assign core_rdata = rdata_q;
    assign core_err   = err_q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q <= ST_IDLE;
            addr_q  <= {ADDR_WIDTH{1'b0}};
            rdata_q <= {DATA_WIDTH{1'b0}};
            err_q   <= 1'b0;
            stale_q <= 1'b0;
        end else begin
            case (state_q)
                ST_IDLE: begin
                    stale_q <= 1'b0;
                    err_q <= 1'b0;
                    if (core_valid && !core_cancel) begin
                        addr_q <= {core_addr[ADDR_WIDTH-1:2], 2'b00};
                        state_q <= ST_READ_ADDR;
                    end
                end

                ST_READ_ADDR: begin
                    if (core_cancel)
                        stale_q <= 1'b1;
                    if (m_axi_arready)
                        state_q <= ST_READ_DATA;
                end

                ST_READ_DATA: begin
                    if (core_cancel)
                        stale_q <= 1'b1;
                    if (m_axi_rvalid) begin
                        if (stale_q || core_cancel) begin
                            // AXI requests cannot be canceled after acceptance;
                            // consume the stale response without notifying the core.
                            state_q <= ST_IDLE;
                            stale_q <= 1'b0;
                        end else begin
                            rdata_q <= m_axi_rdata;
                            err_q <= |m_axi_rresp;
                            state_q <= ST_RESPONSE;
                        end
                    end
                end

                ST_RESPONSE: begin
                    // A separate response state prevents recapturing the old
                    // continuously asserted IMEM request in the response cycle.
                    state_q <= ST_IDLE;
                end

                default: state_q <= ST_IDLE;
            endcase
        end
    end
endmodule
