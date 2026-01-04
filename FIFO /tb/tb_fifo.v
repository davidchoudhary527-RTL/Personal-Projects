`timescale 1ns / 1ps
module tb_fifo();

  localparam WIDTH = 8;
  localparam DEPTH = 16;

  reg                clk, rst_n;
  reg                in_valid;
  reg   [WIDTH-1:0]  in_data;
  wire               in_ready;

  wire               out_valid;
  wire [WIDTH-1:0]   out_data;
  reg                out_ready;
  wire               almost_full ;
  wire               almost_empty ;
  wire               wr_en ,rd_en ;

  fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dut (
    .clk(clk), 
    .rst_n(rst_n),
    .in_valid(in_valid), 
    .in_data(in_data), 
    .in_ready(in_ready),
    .out_valid(out_valid),
    .out_ready(out_ready),
    .rd_en(rd_en) ,
    .wr_en(wr_en) , 
    .out_data(out_data),
    .almost_full(almost_full) , 
    .almost_empty(almost_empty)  
  );

  // Reference model
  reg [WIDTH-1:0] ref_q [0:DEPTH-1];
  integer head, tail, count;

  // Clock
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst_n = 0;
    in_valid = 0;
    out_ready = 0;
    head = 0; tail = 0; count = 0 ;

    #20 rst_n = 1;

    repeat (50) begin
      @(negedge clk);

      // Randomize handshakes
      in_valid  = $random % 2;
      out_ready = $random % 2;
      in_data   = $random;

      // Reference write
      if (in_valid && in_ready) begin
        ref_q[tail] = in_data;
        tail = (tail + 1) % DEPTH;
        count = count + 1;
      end

      // Reference read & check
      if (out_valid && out_ready) begin
        if (out_data !== ref_q[head]) begin                                                        //SELF CHECKING MODAL
          $display("ERROR: Expected %0h, got %0h", ref_q[head], out_data);
          $finish;
        end
        head = (head + 1) % DEPTH;
        count = count - 1;
      end
    end

    $display("TEST PASSED");
    $finish;
  end

endmodule
