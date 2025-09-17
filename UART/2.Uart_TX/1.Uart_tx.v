`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.09.2025 18:33:20
// Design Name: 
// Module Name: Uart_tx
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
module Uart_tx(
input            clk , rst_n ,tx_start,
input      [7:0] data ,
output reg       uarttx , tx_busy
    );
    
    localparam IDLE  = 3'd0,
               START = 3'd1,
               DATA  = 3'd2,
               STOP  = 3'd3;
               
    reg [1 : 0] state ;
    integer  i;
    
    always @(posedge clk or negedge rst_n )
    begin
        if(rst_n)
        begin
            state   <= IDLE;
            uarttx  <= 1'b1;
            tx_busy <= 1'b0;
        end
        else
        begin
            case (state) 
                    IDLE  : state <= START ; 
                    START :begin
                                if(tx_start)
                                begin
                                    state <= DATA ;
                                    tx_busy <= 1'b1 ;
                                    uarttx <= 1'b0;
                                    i <= 4'd0;
                                end
                                else
                                    state <= START;
                           end
                    DATA : begin
                                    uarttx <= data[7-i] ;
                                    tx_busy <= 1'b1 ;
                                    if( i == 4'd7 )
                                    begin 
                                         state <= STOP ;
                                         i = 4'd0;
                                    end 
                                    else
                                    begin
                                         state <= DATA ;
                                         i = i+1 ;
                                    end
                           end
                    STOP : begin
                                 uarttx <= 1'd1;
                                 tx_busy <='b0 ; 
                                 state <= IDLE ;
                           end
              endcase
           end
      end
                                                                                                          
                                    
    
    
endmodule
