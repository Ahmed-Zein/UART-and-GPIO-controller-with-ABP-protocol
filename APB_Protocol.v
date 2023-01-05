`include "APB_bus.v"
`include "gpio.v"
`include "UART.v"

// `timescale 1ns/1ns

module APB_Protcol (
    input  PCLK,  PENABLE,  PWRITE,  transfer,PRESETn,
    input [4:0] apb_writeAddr,apb_readAddr,
	input [31:0] apb_writeData,
    // 1 gpio 2 uart 0 idle
    input [1:0] Psel,
    output [31:0] apb_readData_out,
    output [1:0] state
    // input rx
);
        // coming from Slave 
        reg PREADY ;
        reg [31:0] PRDATA;
        wire [31:0] PWDATA;
        wire[4:0]PADDR;
        wire PSEL1,PSEL2;
        wire [31:0]PRDATA1,PRDATA2;
        wire PREADY1,PREADY2;
        wire READ_WRITE;

always @(Psel or PREADY1 or PRDATA1 or PREADY2 or PRDATA2 ) begin
    case (Psel)
        1 : begin
            PREADY <= PREADY1;
            PRDATA <= PRDATA1;
        end 
        2 : begin
            PREADY <= PREADY2;
            PRDATA <= PRDATA2;

        end
        default: begin
            PREADY <= 0;
            PRDATA <= 0;
        end 
    endcase
end

        master_bridge bridge(
        PCLK,  PENABLE,  PWRITE,  transfer,PRESETn,Psel,apb_writeAddr,apb_readAddr,apb_writeData,// From Tb
        PREADY,PRDATA,READ_WRITE,PENABLE, //From Slaves
        PWDATA,PADDR,PSEL1,PSEL2 // Out To Slave
        ,apb_readData_out,state // Out To Test bench
        ); 

        GPIO g1(  PCLK , PENABLE ,READ_WRITE,PSEL1,PRESETn,PWDATA,PADDR,PREADY1,PRDATA1 );


endmodule