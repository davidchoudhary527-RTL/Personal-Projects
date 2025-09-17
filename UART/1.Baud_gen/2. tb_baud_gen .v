`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.09.2025 23:52:25
// Design Name: 
// Module Name: tb_baud_gen
// Project Name: UART
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_baud_gen;

    // Testbench signals
    reg clk;
    reg reset_n;
    reg [1:0] baud_rate;
    wire baud_clk;

    // DUT instantiation
    baud_gen uut (
        .clk(clk),
        .reset_n(reset_n),
        .baud_rate(baud_rate),
        .baud_clk(baud_clk)
    );

    // Clock generation: 50 MHz → period = 20 ns
    always #10 clk = ~clk;

    // Test procedure
    initial begin

        // Init signals
        clk = 0;
        reset_n = 1;
        baud_rate = 2'b00;

        // Reset pulse
        #50;
        reset_n = 0;

        // Test different baud rates
        #1000000 baud_rate = 2'b00;   // 2400
        #1000000 baud_rate = 2'b01;   // 4800
        #1000000 baud_rate = 2'b10;   // 9600
        #1000000 baud_rate = 2'b11;   // 19200

        // Finish simulation
       #500000;
        $finish;
    end

endmodule

