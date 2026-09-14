`timescale 1ns/1ps

module dmem_axi_lite_adapter #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                    clk,
    input  wire                    rst_n,

    input  wire                    core_valid,
    input  wire                    core_we,
    input  wire [DATA_WIDTH/8-1:0] core_be,
    input  wire [ADDR_WIDTH-1:0]   core_addr,
    input  wire [DATA_WIDTH-1:0]   core_wdata,
    output wire                    core_ready,
    output wire [DATA_WIDTH-1:0]   core_rdata,
    output wire                    core_err,

    output wire [ADDR_WIDTH-1:0]   m_axi_awaddr,
    output wire [2:0]              m_axi_awprot,
    output wire                    m_axi_awvalid,
    input  wire                    m_axi_awready,
    output wire [DATA_WIDTH-1:0]   m_axi_wdata,
    output wire [DATA_WIDTH/8-1:0] m_axi_wstrb,
    output wire                    m_axi_wvalid,
    input  wire                    m_axi_wready,
    input  wire [1:0]              m_axi_bresp,
    input  wire                    m_axi_bvalid,
    output wire                    m_axi_bready,

    output wire [ADDR_WIDTH-1:0]   m_axi_araddr,
    output wire [2:0]              m_axi_arprot,
    output wire                    m_axi_arvalid,
    input  wire                    m_axi_arready,
    input  wire [DATA_WIDTH-1:0]   m_axi_rdata,
    input  wire [1:0]              m_axi_rresp,
    input  wire                    m_axi_rvalid,
    output wire                    m_axi_rready
);
    localparam ST_IDLE       = 3'd0;
    localparam ST_READ_ADDR  = 3'd1;
    localparam ST_READ_DATA  = 3'd2;
    localparam ST_WRITE_DATA = 3'd3;
    localparam ST_WRITE_RESP = 3'd4;
    localparam ST_RESPONSE   = 3'd5;

    reg [2:0] state_q;
    reg [ADDR_WIDTH-1:0] addr_q;
    reg [DATA_WIDTH-1:0] wdata_q;
    reg [DATA_WIDTH/8-1:0] wstrb_q;
    reg [DATA_WIDTH-1:0] rdata_q;
    reg err_q;
    reg aw_done_q;
    reg w_done_q;

    wire aw_handshake;
    wire w_handshake;
    wire aw_complete;
    wire w_complete;

    assign m_axi_awaddr  = addr_q;
    assign m_axi_awprot  = 3'b000;
    assign m_axi_awvalid = (state_q == ST_WRITE_DATA) && !aw_done_q;
    assign m_axi_wdata   = wdata_q;
    assign m_axi_wstrb   = wstrb_q;
    assign m_axi_wvalid  = (state_q == ST_WRITE_DATA) && !w_done_q;
    assign m_axi_bready  = (state_q == ST_WRITE_RESP);

    assign m_axi_araddr  = addr_q;
    assign m_axi_arprot  = 3'b000;
    assign m_axi_arvalid = (state_q == ST_READ_ADDR);
    assign m_axi_rready  = (state_q == ST_READ_DATA);

    assign core_ready = (state_q == ST_RESPONSE);
    assign core_rdata = rdata_q;
    assign core_err   = err_q;

    assign aw_handshake = m_axi_awvalid && m_axi_awready;
    assign w_handshake  = m_axi_wvalid && m_axi_wready;
    assign aw_complete  = aw_done_q || aw_handshake;
    assign w_complete   = w_done_q || w_handshake;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q   <= ST_IDLE;
            addr_q    <= {ADDR_WIDTH{1'b0}};
            wdata_q   <= {DATA_WIDTH{1'b0}};
            wstrb_q   <= {(DATA_WIDTH/8){1'b0}};
            rdata_q   <= {DATA_WIDTH{1'b0}};
            err_q     <= 1'b0;
            aw_done_q <= 1'b0;
            w_done_q  <= 1'b0;
        end else begin
            case (state_q)
                ST_IDLE: begin
                    err_q <= 1'b0;
                    aw_done_q <= 1'b0;
                    w_done_q <= 1'b0;
                    if (core_valid) begin
                        addr_q <= {core_addr[ADDR_WIDTH-1:2], 2'b00};
                        if (core_we) begin
                            wdata_q <= core_wdata;
                            wstrb_q <= core_be;
                            state_q <= ST_WRITE_DATA;
                        end else begin
                            state_q <= ST_READ_ADDR;
                        end
                    end
                end

                ST_READ_ADDR: begin
                    if (m_axi_arready)
                        state_q <= ST_READ_DATA;
                end

                ST_READ_DATA: begin
                    if (m_axi_rvalid) begin
                        rdata_q <= m_axi_rdata;
                        err_q <= |m_axi_rresp;
                        state_q <= ST_RESPONSE;
                    end
                end

                ST_WRITE_DATA: begin
                    if (aw_handshake)
                        aw_done_q <= 1'b1;
                    if (w_handshake)
                        w_done_q <= 1'b1;
                    if (aw_complete && w_complete)
                        state_q <= ST_WRITE_RESP;
                end

                ST_WRITE_RESP: begin
                    if (m_axi_bvalid) begin
                        err_q <= |m_axi_bresp;
                        state_q <= ST_RESPONSE;
                    end
                end

                ST_RESPONSE: begin
                    // The core releases/advances its MEM request in this cycle.
                    // Returning through IDLE avoids issuing the completed store twice.
                    state_q <= ST_IDLE;
                end

                default: state_q <= ST_IDLE;
            endcase
        end
    end
endmodule
