module GPIO
    (
input  PCLK , PENABLE,PWRITE,Psel,PRESETn,
input [31:0] PWDATA,
input [4:0] PADDR,
output reg PREADY,
output reg [31:0] GPIO_OUTData
    
);

reg[31:0] mem [0:31];
reg[4:0]read_address;

always @(*) begin
  if(PRESETn)
  PREADY <= 0;
  
  else if (Psel && PENABLE && PWRITE) 
  begin
    read_address <= PADDR;
    // mem <= PWDATA;
    mem[read_address] <= PWDATA;
    PREADY <= 1'b1; 
  end

  else if(Psel && PENABLE && !PWRITE)
  begin
    GPIO_OUTData <= mem[read_address];
    PREADY <= 1'b1; 
  end

  else  PREADY <= 1'b0; 

end

endmodule  