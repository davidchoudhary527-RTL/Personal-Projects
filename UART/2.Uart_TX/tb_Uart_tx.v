`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.09.2025 23:00:08
// Design Name: 
// Module Name: tb_Uart_tx
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


module tb_Uart_tx();

reg clk ,rst_n , tx_start ;
reg [7:0] data_in;
wire uarttx , tx_busy;

Uart_tx U_uart_tx (
    .clk(clk),
    .rst_n(rst_n),
    .tx_start(tx_start),
    .data(data_in),
    .uarttx(uarttx),
    .tx_busy(tx_busy)
 );
 
 // period 20ns = => 50Mhz
 always #10 clk = ~ clk ;
 
 initial begin
 
    clk = 1'b0;
    rst_n = 1'b1;
    tx_start = 1'b0;
    
    #50 
    rst_n = 1'b0;
    data_in = 8'h55;
    #20 tx_start = 1'b1 ;
    #20 tx_start = 1'b0 ;
    
    #200
    data_in <= 8'hE1;
    #20 tx_start <= 1'b1;
    #20 tx_start <= 1'b0;
    
    #200;
    data_in <= 8'hF0;
    #20 tx_start <= 1'b1;
    #20 tx_start <= 1'b0;
    
    #200 
    $finish;
 end

endmodule
