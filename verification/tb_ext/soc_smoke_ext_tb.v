`timescale 1ns/1ps

module soc_smoke_ext_tb;
    reg clk;
    reg rst_n;
    wire        debug_halted;
    wire [31:0] debug_pc;
    wire [31:0] debug_instr;
    integer errors;
    integer i;

    rv32i_soc_top dut (
        .clk(clk), .rst_n(rst_n),
        .debug_halted(debug_halted), .debug_pc(debug_pc),
        .debug_instr(debug_instr)
    );

    always #5 clk = ~clk;

    function [31:0] i_type;
        input [31:0] imm_i;
        input [4:0]  rs1_i;
        input [2:0]  f3;
        input [4:0]  rd_i;
        input [6:0]  opcode_i;
        begin
            i_type = {imm_i[11:0], rs1_i, f3, rd_i, opcode_i};
        end
    endfunction

    function [31:0] s_type;
        input [31:0] imm_i;
        input [4:0]  rs2_i;
        input [4:0]  rs1_i;
        input [2:0]  f3;
        begin
            s_type = {imm_i[11:5], rs2_i, rs1_i, f3, imm_i[4:0], 7'b0100011};
        end
    endfunction

    function [31:0] u_type;
        input [19:0] imm20_i;
        input [4:0]  rd_i;
        input [6:0]  opcode_i;
        begin
            u_type = {imm20_i, rd_i, opcode_i};
        end
    endfunction

    function [31:0] j_type;
        input [31:0] imm_i;
        input [4:0]  rd_i;
        begin
            j_type = {imm_i[20], imm_i[10:1], imm_i[11], imm_i[19:12], rd_i, 7'b1101111};
        end
    endfunction

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

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        errors = 0;

        for (i = 0; i < 32; i = i + 1) begin
            dut.u_core.u_id.u_reg_file.regs[i] = 32'b0;
        end

        for (i = 0; i < 16; i = i + 1)
            dut.u_imem.mem[i] = 32'h0000_0013;

        dut.u_imem.mem[0] = i_type(32'h05A, 5'd0, 3'b000, 5'd1, 7'b0010011);
        dut.u_imem.mem[1] = u_type(20'h00010, 5'd2, 7'b0110111);
        dut.u_imem.mem[2] = s_type(32'd0, 5'd1, 5'd2, 3'b010);
        dut.u_imem.mem[3] = j_type(32'd0, 5'd0);

        repeat (3) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;
        repeat (240) @(posedge clk);

        check(dut.u_dmem.mem[0] == 32'h0000_005A, "SoC wrote data memory through bus");
        check(debug_halted == 1'b0, "SoC debug_halted stays low");

        if (errors == 0) begin
            $display("PASS: soc_smoke_ext_tb");
            $finish;
        end

        $display("FAIL: soc_smoke_ext_tb %0d errors", errors);
        $finish;
    end
endmodule
