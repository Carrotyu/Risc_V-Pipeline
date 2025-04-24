`timescale 1ns / 1ps

module tb_ALU_MUX;

    // Inputs
    reg [31:0] input0;   // e.g., register value
    reg [31:0] input1;   // e.g., immediate value
    reg select;          // ALUSrc signal

    // Output
    wire [31:0] out;

    // Instantiate the ALU MUX (MUX2to1)
    MUX2to1 uut (
        .input0(input0),
        .input1(input1),
        .select(select),
        .out(out)
    );

    initial begin
        $display("Time\tselect\tinput0\t\tinput1\t\tout");
        $monitor("%g\t%b\t%h\t%h\t%h", $time, select, input0, input1, out);

        // Test case 1: select = 0 (use register value)
        input0 = 32'h000000A5;  // Register value
        input1 = 32'h12345678;  // Immediate value
        select = 0;  // Should output input0
        #10;

        // Test case 2: select = 1 (use immediate value)
        select = 1;  // Should output input1
        #10;

        // Test case 3: change both inputs
        input0 = 32'hDEADBEEF;
        input1 = 32'h00000010;
        select = 0;  // Expect input0
        #10;

        select = 1;  // Expect input1
        #10;

        // Edge case: both inputs same
        input0 = 32'hCAFEBABE;
        input1 = 32'hCAFEBABE;
        select = 0;  #10;
        select = 1;  #10;

        $finish;
    end

endmodule

