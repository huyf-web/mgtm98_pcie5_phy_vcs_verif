module FIFO(
    input reset_n,
    input [511:0] data_in,
    input wr,
    input rd,
    input [63:0] wr_valid,
    input pclk,
    input [63:0] STP_IN,
    input [63:0] SDP_IN,
    input [63:0] END_IN,
    output empty,
    output full,
    output [511:0] data_out,
    output [63:0] STP_OUT,
    output [63:0] SDP_OUT,
    output [63:0] END_OUT,
    output [63:0] rd_valid
);

wire [79:0] length_out_unused;

FIFOV2 u_fifo_v2 (
    .reset_n(reset_n),
    .data_in(data_in),
    .wr(wr),
    .rd(rd),
    .wr_valid(wr_valid),
    .pclk(pclk),
    .STP_IN(STP_IN),
    .SDP_IN(SDP_IN),
    .END_IN(END_IN),
    .length_in(80'b0),
    .length_out(length_out_unused),
    .empty(empty),
    .full(full),
    .data_out(data_out),
    .STP_OUT(STP_OUT),
    .SDP_OUT(SDP_OUT),
    .END_OUT(END_OUT),
    .rd_valid(rd_valid)
);

endmodule
