module Buad_Rate (clk,rst,RX_tick,TX_tick);

	parameter CLK_FREQ = 50_000_000; // 50 MHz
	parameter BUAD_RATE = 9600;

	localparam TX_DIV = CLK_FREQ / (BUAD_RATE * 2);
	localparam RX_DIV = CLK_FREQ / (BUAD_RATE * 16 * 2);

	input clk,rst;
	output reg RX_tick,TX_tick;

	reg [15:0] tx_count , rx_count;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			tx_count <= 0;
			rx_count <= 0;
			RX_tick <= 0;
			TX_tick <= 0;
		end else begin
			if (tx_count == TX_DIV - 1) begin
				tx_count <= 0;
				TX_tick <= ~ TX_tick;
			end else begin
				tx_count <= tx_count + 1;
			end

			if (rx_count == RX_DIV-1) begin
				rx_count <= 0;
				RX_tick <= ~ RX_tick;
			end else begin
				rx_count <= rx_count + 1;
			end
		end
	end

endmodule : Buad_Rate