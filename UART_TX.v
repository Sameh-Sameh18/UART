module UART_TX (clk,rst,TX_data,transmit,busy,TxD);

	parameter D_WIDTH = 8;
	localparam IDLE=0 , START=1 , DATA=2 , PARITY=3 , STOP=4;

	input clk,rst,transmit;
	input [D_WIDTH-1 : 0] TX_data;
	output reg busy,TxD;

	reg [2:0] state,bit_counter;
	reg parity_bit;
	reg [D_WIDTH-1 : 0] TX_data_reg;
	wire parity_calc;

	assign parity_calc = ^ TX_data; // even parity

	always @(posedge clk) begin
		if(rst) begin
			state <= IDLE;
			bit_counter <= 0;
			parity_bit <= 0;
			TX_data_reg <= 0;
			TxD <= 1; // high stay in idle as the start bit is 0
			busy <= 0;

		end else begin
			case (state)

				IDLE : begin
					TxD <= 1;
					busy <= 0;
					if (transmit) begin
						state <= START;
						TX_data_reg <= TX_data;
						parity_bit <= parity_calc;
					end
				end

				START : begin
					TxD <= 0; // start bit
					state <= DATA;
					bit_counter <= 0;
					busy <= 1;
				end

				DATA : begin
					TxD <= TX_data_reg[bit_counter];

					if (bit_counter == 7)
						state <= PARITY;
					else
						bit_counter <= bit_counter + 1;
				end

				PARITY : begin
					TxD <= parity_bit;
					state <= STOP;
				end

				STOP : begin
					TxD <= 1; // stop bit
					state <= IDLE;
					busy <= 0;
				end

				default : state <= IDLE;
			endcase
		end
	end

endmodule : UART_TX