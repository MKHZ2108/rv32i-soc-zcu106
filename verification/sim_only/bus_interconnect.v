`timescale 1ns/1ps

module bus_interconnect #(
    parameter DMEM_BASE   = 32'h0001_0000,
    parameter DMEM_MASK   = 32'hFFFF_0000
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        m_valid,
    input  wire        m_we,
    input  wire [3:0]  m_be,
    input  wire [31:0] m_addr,
    input  wire [31:0] m_wdata,
    output wire        m_ready,
    output wire [31:0] m_rdata,
    output wire        m_err,
    output wire        dmem_valid,
    output wire        dmem_we,
    output wire [3:0]  dmem_be,
    output wire [31:0] dmem_addr,
    output wire [31:0] dmem_wdata,
    input  wire        dmem_ready,
    input  wire [31:0] dmem_rdata,
    input  wire        dmem_err
);
    reg active_q;
    reg hit_dmem_q;
    reg we_q;
    reg [3:0] be_q;
    reg [31:0] addr_q;
    reg [31:0] wdata_q;
    reg active_d;
    reg hit_dmem_d;
    reg we_d;
    reg [3:0] be_d;
    reg [31:0] addr_d;
    reg [31:0] wdata_d;
    wire hit_dmem;
    wire request_done;

    assign hit_dmem = ((m_addr & DMEM_MASK) == DMEM_BASE);
    assign request_done = active_q && (hit_dmem_q ? dmem_ready : 1'b1);

    always @(*) begin
        active_d = active_q;
        hit_dmem_d = hit_dmem_q;
        we_d = we_q;
        be_d = be_q;
        addr_d = addr_q;
        wdata_d = wdata_q;

        if (!active_q && m_valid) begin
            active_d = 1'b1;
            hit_dmem_d = hit_dmem;
            we_d = m_we;
            be_d = m_be;
            addr_d = m_addr;
            wdata_d = m_wdata;
        end else if (request_done) begin
            active_d = 1'b0;
            hit_dmem_d = 1'b0;
            we_d = 1'b0;
            be_d = 4'b0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active_q <= 1'b0;
            hit_dmem_q <= 1'b0;
            we_q <= 1'b0;
            be_q <= 4'b0;
            addr_q <= 32'b0;
            wdata_q <= 32'b0;
        end else begin
            active_q <= active_d;
            hit_dmem_q <= hit_dmem_d;
            we_q <= we_d;
            be_q <= be_d;
            addr_q <= addr_d;
            wdata_q <= wdata_d;
        end
    end

    assign dmem_valid = active_q && hit_dmem_q;
    assign dmem_we = we_q;
    assign dmem_be = be_q;
    assign dmem_addr = addr_q;
    assign dmem_wdata = wdata_q;

    assign m_ready = request_done;
    assign m_rdata = (active_q && hit_dmem_q) ? dmem_rdata : 32'b0;
    assign m_err = request_done && (hit_dmem_q ? dmem_err : 1'b1);
endmodule
