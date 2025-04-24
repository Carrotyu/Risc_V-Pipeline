module ExecuteStage (
    input clk,                    // Clock signal
    input rst,                    // Reset signal
    input [31:0] reg_data1,       // From register file (rs1)
    input [31:0] reg_data2,       // From register file (rs2)
    input [31:0] imm,             // Immediate value (I-type, S-type)
    input select_imm,             // ALU source select: 0 = reg_data2, 1 = imm
    input [2:0] funct3,           // Instruction funct3 field
    input [6:0] funct7,           // Instruction funct7 field
    input [1:0] ALUOp,            // ALUOp from control unit
    output [31:0] ALU_Result,     // Output result from ALU
    output Zero                   // Zero flag from ALU
);
    wire [3:0] ALUcontrol_Out;
    wire [31:0] alu_srcB;

    // MUX to select between reg_data2 and immediate
    MUX2to1 mux (
        .input0(reg_data2),
        .input1(imm),
        .select(select_imm),
        .out(alu_srcB)
    );

    // ALU Control Unit
    ALU_Control alu_ctrl (
        .funct3(funct3),
        .funct7(funct7),
        .ALUOp(ALUOp),
        .ALUcontrol_Out(ALUcontrol_Out)
    );

    // ALU
    ALU alu (
        .A(reg_data1),
        .B(alu_srcB),
        .ALUcontrol_In(ALUcontrol_Out),
        .Result(ALU_Result),
        .Zero(Zero)
    );

endmodule
