`timescale 1ns/1ns

module master_bridge(
    input [7:0]apb_write_paddr,apb_read_paddr,
    input [7:0] apb_write_data,PRDATA,         
    input PRESETn,PCLK,READ_WRITE,PREADY,
    output PSEL1,PSEL2,
    output reg PENABLE,
    output reg [7:0]PADDR,
    output reg PWRITE,
    output reg [7:0]PWDATA,apb_read_data_out,
); 

reg [2:0] state, next_state;

// APB FSM
localparam IDLE = 3'b001, SETUP = 3'b010, ACCESS = 3'b100 ;

//  assign {PSEL1,PSEL2} = ((state != IDLE) ? (PADDR[7] ? {1'b0,1'b1} : {1'b1,1'b0}) : 2'd0);
always @(posedge PCLK)
    begin
    if(state !=IDLE)
        begin
            if(apb_write_paddr[7] == 1'b0) 
                begin
                    PSEL2 = 1'b1;
                    PSEL1 = 1'b0;
                end
            if(apb_write_paddr[7] == 1'b1) 
                begin
                    PSEL1 = 1'b1;
                    PSEL2 = 1'b0;
                end
        end
    else
        begin
            PSEL1 = 1'b0;
            PSEL2 = 1'b0;
        end	  
    end


// ASYNC reset
always @(posedge PCLK)
    begin
        if(!PRESETn)
            state <= IDLE;
        else
            state <= next_state; 
    end

always @(state)
    begin
        if(!PRESETn)
            next_state = IDLE;
        else
            begin
                PWRITE = ~READ_WRITE;
                case(state)
                    IDLE: 
                        begin 
                            PENABLE = 0;
                            if(!PSEL1 && !PSEL2) // no slave is selected
                                next_state = IDLE ;
                            else
                                next_state = SETUP;
                        end

                    SETUP:   
                        begin
                            PENABLE =0;
                            if(READ_WRITE) 
                                begin
                                    // @(posedge PCLK)
                                    PADDR = apb_read_paddr; 
                                end
                            else 
                                begin   
                                    // @(posedge PCLK)
                                    PADDR = apb_write_paddr;
                                    PWDATA = apb_write_data; 
                                end
                            if(PSEL1 || PSEL2)
                                next_state = ACCESS;
                            else
                                next_state = IDLE;
                        end

                    ACCESS: 
                        begin 
                            if(PSEL1 || PSEL2)
                                PENABLE = 1; // goes HIGH after one cycle after PSEL & PADDR
                                if(PREADY)
                                    begin
                                        if(!READ_WRITE)
                                            begin
                                                next_state = SETUP; 
                                            end
                                        else 
                                            begin
                                                next_state = SETUP;  
                                                apb_read_data_out = PRDATA; 
                                            end
                                    end
                                else 
                                    next_state = ACCESS;
                               
                            else next_state = IDLE;
                        end
                    default: 
                        next_state = IDLE; 
                endcase 
            end
    end
endmodule