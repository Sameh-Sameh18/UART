UART Communication System (Verilog)

This project implements a complete **UART (Universal Asynchronous Receiver/Transmitter)** communication system in Verilog HDL, including **Transmitter**, **Receiver**, **Baud Rate Generator**, and an integrated **Top Module** for simulation and synthesis.


Overview

UART is a serial communication protocol widely used for low-speed, short-distance data exchange between digital devices.  
This design supports **8-bit data**, **even parity**, **1 start bit**, and **1 stop bit**.

The system includes:

| Module | Description |
|---------|--------------|
| `UART_TX.v` | UART Transmitter: Converts parallel data to serial data. |
| `UART_RX.v` | UART Receiver: Converts serial data to parallel data with error checking. |
| `Buad_Rate.v` | Baud Rate Generator: Derives TX and RX sampling clocks. |
| `Top.v` | Integrates TX, RX, and Baud Generator into a complete UART system. |
| `Top_tb.v` | Testbench for full UART loopback verification. |

Features:

- 8-bit data transmission and reception  
- Even parity checking  
- Start and stop bit detection  
- Internal baud rate generation  
- Full-duplex loopback testbench  
- Error detection for:
  - Parity mismatch  
  - Missing stop bit  

Parameters:

| Parameter | Description | Default |
|------------|--------------|----------|
| `D_WIDTH` / `WIDTH` | Data width | `8` |
| `CLK_FREQ` | Input clock frequency | `50_000_000` Hz |
| `BUAD_RATE` | Communication speed | `9600` baud |

Author

Sameh Mohammed

