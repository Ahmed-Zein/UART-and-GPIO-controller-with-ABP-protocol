`include "APB_Protocol.v"

//`timescale 1ns/1ns

module APB_Protocol_tb;
    // Inputs
    reg PCLK;
    reg PENABLE;
    reg PWRITE;
    reg transfer;
    reg PRESETn;
    reg [4:0] apb_writeAddr;
    reg [4:0] apb_readAddr;
    reg [31:0] apb_writeData;
    reg [1:0] PSEL;
    //reg rx = 1;
    // Outputs
    wire [31:0] apb_readData_out;
    wire [1:0] state;
    //integer i;

    // Instantiate the APB protocol module
    APB_Protcol A1 (PCLK, PENABLE, PWRITE, transfer, PRESETn, apb_writeAddr, apb_readAddr, apb_writeData, PSEL, apb_readData_out, state);

    // Test vectors
    initial 
    begin
    $dumpfile("dump2.vcd");
    $dumpvars(0,APB_Protocol_tb);
        // Initialize input signals
        PCLK = 1'b0;
        PENABLE = 1'b0;
        PWRITE = 1'b0;
        transfer = 1'b0;
        PRESETn = 1'b0;
        apb_writeAddr = 32'h00000000;
        apb_readAddr = 32'h00000000;
        apb_writeData = 32'h00000000;
        PSEL = 2'b00;
       
        #30;
        
    
        //  GPIO TESTBENCH
        PSEL = 2'b01;
        transfer = 1'b1;
        // Write a value to the slave peripheral's memory
        PENABLE = 1'b1;
        PWRITE = 1'b1;
        apb_writeAddr = 1'b1;
        apb_writeData = 32'hf0f0f0f0;
        #30 

        // Read a value from the slave peripheral's memory
        PWRITE = 1'b0;
        apb_readAddr = 1'b1;
        #30; 
        PWRITE = 1'b1;
      apb_writeAddr = 2'b0;
       apb_writeData = 32'hAAA;
        #30;
        PWRITE=1'b0;
        apb_readAddr = 2'b10;
        #30;
        PSEL = 1'b0;
        #30
        PENABLE = 1'b0;

        // UART 
        
    end
    // Clock generator
    always #5 PCLK <= ~PCLK;
endmodule
