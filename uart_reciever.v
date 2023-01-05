module uart_receiver
    #(parameter CLKS_PER_BIT)
    (
        input PCLK,
        input ENABLE,
        input PSEL2,
        input [7:0]PADDR,
        input PWRITE,
        input PRESET,
        input rx_serial,
        output reg  PREADY,
        output rx_done,
        output reg[7:0]  rx_parallel
    );
    // initial 
    //     begin
    //     $display ("uarto");
    //     $monitor(state);
    //     end

    // Tx FSM   4 states => 2bits
    localparam IDLE = 3'b00, START_BIT = 3'b01, DATA_BITS = 3'b10,STOP_BIT = 3'b11;

    reg [2:0]   state = 0;
    reg         rx_data = 1'b1; // recieved bit
    reg [7:0]   counter = 0;  
    reg [2:0]   bit_index = 0;
    reg         done = 0;
    reg [7:0]   rx_out = 0;  

    always @(posedge PCLK) // ASYNC reset
        begin
            if(PRESET) state = IDLE;
        end
    always @(posedge PCLK)
        begin
            rx_data = rx_serial;
            case(state)
                IDLE:
                    begin
                        done <=0;
                        counter <=0;
                        bit_index <=0;
                        if(PSEL2 && PADDR[7] == 1'b0 && !PWRITE) 
                                PREADY=1'b1;
                        if(PREADY && rx_data == 1'b0) // start bit has been detected on the serial input
                            state <= START_BIT;
                        else
                            state <= IDLE;
                    end
                START_BIT:
                    begin
                        if(counter == (CLKS_PER_BIT-1)/2)
                            begin
                                if(rx_data == 1'b0) // checking if the start bit is still on the serial input
                                    begin
                                        counter <=0;
                                        state <=DATA_BITS;
                                    end
                                else
                                    state <=IDLE;
                            end
                        else
                            begin
                                counter <= counter + 1;
                                state <=START_BIT;
                            end
                    end
                DATA_BITS:
                    begin
                        if(counter < CLKS_PER_BIT-1) // wait until the the start bit to end
                            begin
                                counter <= counter + 1;
                                state <= DATA_BITS;
                            end
                        else
                            begin
                                counter <=0;
                                rx_out[bit_index] <= rx_data;
                                if (bit_index < 7)
                                    begin
                                        bit_index <= bit_index + 1;
                                        state <= DATA_BITS;
                                    end
                                else
                                    begin
                                        bit_index <= 0;
                                        state <= STOP_BIT;
                                    end
                            end
                    end
                STOP_BIT:
                    begin
                        
                        if (counter < CLKS_PER_BIT-1)
                            begin
                                counter <= counter + 1;
                                state <= STOP_BIT;
                            end
                        else
                            begin
                              rx_parallel = rx_out;
                                done <= 1'b1;
                                counter <= 0;
                                state <= IDLE;
                                PREADY <= 1'b0;
                            end
                    end
                default: state <= IDLE;
            endcase
        end  
        assign rx_done = done;
          
endmodule
