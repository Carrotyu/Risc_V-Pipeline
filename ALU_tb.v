`timescale 1ns / 1ps

module tb_ALU;

    // Inputs
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] ALUcontrol_In;

    // Outputs
    wire [31:0] Result;
    wire Zero;

    // Instantiate the Unit Under Test (UUT)
    ALU uut (
        .A(A),
        .B(B),
        .ALUcontrol_In(ALUcontrol_In),
        .Result(Result),
        .Zero(Zero)
    );

    // Stimulus
    initial begin
        $display("Time\tALUctl\tA\t\tB\t\tResult\t\tZero");
        $monitor("%g\t%b\t%h\t%h\t%h\t%b", $time, ALUcontrol_In, A, B, Result, Zero);

        // ADD
        A = 32'd10; B = 32'd5; ALUcontrol_In = 4'b0000; #10;

        // SUB
        A = 32'd10; B = 32'd10; ALUcontrol_In = 4'b0001; #10;

        // AND
        A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALUcontrol_In = 4'b0010; #10;

        // OR
        A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALUcontrol_In = 4'b0011; #10;

        // XOR
        A = 32'hAAAAAAAA; B = 32'h55555555; ALUcontrol_In = 4'b0100; #10;

        // SLL (Shift Left Logical)
        A = 32'h00000001; B = 32'd4; ALUcontrol_In = 4'b0101; #10;

        // SRL (Shift Right Logical)
        A = 32'h00000010; B = 32'd2; ALUcontrol_In = 4'b0110; #10;

        // SRA (Shift Right Arithmetic)
        A = -32'sd16; B = 32'd2; ALUcontrol_In = 4'b0111; #10;

        // SLT (Set Less Than, signed comparison)
        A = -32'sd5; B = 32'd3; ALUcontrol_In = 4'b1000; #10;
        A = 32'd7; B = 32'd8; ALUcontrol_In = 4'b1000; #10;
        A = 32'd9; B = 32'd8; ALUcontrol_In = 4'b1000; #10;

        // Unknown operation (default case)
        A = 32'd1; B = 32'd1; ALUcontrol_In = 4'b1111; #10;

        $finish;
    end

endmodule

