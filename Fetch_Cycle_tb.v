module fetch_tb();

    // Define test signals
    reg clk;
    reg rst;
    reg PCSrcE;
    reg [31:0] PCTargetE;
    wire [31:0] InstrD;
    wire [31:0] PCD, PCPlus4D;

    // Instantiate the DUT
    fetch_cycle DUT (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // Clock generation: 100MHz = 10ns period
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

    // Simulation control
    initial begin
        // Initialize
        rst = 0;
        PCSrcE = 0;
        PCTargetE = 32'h00000000;

        // ===== Test Case 1: Reset =====
        #20;
        rst = 1;

        // ===== Test Case 2: Normal sequential PC (PC+4) =====
        #40;

        // ===== Test Case 3: Branch to 0x20 =====
        PCSrcE = 1;
        PCTargetE = 32'h00000020;
        #10;

        // ===== Test Case 4: Back to PC+4 =====
        PCSrcE = 0;
        #40;

        // ===== Test Case 5: Branch to 0x40 =====
        PCSrcE = 1;
        PCTargetE = 32'h00000040;
        #10;
        PCSrcE = 0;
        #30;

        // ===== Test Case 6: Mid-run Reset =====
        rst = 0;
        #10;
        rst = 1;
        #30;

        // End simulation
        #50;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | rst=%b | PCSrcE=%b | PCTargetE=%h | InstrD=%h | PCD=%h | PCPlus4D=%h",
                 $time, rst, PCSrcE, PCTargetE, InstrD, PCD, PCPlus4D);
    end

    // Dump waves
    initial begin
        $dumpfile("fetch_tb.vcd");
        $dumpvars(0, fetch_tb);
    end

endmodule

