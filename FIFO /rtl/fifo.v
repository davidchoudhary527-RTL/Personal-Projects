module fifo #(
    parameter WIDTH  = 8,                            //Data width of FIFO (default: 8 bits).
    parameter DEPTH  = 16,                           //Number of FIFO entries (must be power of 2).
    parameter ADDR_W = $clog2(DEPTH),
    parameter AFULL  = DEPTH-2,
    parameter AEMPTY = 2
)(
    input  wire                 clk,
    input  wire                 rst_n,

    input  wire                 in_valid,            //Valid data input ready to send
    input  wire [WIDTH-1:0]     in_data,             //Input data
    output wire                 in_ready,            //Indicates FIFO can accept new data (FIFO not full).

    input  wire                 out_ready,           //Indicates downstream logic is ready to accept data.
    output wire                 out_valid,           //Indicates FIFO has valid data available for reading.(fifo not empty)
    output wire [WIDTH-1:0]     out_data,            //Data read from FIFO when out_valid and out_ready are high.

    output wire                 almost_full,         //Asserted when FIFO is close to full (programmable threshold).
    output wire                 almost_empty,        //Asserted when FIFO is close to empty (programmable threshold).
    output wire                 rd_en, 
    output wire                 wr_en
   
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_W-1:0] wr_ptr, rd_ptr;
    reg [ADDR_W:0]   count;

    assign wr_en = in_valid  && in_ready;
    assign rd_en = out_valid && out_ready;

    assign in_ready  = (count < DEPTH);
    assign out_valid = (count > 0);
    assign out_data = (wr_en && rd_en && (wr_ptr == rd_ptr)) ? in_data : mem[rd_ptr];       //THIS will over come the issue of read while writing in same cycle

    assign almost_full  = (count >= AFULL);
    assign almost_empty = (count <= AEMPTY);

    //---------------- WRITE ----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en) begin
            mem[wr_ptr] <= in_data;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    //---------------- READ -----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr     <= 0;
        end 
        else if (rd_en) begin
                rd_ptr <= rd_ptr + 1'b1 ;
                end
    end

    //---------------- COUNT ----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end else begin
            case ({wr_en, rd_en})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase
        end
    end

endmodule
