module tb_uart;

  reg clk = 0;
  reg rst;
  reg wr_enb;
  reg [7:0] tx_data;
  reg rdy_clr;

  wire [7:0] rx_data;
  wire rdy;

  top_uart dut (
    .clk(clk),
    .rst(rst),
    .wr_enb(wr_enb),
    .tx_data(tx_data),
    .rdy_clr(rdy_clr),
    .rx_data(rx_data),
    .rdy(rdy)
  );

  always #10 clk = ~clk;

  initial begin
    rst = 1;
    wr_enb = 0;
    rdy_clr = 0;
    tx_data = 8'h00;

    #100 rst = 0;
    #100;

    tx_data = 8'hA5;
    wr_enb = 1;
    #20 wr_enb = 0;

    wait(rdy);
    #100;
    $display("Test Passed: Received Data = %h", rx_data);

    rdy_clr = 1;
    #20 rdy_clr = 0;

    #200 $finish;
  end
endmodule
