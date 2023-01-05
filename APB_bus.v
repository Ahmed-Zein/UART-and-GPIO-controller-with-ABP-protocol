module master_bridge (
    // Taken From Master (Cpu)
    input  PCLK, 
    input PENABLE_master,
    input  READ_WRITE,
    input transfer,
    input PRESETn,
    input [1:0] Psel,
    input [4:0]  apb_writeAddr,apb_readAddr,
    input [31:0] apb_writeData,   

    //  inputs from Slave
    input PREADY,
    input [31:0] PRDATA,

    // Outputs To Slaves
    output reg PWRITE , PENABLE,
    // PWDATA = apb_writeData
    // PADDR = apb_writeAddr or apb_readAddr address depend on PWRITE coming from master 
    output reg [31:0] PWDATA,
    output reg[4:0]PADDR,
    output reg PSEL1,PSEL2,

    // apb_readData_out data to computer coming from reading slave 
    output reg [31:0] apb_readData_out,
    output reg [1:0] currentState

);
localparam IDLE = 2'b01, SETUP = 2'b10, ACCESS = 2'b11 ;
reg [1:0] state = IDLE, nextState = IDLE;


always @(Psel) begin
    case (Psel)
        1 : begin
            PSEL1 <= 1;
            PSEL2 <= 0;
        end 
        2 : begin
            PSEL1 <= 0;
            PSEL2 <= 1;
        end
        default: begin
            PSEL1 <= 0;
            PSEL2 <= 0;
        end 
    endcase
end
// Psel1 , Psel2 

//assign {PSEL1,PSEL2} = ((state  != IDLE) ? (Psel == 1 ? {1'b0,1'b1} : {1'b1,1'b0}) : 2'd0);


always @(state ,transfer,PREADY) begin   
            PWRITE <= READ_WRITE; 
            
            case (state )
                IDLE: 
                    begin
                        PENABLE = 0;
                        if (transfer) begin
                            nextState <= SETUP;
                        end                       
                    end
                SETUP:
                    begin
                        PENABLE = 0;
                        // if Master called Write Bus will send Address of Write else will send read Address
                        // write data in setup
                        if (READ_WRITE) begin
                            PADDR <= apb_writeAddr;
                            PWDATA <= apb_writeData;

                        end
                        else begin
                            PADDR <= apb_readAddr;
                        end
                        if (transfer) begin
                            nextState <= ACCESS;
                        end
                    end
                ACCESS:
                    begin
                        if (PSEL1 || PSEL2)
                            PENABLE = 1;
                        if (transfer)
                        begin
                            /*if (PADDR == slave1Addr) {
                                PSEL1 = 1'b1;
                                PSEL2 = 1'b0;
                            }
                            else {
                                slave2Addr = PADDR;
                                PSEL2 = 1'b1;
                                PSEL1 = 1'b0;
                            }*/
                            if (PREADY) 
                            begin
                                if (READ_WRITE)
                                    nextState <= SETUP;
                                else
                                begin
                                    nextState <= SETUP;
                                    apb_readData_out = PRDATA;
                                end
                            end
                        end
                        else
                            nextState = IDLE;
                    end
            endcase
end

always @(posedge PCLK or posedge PRESETn) begin
    if (PRESETn) begin
        state  <= IDLE;
    end
    else begin
        currentState <= state;
        state  <= nextState;
    end
end
endmodule