`timescale 1ns / 1ps

module Top_tb();

    reg clk, rst, transmit;
    reg [7:0] TX_data;
    wire TxD, busy, valid_rx, parity_error, stop_error;
    wire [7:0] Rx_Data;

    Top dut (.clk(clk),.rst(rst),.TX_data(TX_data),.transmit(transmit),.TxD(TxD),.Rx_Data(Rx_Data),
             .busy(busy),.valid_rx(valid_rx),.parity_error(parity_error),.stop_error(stop_error));

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    task send_and_check;
        input [7:0] data;
        begin
            @(negedge clk);
            TX_data <= data;
            transmit <= 1;

            wait (busy == 1);
            @(negedge clk);
            transmit <= 0;

            wait (busy == 0);
            wait (valid_rx == 1);
            

            if (Rx_Data !== data)
                $display("Mismatch: Sent = %h, Received = %h", data, Rx_Data);
            else if (parity_error || stop_error)
                $display("Error Detected: Parity = %b, Stop = %b", parity_error, stop_error);
            else
                $display("Passed: Sent = %h, Received = %h", data, Rx_Data);

            @(posedge clk);
        end
    endtask

    initial begin
        $display("UART Check TB Started");
        rst = 1;
        TX_data = 0;
        transmit = 0;

        #100;
        rst = 0;

        send_and_check(8'h55);
        send_and_check(8'hA5);
        send_and_check(8'hFF);
        send_and_check(8'h00);
        send_and_check(8'h3C);

        $display("UART Test Completed");
        $finish;
    end

endmodule