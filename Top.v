module Top (clk,rst,TX_data,transmit,TxD,Rx_Data,busy,valid_rx,parity_error,stop_error);

	input clk,rst,transmit;          
    input [7:0] TX_data; 
    output TxD,busy,valid_rx,parity_error,stop_error; 
    output [7:0] Rx_Data; 

    wire RX_tick, TX_tick;
    wire RxD;

    // Baud Rate Generator
    Buad_Rate #(.CLK_FREQ(50_000_000),.BUAD_RATE(9600)) baud_gen (.clk(clk),.rst(rst),.RX_tick(RX_tick),.TX_tick(TX_tick));

    // Transmitter
    UART_TX #(.D_WIDTH(8)) tx_module (.clk(TX_tick),.rst(rst),.TX_data(TX_data),.transmit(transmit),.busy(busy),.TxD(TxD));

    // Receiver
    UART_RX #(.WIDTH(8)) rx_module (.clk(RX_tick),.rst(rst),.RxD(TxD),.Rx_Data(Rx_Data),
    	      .valid_rx(valid_rx),.parity_error(parity_error),.stop_error(stop_error));

endmodule