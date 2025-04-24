`timescale 1ns / 1ps

module tb_program_counter;

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] pc_in;

    // Outputs
    wire [31:0] pc_out;

    // Instantiate the Unit Under Test (UUT)
    program_counter uut (
        .clk(clk), 
        .rst(rst), 
        .pc_in(pc_in), 
        .pc_out(pc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        $display("Time\tclk\trst\tpc_in\t\tpc_out");
        $monitor("%g\t%b\t%b\t%h\t%h", $time, clk, rst, pc_in, pc_out);

        // Initialize inputs
        rst = 1;
        pc_in = 32'h00000000;

        // Hold reset for a few cycles
        #12;
        rst = 0;

        // Apply pc_in values
        #10 pc_in = 32'h00000004;
        #10 pc_in = 32'h00000008;
        #10 pc_in = 32'h0000000C;

        // Trigger reset in between
        #10 rst = 1;
        #10 rst = 0;

        // Apply more values
        #10 pc_in = 32'h00000010;
        #10 pc_in = 32'h00000014;

        // Finish simulation
        #20;
        $finish;
    end

endmodule

