module tb_uartTX;
        // input PCLK,
        // input ENABLE,
        // input PSEL2,
        // input [7:0]PADDR,//address
        // input PWRITE, // write permission
        // input PRESET,//reset
        // input [7:0] tx_parallel, // byte to transmit
        // output reg  PREADY, // slave is ready
        // output reg  o_Tx_Serial, // output
        // output      o_Tx_Done // tranmision is done

parameter CPB = 87; // change later
reg    PCLK;
reg    PENABLE;
reg    PSEL2;
reg [7:0]   PADDR;
reg   PWRITE;
reg   PRESETn;
reg  [7:0] PWDATA;
 
wire    PREADY;
wire    o_tx;
wire    w_tDone;

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
        PWRITE      = 1;
        PWDATA      = 8'b11111111;
        PRESETn = 0;
        // #10000
        // PWRITE      = 0;
    end
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
