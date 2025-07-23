module UART_RX (clk,rst,RxD,Rx_Data,valid_rx,parity_error,stop_error);

	parameter WIDTH = 8;
	localparam IDLE=0 , START=1 , DATA=2 , PARITY=3 , STOP=4;

	input clk,rst,RxD;
	output reg valid_rx,parity_error,stop_error;
	output reg [WIDTH-1 : 0] Rx_Data;

	reg [2:0] state;
	reg [WIDTH-1 : 0] Rx_Data_reg;
	reg [2:0] bit_counter;
	reg parity_check,parity_bit;
	reg [3:0] sample_count;

	always @(posedge clk) begin
		if(rst) begin
			state <= IDLE;
			Rx_Data <= 0;
			Rx_Data_reg <= 0;
			valid_rx <= 0;
			parity_error <= 0;
			stop_error <= 0;
			parity_check <= 0;
			parity_bit <= 0;
			bit_counter <= 0;

		end else begin
			case (state)
				IDLE : begin
					valid_rx <= 0;
					parity_error <= 0;
					stop_error <= 0;
					if (RxD == 0) begin // start bit
						state <= START;
						sample_count <= 0;
						bit_counter <= 0;
						parity_check <= 0;
					end
				end

				START : begin
					if (sample_count == 7) begin
						sample_count <= 0;
						state <= DATA;
					end else
						sample_count <= sample_count + 1;
				end

				DATA : begin
					if (sample_count == 15) begin
						Rx_Data_reg [bit_counter] <= RxD;
						parity_check <= parity_check ^ RxD;
						sample_count <= 0;
						if (bit_counter == 7)
							state <= PARITY;
						else
							bit_counter <= bit_counter + 1;
					end else
						sample_count <= sample_count + 1;
				end


				PARITY : begin
					if (sample_count == 15) begin
						parity_bit <= RxD;
						state <= STOP;
						sample_count <= 0;
					end else begin
						sample_count <= sample_count + 1;
					end
				end


				STOP : begin
					if (sample_count == 15) begin
						if (RxD == 1) begin
							Rx_Data <= Rx_Data_reg;
							valid_rx <= 1;
							parity_error <= (parity_check != parity_bit);
							stop_error <= 0;
						end else begin
							stop_error <= 1;
							parity_error <= (parity_bit != parity_check);
						end
						state <= IDLE;
					end else begin
						sample_count <= sample_count + 1;
					end
				end


				default : state <= IDLE;
			endcase
		end
	end

endmodule : UART_RX