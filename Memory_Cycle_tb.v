module memory_cycle_tb();
    // Inputs
    reg clk;
    reg rst;
    reg RegWriteM;
    reg MemWriteM;
    reg ResultSrcM;
    reg [4:0] RD_M;
    reg [31:0] PCPlus4M;
    reg [31:0] WriteDataM;
    reg [31:0] ALU_ResultM;

    // Outputs
    wire RegWriteW;
    wire ResultSrcW;
    wire [4:0] RD_W;
    wire [31:0] PCPlus4W;
    wire [31:0] ALU_ResultW;
    wire [31:0] ReadDataW;

    // Instantiate memory_cycle module
    memory_cycle dut (
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .RD_W(RD_W),
        .PCPlus4W(PCPlus4W),
        .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW)
    );

    // Clock generation
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        rst = 0;
        RegWriteM = 0;
        MemWriteM = 0;
        ResultSrcM = 0;
        RD_M = 0;
        PCPlus4M = 0;
        WriteDataM = 0;
        ALU_ResultM = 0;

        // Assert reset for 100ns
        #100;
        rst = 1;

        // Test case 1: Memory Write Operation
        #10;
        ALU_ResultM = 32'h00000004;    // Memory address 4
        WriteDataM = 32'h12345678;     // Data to write
        RD_M = 5'd2;                   // Destination register
        MemWriteM = 1'b1;              // Enable memory write
        RegWriteM = 1'b1;              // Enable register write
        ResultSrcM = 1'b0;             // Select ALU result (not memory data)
        PCPlus4M = 32'h00000008;       // PC + 4
        #20;

        // Test case 2: Memory Read Operation
        #10;
        ALU_ResultM = 32'h00000004;    // Memory address 4 (read from same address)
        MemWriteM = 1'b0;              // Disable memory write
        ResultSrcM = 1'b1;             // Select memory data for writeback
        RD_M = 5'd3;                   // Destination register
        PCPlus4M = 32'h0000000C;       // PC + 4
        #20;

        // Test case 3: ALU Result Pass-through
        #10;
        ALU_ResultM = 32'hABCDEF00;    // ALU result
        MemWriteM = 1'b0;              // Disable memory write
        ResultSrcM = 1'b0;             // Select ALU result for writeback
        RegWriteM = 1'b1;              // Enable register write
        RD_M = 5'd4;                   // Destination register
        PCPlus4M = 32'h00000010;       // PC + 4
        #20;

        // Test case 4: Multiple Memory Write Operations
        #10;
        ALU_ResultM = 32'h00000008;    // Memory address 8
        WriteDataM = 32'h87654321;     // Data to write
        MemWriteM = 1'b1;              // Enable memory write
        ResultSrcM = 1'b0;             // Select ALU result
        RD_M = 5'd5;                   // Destination register
        PCPlus4M = 32'h00000014;       // PC + 4
        #20;

        // Test case 5: Multiple Memory Read Operations
        #10;
        ALU_ResultM = 32'h00000008;    // Read from address 8
        MemWriteM = 1'b0;              // Disable memory write
        ResultSrcM = 1'b1;             // Select memory data
        RD_M = 5'd6;                   // Destination register
        PCPlus4M = 32'h00000018;       // PC + 4
        #20;

        // Test case 6: Reset during operation
        #10;
        ALU_ResultM = 32'h0000000C;    // Memory address 12
        WriteDataM = 32'hAABBCCDD;     // Data to write
        MemWriteM = 1'b1;              // Enable memory write
        rst = 1'b0;                    // Assert reset
        #20;
        rst = 1'b1;                    // De-assert reset
        #20;

        // End simulation
        #100;
        $finish;
    end

    // Generate VCD file
    initial begin
        $dumpfile("memory_cycle.vcd");
        $dumpvars(0, memory_cycle_tb);
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t rst=%b RegWrite=%b MemWrite=%b ResultSrc=%b RD=%d ALU_Result=%h WriteData=%h ReadData=%h",
                 $time, rst, RegWriteM, MemWriteM, ResultSrcM, RD_M, ALU_ResultM, WriteDataM, ReadDataW);
    end

endmodule