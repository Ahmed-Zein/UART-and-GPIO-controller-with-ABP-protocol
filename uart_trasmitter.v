module uart_transmitter 
    #(parameter CLKS_PER_BIT)
    (
        input PCLK,
        input ENABLE,
        input PSEL2,
        input [7:0]PADDR,
        input PWRITE,
        input [7:0] tx_parallel, 
        output reg  PREADY,
        output reg  o_Tx_Serial,
        output      o_Tx_Done
    );

    // Tx FSM   4 states => 3bits
    localparam IDLE = 3'b000, START_BIT = 3'b001, DATA_BITS = 3'b010, STOP_BIT = 3'b011;
 
    reg [2:0]    state     = 0;
    reg [7:0]    counter = 0;
    reg [2:0]    r_Bit_Index   = 0; // idx of the tx data bit to be sent on the serial output
    reg [7:0]    r_Tx_Data     = 0;
    reg          r_Tx_Done     = 0;
 
    always @(posedge PCLK)
        begin
            case(state)
                IDLE:
                    begin
                        o_Tx_Serial <= 1'b1; // default: HIGH }=> indicates no start bit is senton the serial output
                        r_Tx_Done <= 1'b0;
                        counter <= 0;
                        r_Bit_Index   <= 0;
                        if(PSEL2 && PADDR[7] == 1'b0 && PWRITE) 
                            PREADY=1'b1;
                        if (ENABLE && PSEL2 && PWRITE)
                            begin
                                r_Tx_Data <= tx_parallel;
                                state <= START_BIT;
                            end
                        else
                            state <= IDLE;
                    end 
                START_BIT:
                    begin
                        o_Tx_Serial <= 1'b0; // send start bit }=> putting ZERO on the serial output  
                        if (counter < CLKS_PER_BIT-1) 
                            begin
                                counter <= counter + 1;
                                state <= START_BIT;
                            end
                        else
                            begin
                                counter <= 0;
                                state <= DATA_BITS;
                            end
                    end          
                DATA_BITS :
                    begin
                        o_Tx_Serial <= r_Tx_Data[r_Bit_Index];
            
                        if (counter < CLKS_PER_BIT-1)
                            begin
                                counter <= counter + 1;
                                state     <= DATA_BITS;
                            end
                        else
                            begin
                                counter <= 0;
                                 if (r_Bit_Index < 7)
                                    begin
                                        r_Bit_Index <= r_Bit_Index + 1;
                                        state <= DATA_BITS;
                                    end
                                else // excuted when the 8bits of data are sent
                                    begin
                                        r_Bit_Index <= 0;
                                        state <= STOP_BIT;
                                    end
                            end
                    end
                STOP_BIT :
                    begin
                        o_Tx_Serial <= 1'b1; // sending stop bit }=> putting HIGH signal on the serial output again
                        if (counter < CLKS_PER_BIT-1)
                            begin
                                counter <= counter + 1;
                                state <= STOP_BIT;
                            end
                        else
                            begin
                                r_Tx_Done <= 1'b1; // drive tx_done HIGH for one cycle
                                counter <= 1'b0;
                                PREADY <= 1'b0;
                            end
                    end
                default:
                    state <= IDLE;
            endcase
        end
    assign o_Tx_Done   = r_Tx_Done;
endmodule