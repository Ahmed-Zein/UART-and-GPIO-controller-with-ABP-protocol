module tb_uartRX;

parameter CPB = 10; // change later
reg    PCLK;
reg    PENABLE;
reg    PSEL2;
reg [7:0]   PADDR;
reg   PWRITE;
reg   PRESETn;
wire [7:0] data_output;
wire    PREADY;
reg    rx;
wire    rx_done;

initial
    begin
        forever #5  PCLK=~PCLK;
    end

initial
    begin
        PCLK= 1;
        PADDR =  8'b01111111;
        PSEL2        = 1;
        PENABLE     = 1;
        PWRITE      = 0;
        PRESETn = 0;
        rx = 0;
        #100 rx = 0;
        #100 rx = 0;
        #100 rx = 1;
        #100 rx = 1;
        #100 rx = 0;
        #100 rx = 1;  
        #100 rx = 1;
        #100 rx = 0;
        // #10000
        // PWRITE      = 0;
    end
/*
    input PCLK,
    input ENABLE,
    input PSEL2,
    input [7:0]PADDR,
    input PWRITE,
    input PRESET,
    input rx_serial,
    output reg  PREADY,
    output rx_done,
    output[7:0] rx_parallel
*/
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

endmodule