`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2025 16:02:02
// Design Name: 
// Module Name: Uart_top
// Project Name: Uart
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: Uart_tx , Uart_rx , Baud_gen
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  //  All these ratio ticks are calculated for 50MHz Clock,
        //  The values shall change with the change of the clock frequency.
     /* 
        BAUD24 : BAUD_value = 000 
        BAUD48 : BAUD_value = 001
        BAUD96 : BAUD_value = 002
        BAUD192 : BAUD_value = 003
        BAUD384 : BAUD_value = 004
        BAUD560 : BAUD_value = 005
        BAUD1280 : BAUD_value = 006
     */
//////////////////////////////////////////////////////////////////////////////////


module uart_top (
    input             clk,
    input             reset_n,
    output wire       baud_clk,       //baud 
    input       [2:0] baud_rate,
    input             rx,             // serial input
    output wire       tx,             // serial output
    output wire       tx_busy,        // transmitter busy
    output wire       rx_valid,  
    output wire [13:0]baud_value,
    output wire [7:0] rx_data   
);



//wire        rx_valid;
//wire [13:0] baud_value;
//wire [7:0]  rx_data;


baud_gen buad_gen_instance
(
     .clk(clk),
     .reset_n(reset_n),
     .baud_rate(baud_rate),
     .baud_clk(baud_clk),
     .BAUD_DIV(baud_value)
);

Uart_rx uart_rx_instance
(
    .baud_clk(baud_clk),     
    .reset_n(reset_n),      
    .rx_data_in(rx),   
    .rx_data(rx_data), 
    .rx_valid(rx_valid)      
);

Uart_tx uart_tx_instance
(
      .clk(baud_clk) ,
      .rst_n(reset_n)  ,
      .tx_start(rx_valid) ,
      .data(rx_data) ,
      .uarttx(tx) ,
      .tx_busy(tx_busy)
);

endmodule
