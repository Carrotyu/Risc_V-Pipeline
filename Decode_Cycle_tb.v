`timescale 1ns / 1ps
module decode_cycle_tb();
    // Inputs
    reg clk;
    reg rst;
    reg [31:0] InstrD;
    reg [31:0] PCD;
    reg [31:0] PCPlus4D;
    reg RegWriteW;
    reg [4:0] RDW;
    reg [31:0] ResultW;
    
    // Outputs
    wire RegWriteE;
    wire ALUSrcE;
    wire MemWriteE;
    wire ResultSrcE;
    wire BranchE;
    wire [2:0] ALUControlE;
    wire [31:0] RD1_E;
    wire [31:0] RD2_E;
    wire [31:0] Imm_Ext_E;
    wire [4:0] RS1_E;
    wire [4:0] RS2_E;
    wire [4:0] RD_E;
    wire [31:0] PCE;
    wire [31:0] PCPlus4E;
    
    // Instantiate DUT
    decode_cycle dut(
        .clk(clk),
        .rst(rst),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RegWriteW(RegWriteW),
        .RDW(RDW),
        .ResultW(ResultW),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .Imm_Ext_E(Imm_Ext_E),
        .RD_E(RD_E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E)
    );
    
    // Clock generation - faster clock to complete quicker
    always begin
        clk = 0; #2.5;
        clk = 1; #2.5;
    end
    
    // Test stimulus with fixed end time
    initial begin
        // Initialize all inputs to zero
        rst = 0;
        InstrD = 32'b0;
        PCD = 32'b0;
        PCPlus4D = 32'b0;
        RegWriteW = 0;
        RDW = 5'b0;
        ResultW = 32'b0;
        
        // Apply reset for 10ns
        #10;
        rst = 1;
        
        // ---- TEST CASE 1: R-type instruction ----
        // add x1, x2, x3
        #5;
        InstrD = 32'h003100B3;
        PCD = 32'h00000000;
        PCPlus4D = 32'h00000004;
        
        // ---- TEST CASE 2: I-type instruction (load) ----
        #5;
        InstrD = 32'h00812203;  // lw x4, 8(x2)
        PCD = 32'h00000004;
        PCPlus4D = 32'h00000008;
        
        // ---- TEST CASE 3: Store instruction ----
        #5;
        InstrD = 32'h00312623;  // sw x3, 12(x2)
        PCD = 32'h00000008;
        PCPlus4D = 32'h0000000C;
        
        // ---- TEST CASE 4: Branch instruction ----
        #5;
        InstrD = 32'h00310863;  // beq x2, x3, 16
        PCD = 32'h0000000C;
        PCPlus4D = 32'h00000010;
        
        // ---- TEST CASE 5: Register writeback ----
        #5;
        RegWriteW = 1;
        RDW = 5'd2;
        ResultW = 32'hAABBCCDD;
        
        // Force end simulation at exactly 50ns
        #20;
        $display("Simulation finished at %0t", $time);
        $finish;
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("decode_cycle_tb.vcd");
        $dumpvars(0, decode_cycle_tb);
    end
    
    // Monitor changes at each clock edge
    always @(posedge clk) begin
        $display("Time=%0t | Instr=%h | RegWrite=%b | ALUControl=%b | Mem=%b",
                 $time, InstrD, RegWriteE, ALUControlE, MemWriteE);
    end
endmodule
