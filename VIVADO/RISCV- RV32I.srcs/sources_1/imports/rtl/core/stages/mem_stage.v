`timescale 1ns/1ps

module mem_stage(
    input  wire        mem_valid,
    input  wire        mem_fault_in,
    input  wire [31:0] mem_fault_cause_in,
    input  wire [31:0] mem_fault_tval_in,
    input  wire [31:0] mem_alu_result,
    input  wire [31:0] mem_store_data,
    input  wire        mem_mem_read,
    input  wire        mem_mem_write,
    input  wire [1:0]  mem_mem_size,
    input  wire        mem_mem_unsigned,
    output wire        dmem_valid,
    output wire        dmem_we,
    output reg  [3:0]  dmem_be,
    output wire [31:0] dmem_addr,
    output reg  [31:0] dmem_wdata,
    input  wire        dmem_ready,
    input  wire [31:0] dmem_rdata,
    input  wire        dmem_err,
    output wire        mem_wait,
    output wire        mem_fault_out,
    output reg  [31:0] mem_fault_cause,
    output reg  [31:0] mem_fault_tval,
    output reg  [31:0] mem_load_data
);
    reg [7:0] load_byte;
    reg [15:0] load_half;

    assign dmem_addr = mem_alu_result;
    assign dmem_we = mem_mem_write;
    assign dmem_valid = mem_valid && (mem_mem_read || mem_mem_write) && !mem_fault_in &&
                        !((mem_mem_size == 2'd1 && mem_alu_result[0]) ||
                          (mem_mem_size == 2'd2 && |mem_alu_result[1:0]));
    assign mem_wait = dmem_valid && !dmem_ready;
    assign mem_fault_out = mem_fault_in |
                           (mem_valid && (mem_mem_read || mem_mem_write) &&
                            ((mem_mem_size == 2'd1 && mem_alu_result[0]) ||
                             (mem_mem_size == 2'd2 && |mem_alu_result[1:0]))) |
                           (dmem_valid && dmem_ready && dmem_err);

    always @(*) begin
        mem_fault_cause = mem_fault_cause_in;
        mem_fault_tval = mem_fault_tval_in;

        if (!mem_fault_in) begin
            if (mem_valid && (mem_mem_read || mem_mem_write) &&
                ((mem_mem_size == 2'd1 && mem_alu_result[0]) ||
                 (mem_mem_size == 2'd2 && |mem_alu_result[1:0]))) begin
                mem_fault_cause = mem_mem_write ? 32'd6 : 32'd4;
                mem_fault_tval = mem_alu_result;
            end else if (dmem_valid && dmem_ready && dmem_err) begin
                mem_fault_cause = mem_mem_write ? 32'd7 : 32'd5;
                mem_fault_tval = mem_alu_result;
            end
        end
    end

    always @(*) begin
        dmem_be = 4'b0000;
        dmem_wdata = 32'b0;
        case (mem_mem_size)
            2'd0: begin
                dmem_be = 4'b0001 << mem_alu_result[1:0];
                dmem_wdata = {24'b0, mem_store_data[7:0]} << {mem_alu_result[1:0], 3'b000};
            end
            2'd1: begin
                dmem_be = 4'b0011 << {mem_alu_result[1], 1'b0};
                dmem_wdata = {16'b0, mem_store_data[15:0]} << {mem_alu_result[1], 4'b000};
            end
            default: begin
                dmem_be = 4'b1111;
                dmem_wdata = mem_store_data;
            end
        endcase
    end

    always @(*) begin
        case (mem_alu_result[1:0])
            2'd1: load_byte = dmem_rdata[15:8];
            2'd2: load_byte = dmem_rdata[23:16];
            2'd3: load_byte = dmem_rdata[31:24];
            default: load_byte = dmem_rdata[7:0];
        endcase

        load_half = mem_alu_result[1] ? dmem_rdata[31:16] : dmem_rdata[15:0];

        case (mem_mem_size)
            2'd0: mem_load_data = mem_mem_unsigned ? {24'b0, load_byte} :
                            {{24{load_byte[7]}}, load_byte};
            2'd1: mem_load_data = mem_mem_unsigned ? {16'b0, load_half} :
                            {{16{load_half[15]}}, load_half};
            default: mem_load_data = dmem_rdata;
        endcase
    end
endmodule
