`timescale 1ns/1ps

module branch_unit(
    input  wire [31:0] rs1_value,
    input  wire [31:0] rs2_value,
    input  wire [2:0]  branch_type,
    output reg         branch_taken
);
    always @(*) begin
        case (branch_type)
            3'd1: branch_taken = (rs1_value == rs2_value);
            3'd2: branch_taken = (rs1_value != rs2_value);
            3'd3: branch_taken = ($signed(rs1_value) < $signed(rs2_value));
            3'd4: branch_taken = ($signed(rs1_value) >= $signed(rs2_value));
            3'd5: branch_taken = (rs1_value < rs2_value);
            3'd6: branch_taken = (rs1_value >= rs2_value);
            default: branch_taken = 1'b0;
        endcase
    end
endmodule
