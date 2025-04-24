`timescale 1ns / 1ps

module tb_ALU_Control;

    // Inputs
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [1:0] ALUOp;

    // Output
    wire [3:0] ALUcontrol_Out;

    // Instantiate the Unit Under Test (UUT)
    ALU_Control uut (
        .funct3(funct3),
        .funct7(funct7),
        .ALUOp(ALUOp),
        .ALUcontrol_Out(ALUcontrol_Out)
    );

    // Stimulus
    initial begin
        $display("Time\tALUOp\tfunct7\tfunct3\tALUcontrol_Out");
        $monitor("%g\t%b\t%b\t%b\t%b", $time, ALUOp, funct7, funct3, ALUcontrol_Out);

        // ADD (R-type)
        ALUOp = 2'b10; funct7 = 7'b0000000; funct3 = 3'b000; #10;

        // ADD (I-type)
        ALUOp = 2'b00; funct7 = 7'b0000000; funct3 = 3'b000; #10;

        // SUB
        ALUOp = 2'b10; funct7 = 7'b0100000; funct3 = 3'b000; #10;

        // AND
        ALUOp = 2'b10; funct7 = 7'b0000000; funct3 = 3'b111; #10;

        // OR
        ALUOp = 2'b10; funct7 = 7'b0000000; funct3 = 3'b110; #10;

        // XOR
        ALUOp = 2'b10; funct7 = 7'b0000000; funct3 = 3'b100; #10;

        // SLL
        ALUOp = 2'b10; funct7 = 7'b0000000; funct3 = 3'b001; #10;

        // SRL
        ALUOp = 2'b10; funct7 = 7'b0000000; funct3 = 3'b101; #10;

        // SRA
        ALUOp = 2'b10; funct7 = 7'b0100000; funct3 = 3'b101; #10;

        // SLT
        ALUOp = 2'b10; funct7 = 7'b0000000; funct3 = 3'b010; #10;

        // Unknown/default case
        ALUOp = 2'b11; funct7 = 7'b1111111; funct3 = 3'b111; #10;

        $finish;
    end

endmodule

