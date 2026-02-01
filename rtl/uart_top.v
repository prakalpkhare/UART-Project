module top_uart (
    input clk,
    input rst,
    input wr_enb,
    input [7:0] tx_data,
    input rdy_clr,
    output [7:0] rx_data,
    output rdy
);

  wire tx_enb;
  wire rx_enb;
  wire tx_line;

  baud_rate_generator baud_gen (
    .clk(clk),
    .rst(rst),
    .tx_enb(tx_enb),
    .rx_enb(rx_enb)
  );

  transmitter tx_inst (
    .clk(clk),
    .rst(rst),
    .wr_enb(wr_enb),
    .enb(tx_enb),
    .data_in(tx_data),
    .tx(tx_line),
    .busy()
  );

  uart_receiver rx_inst (
    .clk(clk),
    .rst(rst),
    .rx(tx_line),
    .rx_enb(rx_enb),
    .rdy_clr(rdy_clr),
    .rdy(rdy),
    .data_out(rx_data)
  );

endmodule
