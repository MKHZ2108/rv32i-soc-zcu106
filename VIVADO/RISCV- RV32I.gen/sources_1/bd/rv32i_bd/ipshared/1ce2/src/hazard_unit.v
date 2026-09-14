`timescale 1ns/1ps

module hazard_unit(
    input  wire        id_valid,
    input  wire [31:0] id_instr,
    input  wire [4:0]  id_rs1,
    input  wire [4:0]  id_rs2,
    input  wire        ex_valid,
    input  wire        ex_mem_read,
    input  wire [4:0]  ex_rd,
    input  wire        mem_wait,
    input  wire        pc_redirect_valid,
    input  wire        trap_valid,
    input  wire [2:0]  trap_stage,
    output reg         stall_pc,
    output reg         stall_if_id,
    output reg         stall_id_ex,
    output reg         stall_ex_mem,
    output reg         stall_mem_wb,
    output reg         flush_if_id,
    output reg         flush_id_ex,
    output reg         flush_ex_mem,
    output reg         flush_mem_wb
);
    always @(*) begin
        stall_pc = 1'b0;
        stall_if_id = 1'b0;
        stall_id_ex = 1'b0;
        stall_ex_mem = 1'b0;
        stall_mem_wb = 1'b0;
        flush_if_id = 1'b0;
        flush_id_ex = 1'b0;
        flush_ex_mem = 1'b0;
        flush_mem_wb = 1'b0;

        if (trap_valid && trap_stage == 3'd5) begin
            flush_if_id = 1'b1;
            flush_id_ex = 1'b1;
            flush_ex_mem = 1'b1;
            flush_mem_wb = 1'b1;
        end else if (mem_wait) begin
            stall_pc = 1'b1;
            stall_if_id = 1'b1;
            stall_id_ex = 1'b1;
            stall_ex_mem = 1'b1;
            stall_mem_wb = 1'b1;
        end else begin
            if (ex_valid && ex_mem_read && ex_rd != 5'd0 && id_valid &&
                ((!(id_instr[6:0] == 7'b0110111 ||
                    id_instr[6:0] == 7'b0010111 ||
                    id_instr[6:0] == 7'b1101111) &&
                  ex_rd == id_rs1) ||
                 ((id_instr[6:0] == 7'b0100011 ||
                   id_instr[6:0] == 7'b1100011 ||
                   id_instr[6:0] == 7'b0110011) &&
                  ex_rd == id_rs2))) begin
                stall_pc = 1'b1;
                stall_if_id = 1'b1;
                flush_id_ex = 1'b1;
            end

            if (pc_redirect_valid) begin
                flush_if_id = 1'b1;
                flush_id_ex = 1'b1;
                stall_pc = 1'b0;
            end

            if (trap_valid) begin
                case (trap_stage)
                    3'd2: begin
                        flush_if_id = 1'b1;
                        flush_id_ex = 1'b0;
                    end
                    3'd3: begin
                        flush_if_id = 1'b1;
                        flush_id_ex = 1'b1;
                        flush_ex_mem = 1'b0;
                    end
                    3'd4: begin
                        flush_if_id = 1'b1;
                        flush_id_ex = 1'b1;
                        flush_ex_mem = 1'b1;
                        flush_mem_wb = 1'b0;
                    end
                    default: begin end
                endcase
            end
        end
    end
endmodule
