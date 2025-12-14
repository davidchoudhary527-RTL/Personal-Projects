`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.09.2025 23:36:11
// Design Name: 
// Module Name: baud_gen
// Project Name: UART-VERILOG
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
// Can Only be used with clk of 50Mhz 
//////////////////////////////////////////////////////////////////////////////////
module baud_gen(
    input  wire clk,
    input  wire reset_n,
    input wire  [2:0]  baud_rate,
    output reg  baud_clk,
    output [13:0] BAUD_DIV
    );
     
//  Internal declarations
reg [13 : 0] clock_ticks;
reg [13 : 0] final_value;

//  Encoding for the Baud Rates states
localparam BAUD24  = 2'b00,
           BAUD48  = 2'b01,
           BAUD96  = 2'b10,
           BAUD192 = 2'b11,
           BAUD384 = 3'b100,
           BAUD560 = 3'b101,
           BAUD1280 = 3'b110;

//  BaudRate 4-1 Mux
always @(baud_rate)
begin
    case (baud_rate)
        //  All these ratio ticks are calculated for 50MHz Clock,
        //  The values shall change with the change of the clock frequency.
        BAUD24 : final_value = 14'd3906;  //  ratio ticks for the 2400 BaudRate.
        BAUD48 : final_value = 14'd1953;   //  ratio ticks for the 4800 BaudRate.
        BAUD96 : final_value = 14'd977;   //  ratio ticks for the 9600 BaudRate.
        BAUD192 : final_value = 14'd488;  //  ratio ticks for the 19200 BaudRate.
        BAUD384 : final_value = 14'd244;  //  ratio ticks for the 19200 BaudRate.
        BAUD560 : final_value = 14'd488;  //  ratio ticks for the 19200 BaudRate.
        BAUD1280 : final_value = 14'd73;  //  ratio ticks for the 19200 BaudRate
        default: final_value = 14'd0;      //  The systems original Clock.
    endcase
end

//  Timer logic
always @( posedge clk or negedge reset_n)
begin
    if(!reset_n)
    begin
        clock_ticks <= 14'd0; 
        baud_clk    <= 1'b0; 
    end
    else
    begin
        //  Ticks whenever reaches its final value,
        //  Then resets and starts all over again.
        if (clock_ticks == final_value)
        begin
            clock_ticks <= 14'd0; 
            baud_clk    <= ~baud_clk; 
        end 
        else
        begin
            clock_ticks <= clock_ticks + 14'd1;
            baud_clk    <= baud_clk;
        end
    end 
end

assign BAUD_DIV = final_value ;
endmodule
