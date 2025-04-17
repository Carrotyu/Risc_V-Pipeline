`timescale 1ns / 1ps
module execute_cycle_tb;
    // Inputs
    reg clk, rst;
    reg RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    reg [2:0] ALUControlE;
    reg [31:0] RD1_E, RD2_E, Imm_Ext_E;
    reg [4:0] RD_E;
    reg [31:0] PCE, PCPlus4E;
    reg [31:0] ResultW;
    reg [1:0] ForwardA_E, ForwardB_E;
    
    // Outputs
    wire PCSrcE, RegWriteM, MemWriteM, ResultSrcM;
    wire [4:0] RD_M;
    wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM, PCTargetE;
    
    // Instantiate the Unit Under Test (UUT)
    execute_cycle uut (
        .clk(clk),
        .rst(rst),
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
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM),
        .ResultW(ResultW),
        .ForwardA_E(ForwardA_E),
        .ForwardB_E(ForwardB_E)
    );
    
    // Clock generation - using 5ns period for faster simulation
    always begin
        clk = 0; #2.5;
        clk = 1; #2.5;
    end
    
    // Test sequence
    initial begin
        // Dump waveforms
        $dumpfile("execute_cycle.vcd");
        $dumpvars(0, execute_cycle_tb);
        
        // Initialize all inputs
        rst = 0;
        RegWriteE = 0;
        ALUSrcE = 0;
        MemWriteE = 0;
        ResultSrcE = 0;
        BranchE = 0;
        ALUControlE = 3'b000;
        RD1_E = 0;
        RD2_E = 0;
        Imm_Ext_E = 0;
        RD_E = 0;
        PCE = 0;
        PCPlus4E = 0;
        ResultW = 0;
        ForwardA_E = 2'b00;
        ForwardB_E = 2'b00;
        
        // Apply reset for 10ns
        #10;
        rst = 1;
        
        // --- TEST CASE 1: ADD operation ---
        #5;
        RegWriteE = 1;
        ALUSrcE = 0;
        ALUControlE = 3'b000; // ADD
        RD1_E = 32'd5;
        RD2_E = 32'd3;
        RD_E = 5'd1;
        PCPlus4E = 32'h00000004;
        
        // --- TEST CASE 2: SUB operation ---
        #5;
        ALUControlE = 3'b001; // SUB
        RD1_E = 32'd8;
        RD2_E = 32'd3;
        RD_E = 5'd2;
        PCPlus4E = 32'h00000008;
        
        // --- TEST CASE 3: LOAD operation (address calculation) ---
        #5;
        ALUControlE = 3'b000; // ADD for address calculation
        ALUSrcE = 1;          // Use immediate
        ResultSrcE = 1;       // Memory result
        RD1_E = 32'd16;       // Base address
        Imm_Ext_E = 32'd4;    // Offset
        RD_E = 5'd3;
        PCPlus4E = 32'h0000000C;
        
        // --- TEST CASE 4: STORE operation ---
        #5;
        MemWriteE = 1;        // Write to memory
        RegWriteE = 0;        // No register write
        RD1_E = 32'd20;       // Base address
        RD2_E = 32'hAABBCCDD; // Data to store
        Imm_Ext_E = 32'd8;    // Offset
        PCPlus4E = 32'h00000010;
        
        // --- TEST CASE 5: BEQ (branch taken) ---
        #5;
        ALUControlE = 3'b001; // SUB for comparison
        BranchE = 1;          // Branch enabled
        ALUSrcE = 0;          // Use register
        MemWriteE = 0;        // No memory write
        RD1_E = 32'd100;
        RD2_E = 32'd100;      // Equal values -> Zero=1
        PCE = 32'd200;
        Imm_Ext_E = 32'd16;   // Branch offset
        PCPlus4E = 32'h00000014;
        
        // --- TEST CASE 6: BEQ (branch not taken) ---
        #5;
        RD1_E = 32'd100;
        RD2_E = 32'd101;      // Not equal -> Zero=0
        
        // --- TEST CASE 7: Forwarding test (ForwardA) ---
        #5;
        ALUControlE = 3'b000; // ADD
        BranchE = 0;
        ALUSrcE = 0;
        ForwardA_E = 2'b01;   // Forward from ResultW
        ResultW = 32'h12345678;
        RD2_E = 32'd1;
        
        // --- TEST CASE 8: Forwarding test (ForwardB) ---
        #5;
        ForwardA_E = 2'b00;   // No forwarding for A
        ForwardB_E = 2'b10;   // Forward from ALU_ResultM
        RD1_E = 32'd2;
        
        // End the simulation after 50ns total
        #5;
        $display("Simulation finished at %0t", $time);
        $finish;
    end
    
    // Monitor important signals
    initial begin
        $monitor("Time=%0t | ALUResultM=%h | PCSrcE=%b | RegWriteM=%b | ForwardA=%b ForwardB=%b", 
                 $time, ALU_ResultM, PCSrcE, RegWriteM, ForwardA_E, ForwardB_E);
    end
endmodule
