// uart top level module
module UART(
    input PCLK,
    input PSEL2,
    input PENABLE,
    input [7:0] PADDR,
    input PWRITE,
    input [7:0] PWDATA,
    input rx,
    output reg [7:0] PRDATA,
    output reg done,
    output reg txdone,
    output tx
);
 
parameter CLKS_PER_BIT = 0; // change later

// declare rx & tx
endmodule