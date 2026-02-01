module baud_rate_generator (
    input  clk,
    input  rst,
    output tx_enb, 
    output rx_enb 
);

  reg [12:0] tx_counter;
  reg [9:0]  rx_counter;

  
  always @(posedge clk) begin
    if (rst)
      tx_counter <= 13'd0;
    else if (tx_counter == 13'd5207)
      tx_counter <= 13'd0;
    else
      tx_counter <= tx_counter + 1'b1;
  end

  always @(posedge clk) begin
    if (rst)
      rx_counter <= 10'd0;
    else if (rx_counter == 10'd324)
      rx_counter <= 10'd0;
    else
      rx_counter <= rx_counter + 1'b1;
  end

  // Enable pulses
  assign tx_enb = (tx_counter == 13'd0);
  assign rx_enb = (rx_counter == 10'd0);

endmodule
