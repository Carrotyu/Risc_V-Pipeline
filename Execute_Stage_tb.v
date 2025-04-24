`timescale 1ns / 1ps

module tb_ExecuteStage;

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] reg_data1, reg_data2, imm;
    reg select_imm;                // MUX select: 0 for reg_data2, 1 for imm
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [1:0] ALUOp;

    // Outputs
    wire [31:0] ALU_Result;
    wire Zero;

    // Instantiate the Execute Stage
    ExecuteStage execute_stage (
        .clk(clk),
        .rst(rst),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .imm(imm),
        .select_imm(select_imm),
        .funct3(funct3),
        .funct7(funct7),
        .ALUOp(ALUOp),
        .ALU_Result(ALU_Result),
        .Zero(Zero)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize signals
        rst = 1;
        reg_data1 = 0;
        reg_data2 = 0;
        imm = 0;
        select_imm = 0;
        funct3 = 0;
        funct7 = 0;
        ALUOp = 0;

        // Display header
        $display("Time | A       | B       | ALUOp | Funct7 | Funct3 | Result  | Zero");

        // Release reset after 10ns
        #10 rst = 0;

        // Test 1: ADD (register)
        @(posedge clk);
        reg_data1 = 32'd10;
        reg_data2 = 32'd20;
        imm = 32'd100;
        select_imm = 0;           // Select reg_data2
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        ALUOp = 2'b10;            // R-type
        #10;

        // Test 2: SUB (register)
        @(posedge clk);
        funct7 = 7'b0100000;
        #10;

        // Test 3: AND (register)
        @(posedge clk);
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #10;

        // Test 4: OR (register)
        @(posedge clk);
        funct3 = 3'b110;
        #10;

        // Test 5: ADDI (I-type, immediate)
        @(posedge clk);
        select_imm = 1;           // Select imm
        funct3 = 3'b000;
        funct7 = 7'b0000000;      // Ignored for I-type
        ALUOp = 2'b00;            // I-type
        #10;

        // Test 6: SLT (set less than)
        @(posedge clk);
        reg_data1 = -5;
        imm = 4;
        funct3 = 3'b010;
        ALUOp = 2'b10;
        funct7 = 7'b0000000;
        #10;

        // Done
        #10 $finish;
    end

    // Display results
    always @(posedge clk) begin
        if (!rst) begin
            $display("%4dns | %8d | %8d |  %2b   | %7b |  %3b   | %8d |  %1b", 
                $time, reg_data1, reg_data2, ALUOp, funct7, funct3, ALU_Result, Zero);
        end
    end

endmodule

