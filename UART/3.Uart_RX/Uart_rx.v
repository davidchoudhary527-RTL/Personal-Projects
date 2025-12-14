`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2025 23:49:05
// Design Name: 
// Module Name: Uart_rx
// Project Name: UART
// Target Devices: ALL XILINX AND QUATRUS FPGAS
// Tool Versions: Vivado 2020.2
// Description: RX_Uart Help to recive uart rx data 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module Uart_rx(
    input  wire baud_clk,     // 1 tick per bit
    input  wire reset_n,      // Active-low reset
    input  wire rx_data_in,   // UART serial input
    output reg  [7:0] rx_data,// Received byte
    output reg  rx_valid      // High for 1 tick when data received
);

    localparam IDLE  = 'b00,
               DATA  = 'b01,
               STOP  = 'b10,
               VALID = 'b11;

    reg [1:0] state;
    reg [2:0] bit_index;
    reg [7:0] rx_shift ;

    always @(posedge baud_clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            bit_index <= 0;
            rx_shift <= 0;
            rx_data <= 0;
            rx_valid <= 0;
        end else begin
            case (state)
                IDLE: begin
                    rx_valid <= 0;
                    bit_index <= 0;
                    if (rx_data_in == 0) // detect start bit
                        state <= DATA;
                end
                
                DATA: begin
                    rx_shift[bit_index] <= rx_data_in; // sample bit
                    if (bit_index == 7) begin
                        bit_index <= 0;
                        state <= STOP;
                    end else
                        bit_index <= bit_index + 1;
                end

                STOP: begin
                    if (rx_data_in == 1)
                        state <= VALID;
                    else
                        state <= IDLE; // framing error
                end

                VALID: begin
                    rx_data <= rx_shift;
                    rx_valid <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule

