`timescale 1ns/1ps

module csr_file #(
    parameter XLEN = 32
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire             external_irq,
    input  wire             retire,
    input  wire [11:0]      read_addr,
    output reg  [XLEN-1:0]  read_data,
    output reg              read_valid,
    output reg              read_only,
    input  wire             write_en,
    input  wire [11:0]      write_addr,
    input  wire [XLEN-1:0]  write_data,
    input  wire             trap_en,
    input  wire [XLEN-1:0]  trap_mepc,
    input  wire [XLEN-1:0]  trap_mcause,
    input  wire [XLEN-1:0]  trap_mtval,
    input  wire             mret_en,
    output wire [XLEN-1:0]  mtvec_value,
    output wire [XLEN-1:0]  mepc_value,
    output wire             external_irq_enabled
);
    reg [XLEN-1:0] mstatus;
    reg [XLEN-1:0] mie;
    reg [XLEN-1:0] mtvec;
    reg [XLEN-1:0] mscratch;
    reg [XLEN-1:0] mepc;
    reg [XLEN-1:0] mcause;
    reg [XLEN-1:0] mtval;
    reg [XLEN-1:0] mip;
    reg [63:0] cycle_counter;
    reg [63:0] instret_counter;
    reg [XLEN-1:0] mstatus_d;
    reg [XLEN-1:0] mie_d;
    reg [XLEN-1:0] mtvec_d;
    reg [XLEN-1:0] mscratch_d;
    reg [XLEN-1:0] mepc_d;
    reg [XLEN-1:0] mcause_d;
    reg [XLEN-1:0] mtval_d;
    reg [XLEN-1:0] mip_d;
    reg [63:0] cycle_counter_d;
    reg [63:0] instret_counter_d;

    localparam [XLEN-1:0] MISA_RV32I = 32'h4000_0100;
    localparam [XLEN-1:0] MVENDORID  = 32'h0000_0000;
    localparam [XLEN-1:0] MARCHID    = 32'h0000_0000;
    localparam [XLEN-1:0] MIMPID     = 32'h0000_0000;
    localparam [XLEN-1:0] MHARTID    = 32'h0000_0000;

    assign mtvec_value = mtvec;
    assign mepc_value = mepc;
    assign external_irq_enabled = mstatus[3] && mie[11];

    function [XLEN-1:0] sanitize_mstatus;
        input [XLEN-1:0] value;
        begin
            sanitize_mstatus = {XLEN{1'b0}};
            sanitize_mstatus[3] = value[3];      // MIE
            sanitize_mstatus[7] = value[7];      // MPIE
            sanitize_mstatus[12:11] = 2'b11;     // M-mode-only core: MPP reads as Machine.
        end
    endfunction

    function [XLEN-1:0] sanitize_mtvec;
        input [XLEN-1:0] value;
        begin
            sanitize_mtvec = {value[XLEN-1:2], 2'b00};
            if (value[1:0] == 2'b01)
                sanitize_mtvec[1:0] = 2'b01;
        end
    endfunction

    function [XLEN-1:0] sanitize_mie;
        input [XLEN-1:0] value;
        begin
            sanitize_mie = {XLEN{1'b0}};
            sanitize_mie[11] = value[11];       // MEIE
        end
    endfunction

    function [XLEN-1:0] sanitize_mepc;
        input [XLEN-1:0] value;
        begin
            sanitize_mepc = {value[XLEN-1:2], 2'b00};
        end
    endfunction

    always @(*) begin
        read_data = {XLEN{1'b0}};
        read_valid = 1'b1;
        read_only = 1'b0;

        case (read_addr)
            12'h300: read_data = mstatus;
            12'h304: read_data = mie;
            12'h301: read_data = MISA_RV32I;
            12'h305: read_data = mtvec;
            12'h340: read_data = mscratch;
            12'h341: read_data = mepc;
            12'h342: read_data = mcause;
            12'h343: read_data = mtval;
            12'h344: begin
                read_data = mip;
                read_data[11] = external_irq;   // MEIP is driven by the IRQ pin.
            end
            12'hB00: read_data = cycle_counter[31:0];
            12'hB02: read_data = instret_counter[31:0];
            12'hB80: read_data = cycle_counter[63:32];
            12'hB82: read_data = instret_counter[63:32];
            12'hC00: begin read_data = cycle_counter[31:0]; read_only = 1'b1; end
            12'hC01: begin read_data = cycle_counter[31:0]; read_only = 1'b1; end
            12'hC02: begin read_data = instret_counter[31:0]; read_only = 1'b1; end
            12'hC80: begin read_data = cycle_counter[63:32]; read_only = 1'b1; end
            12'hC81: begin read_data = cycle_counter[63:32]; read_only = 1'b1; end
            12'hC82: begin read_data = instret_counter[63:32]; read_only = 1'b1; end
            12'hF11: begin read_data = MVENDORID; read_only = 1'b1; end
            12'hF12: begin read_data = MARCHID; read_only = 1'b1; end
            12'hF13: begin read_data = MIMPID; read_only = 1'b1; end
            12'hF14: begin read_data = MHARTID; read_only = 1'b1; end
            default: begin
                read_valid = 1'b0;
                read_only = 1'b0;
            end
        endcase
    end

    always @(*) begin
        mstatus_d = mstatus;
        mie_d = mie;
        mtvec_d = mtvec;
        mscratch_d = mscratch;
        mepc_d = mepc;
        mcause_d = mcause;
        mtval_d = mtval;
        mip_d = mip;
        mip_d[11] = external_irq;
        cycle_counter_d = cycle_counter + 64'd1;
        instret_counter_d = instret_counter + (retire ? 64'd1 : 64'd0);

        if (write_en) begin
            case (write_addr)
                12'h300: mstatus_d = sanitize_mstatus(write_data);
                12'h304: mie_d = sanitize_mie(write_data);
                12'h301: begin end
                12'h305: mtvec_d = sanitize_mtvec(write_data);
                12'h340: mscratch_d = write_data;
                12'h341: mepc_d = sanitize_mepc(write_data);
                12'h342: mcause_d = write_data;
                12'h343: mtval_d = write_data;
                12'h344: begin end             // MEIP is read-only.
                12'hB00: cycle_counter_d[31:0] = write_data;
                12'hB02: instret_counter_d[31:0] = write_data;
                12'hB80: cycle_counter_d[63:32] = write_data;
                12'hB82: instret_counter_d[63:32] = write_data;
                default: begin end
            endcase
        end

        if (trap_en) begin
            mepc_d = sanitize_mepc(trap_mepc);
            mcause_d = trap_mcause;
            mtval_d = trap_mtval;
            mstatus_d[7] = mstatus[3];
            mstatus_d[3] = 1'b0;
            mstatus_d[12:11] = 2'b11;
        end else if (mret_en) begin
            mstatus_d[3] = mstatus[7];
            mstatus_d[7] = 1'b1;
            mstatus_d[12:11] = 2'b11;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mstatus <= sanitize_mstatus({XLEN{1'b0}});
            mie <= sanitize_mie({XLEN{1'b0}});
            mtvec <= sanitize_mtvec({XLEN{1'b0}});
            mscratch <= {XLEN{1'b0}};
            mepc <= sanitize_mepc({XLEN{1'b0}});
            mcause <= {XLEN{1'b0}};
            mtval <= {XLEN{1'b0}};
            mip <= {XLEN{1'b0}};
            cycle_counter <= 64'b0;
            instret_counter <= 64'b0;
        end else begin
            mstatus <= mstatus_d;
            mie <= mie_d;
            mtvec <= mtvec_d;
            mscratch <= mscratch_d;
            mepc <= mepc_d;
            mcause <= mcause_d;
            mtval <= mtval_d;
            mip <= mip_d;
            cycle_counter <= cycle_counter_d;
            instret_counter <= instret_counter_d;
        end
    end
endmodule
