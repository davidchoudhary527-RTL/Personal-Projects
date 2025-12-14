`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2025 23:15:28
// Design Name: 
// Module Name: tb_uart_rx
// Project Name: 
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
`timescale 1ns / 1ps
module tb_uart_rx;

reg baud_clk, rst_n;
reg rx_data_in;
wire [7:0] rx_data;
wire rx_valid;


Uart_rx U_Uart_rx (
    .baud_clk(baud_clk),
    .reset_n(rst_n),
    .rx_data_in(rx_data_in),
    .rx_data(rx_data),
    .rx_valid(rx_valid)
);

// 1 MHz baud clock
initial baud_clk = 0;
always #500 baud_clk = ~baud_clk; // 1 µs period

// Monitor received bytes
always @(posedge baud_clk) begin
    if (rx_valid)
        $display("[%0t ns] Received: %02X", $time, rx_data);
end

// UART send task
task send_byte(input [7:0] byte);
integer i;
begin
    // Start bit
    rx_data_in = 0;
    #1000; // 1 bit period
    
    // Data bits (LSB first)
    for (i = 0; i < 8; i=i+1) begin
        rx_data_in = byte[i];
        #1000;
    end

    // Stop bit
    rx_data_in = 1;
    #1000;
end
endtask

// Test sequence
initial begin
    rst_n = 0;
    rx_data_in = 1; // idle
    #2000;
    rst_n = 1;

    #1000;
    $display("[%0t ns] Sending 0xA5", $time);
    send_byte(8'hA5);

    #2000;
    $display("[%0t ns] Sending 0xC3", $time);
    send_byte(8'hC3);
    #2000;
    $display("[%0t ns] Sending 0xC3", $time);
    send_byte(8'hD5);
    #5000;
    $display("[%0t ns] Simulation complete", $time);
    $finish;
end

endmodule

