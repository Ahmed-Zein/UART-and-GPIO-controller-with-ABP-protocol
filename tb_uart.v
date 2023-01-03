`include "UART.v" 

module tb_uart();
/*
    input PCLK,
    input PSEL2,
    input PENABLE,
    input [7:0] PADDR,
    input PWRITE,
    input PRESETn,
    input [7:0] PWDATA,
    output reg [7:0] PRDATA,
    output PREADY,

    output reg rx_done,
    output reg tx_done,

    input rx,
    output tx
*/
 	reg PCLK,PRESETn,PSEL2,PENABLE,PWRITE,PADDR;
	reg     [7:0] i_pWdata;

 	wire    [7:0] o_rx; //PRDATA ==> uart rx output
    wire o_tx,i_rx;
    wire o_rx_done, o_tx_done;  

    wire ready; //PREADY

    initial
        begin
            PCLK = 1;
        end 
    always 
        begin
            #5 PCLK = ~PCLK;
        end
  
    initial
        begin
            $monitor("%b %b %b %b %b %b %b", PCLK, PSEL2, PENABLE, PWRITE, i_pWdata,i_rx,ready);
            i_pWdata<= 8'b00101010;
            PSEL2 <= 1'b1;
            PRESETn <= 1'b1;
            PENABLE<=1;
            PWRITE <= 1'b1;
        end
/*
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
*/
UART uartx (
    PCLK,
    PSEL2,
    PENABLE,
    PADDR,
    PWRITE,
    PRESETn,
    i_pWdata,
    o_rx,
    ready,
    o_rx_done,
    o_tx_done,
    i_rx,
    o_tx
);
endmodule
