module addr_decode #(parameter SLAVES = 4)(
input wire [31:0] addr,
output reg [SLAVES-1:0] psel_vec
);
integer i;
always @(*) begin
psel_vec = 0;
for (i=0; i<SLAVES; i=i+1) begin
if (addr >= 32'h4000_0000 + i*1024 && addr <= 32'h4000_0000 + i*1024 + 1023)
psel_vec[i] = 1'b1;
end
end
endmodule