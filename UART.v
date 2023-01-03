// uart top level module
module UART(
    input PCLK,
    input PSEL2,
    input PENABLE,
    input [7:0] PADDR,
    input PWRITE,
    input PRESETn,
    input [7:0] PWDATA,
    output reg [7:0] PRDATA, //uart recieve output
    output PREADY,

    output reg rx_done,
    output reg tx_done,

    input rx,
    output tx
);
//  CLKS_PER_BIT
parameter CPB = 87; // change later

// declare rx & tx
// module uart_receiver
//     #(parameter CLKS_PER_BIT)
//     (
//         input PCLK,
//         input ENABLE,
//         input PSEL2,
//         input [7:0]PADDR,
//         input PWRITE,
//         input PRESET,
//         input rx_serial,
//         output reg  PREADY,
//         output rx_done,
//         output[7:0] rx_parallel
//     );
uart_receiver #(CPB) rx(
    PCLK,
    PENABLE,
    PSEL2,
    PADDR,
    PWRITE,
    PRESETn,
    rx,
    PREADY,
    rx_done,
    PRDATA
);

// module uart_transmitter 
//     #(parameter CLKS_PER_BIT)
//     (
//         input PCLK,
//         input ENABLE,
//         input PSEL2,
//         input [7:0]PADDR,
//         input PWRITE,
//         input PRESET,
//         input [7:0] tx_parallel, 
//         output reg  PREADY,
//         output reg  o_Tx_Serial,
//         output      o_Tx_Done
//     );

uart_transmitter #(CPB) tx (
    PCLK,
    PENABLE,
    PSEL2,
    PADDR,
    PWRITE,
    PRESETn,
    PWDATA,
    PREADY,
    tx,
    tx_done, 
    );

endmodule


/*
# ** Warning: (vsim-3015) C:/Users/ahmed/Desktop/boom/compiling/tb_uart.v(95): [PCDPC] - Port size (8 or 8) does not match connection size (1) for port 'PADDR'. The port definition is at: uart.v(6).
# 
#         Region: /tb_uart/uartx
# ** Error: (vsim-3053) uart.v(48): Illegal output or inout port connection for "port 'rx_done'".
# 
#         Region: /tb_uart/uartx/RRx
# ** Error: (vsim-3053) uart.v(48): Illegal output or inout port connection for "port 'rx_parallel'".
# 
#         Region: /tb_uart/uartx/RRx
# ** Fatal: (vsim-3365) uart.v(76): Too many port connections. Expected 10, found 11.
#    Time: 0 ps  Iteration: 0  Instance: /tb_uart/uartx/TTx File: C:/Users/ahmed/Desktop/boom/compiling/uart_trasmitter.v
# FATAL ERROR while loading design
*/