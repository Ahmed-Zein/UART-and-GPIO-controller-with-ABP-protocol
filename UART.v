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
uart_receiver #(CPB) rrx(
    PCLK,
    PENABLE,
    PSEL2,
    PADDR,
    PWRITE,
    PRESETn,
    rx,
    PREADY,
    rx_done,
    data_output
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

uart_transmitter #(CPB) ttx (
    PCLK,
    PENABLE,
    PSEL2,
    PADDR,
    PWRITE,
    PRESETn,
    PWDATA,
    PREADY,
    tx,
    w_tDone
    );

endmodule
