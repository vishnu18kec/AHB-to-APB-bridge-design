module apb_slave_model(
input wire PCLK, PRESETn, PSEL, PENABLE, PWRITE,
input wire [31:0] PADDR, PWDATA,
output reg [31:0] PRDATA,
output reg PREADY, PSLVERR
);
reg [31:0] reg0;
always @(posedge PCLK or negedge PRESETn) begin
if(!PRESETn) reg0<=32'b0;
else begin
PREADY<=1'b1; PSLVERR<=1'b0;
if(PSEL && PENABLE && PREADY) begin
if(PWRITE) reg0<=PWDATA; else PRDATA<=reg0;
end
end
end
endmodule