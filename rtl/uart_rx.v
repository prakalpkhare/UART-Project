module uart_receiver (
    input        clk,
    input        rst,
    input        rx,
    input        rdy_clr,
    input        rx_enb,          
    output reg   rdy,
    output reg [7:0] data_out
);

  parameter start_state    = 2'b00;
  parameter data_out_state = 2'b01;
  parameter stop_state     = 2'b10;

  reg [1:0] state;
  reg [3:0] sample;        
  reg [2:0] index;        
  reg [7:0] shift_register; 

  always @(posedge clk) begin
    if (rst) begin
      state          <= start_state;
      sample         <= 4'd0;
      index          <= 3'd0;
      shift_register <= 8'd0;
      data_out       <= 8'd0;
      rdy            <= 1'b0;
    end
    else begin
      if (rdy_clr)
        rdy <= 1'b0;

      if (rx_enb) begin
        case (state)
          start_state: begin
            sample <= 4'd0;
            index  <= 3'd0;
            if (rx == 1'b0) begin
              sample <= sample + 1'b1;
              if (sample == 4'd7) begin
                state  <= data_out_state;
                sample <= 4'd0;
              end
            end
          end

          data_out_state: begin
            sample <= sample + 1'b1;
            if (sample == 4'd8) begin
              shift_register[index] <= rx;
              index <= index + 1'b1;
            end
            if (index == 3'd7 && sample == 4'd15) begin
              sample <= 4'd0;
              state  <= stop_state;
            end
          end

          stop_state: begin
            sample <= sample + 1'b1;
            if (sample == 4'd15) begin
              data_out <= shift_register;
              rdy      <= 1'b1;
              sample   <= 4'd0;
              state    <= start_state;
            end
          end

          default: state <= start_state;
        endcase
      end
    end
  end
endmodule
