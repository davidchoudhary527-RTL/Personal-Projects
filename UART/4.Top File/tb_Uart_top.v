`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2025 16:53:49
// Design Name: 
// Module Name: tb_uart_top
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


module tb_uart_top(
    );
    
reg       clk;                             
reg       reset_n;                         
wire      baud_clk;       //baud           
reg [2:0] baud_rate;                       
reg       rx_data_in;             // serial input  
wire      tx;             // serial output                
wire      tx_busy;        // transmitter busy
wire       rx_valid;  
wire [13:0]baud_value;
wire [7:0] rx_data;   
    
    uart_top U_Uart_top (
    .clk(clk),     
    .reset_n(reset_n), 
    .baud_clk(baud_clk),
    .baud_rate(baud_rate),
    .rx(rx_data_in),      
    .tx(tx),      
    .tx_busy(tx_busy),
    .rx_valid(rx_valid),  
    .baud_value(baud_value),
    .rx_data(rx_data)    
);

// 1 MHz baud clock
initial clk = 0;
always #10 clk = ~clk; 

task send_byte(input [7:0] byte);
integer i;
begin
    // Start bit
    @(posedge baud_clk);
    rx_data_in = 0;

    // Data bits
    for (i = 0; i < 8; i=i+1) begin
        @(posedge baud_clk);
        rx_data_in = byte[i];
    end

    // Stop bit
    @(posedge baud_clk);
    rx_data_in = 1;
end
endtask

// Test sequence
initial begin
    reset_n = 0;
    rx_data_in = 1; // idle
    #2000;
    reset_n = 1;
    #1000
    baud_rate = 3'b110;
    #1000;
    $display("[%0t ns] Sending 0xA5", $time);
    send_byte(8'hA5);
    // Wait for 5 rising edges of baud_clk
    repeat (10) @(posedge baud_clk);
    $display("[%0t ns] Sending 0xC3", $time);
    send_byte(8'hC3);
    // Wait for 5 rising edges of baud_clk
    repeat (10) @(posedge baud_clk);
    $display("[%0t ns] Sending 0xD5", $time);
    send_byte(8'hD5);
    #5000;
    $display("[%0t ns] Simulation complete", $time);
    $finish;
end

endmodule
