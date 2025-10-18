module byte_en_generator(
input wire [31:0] addr,
input wire [2:0] hsize,
output reg [3:0] be,
output reg [31:0] aligned_addr
);
always @(*) begin
be = 4'b0000;
aligned_addr = addr & 32'hFFFFFFFC;
case (hsize[1:0])
2'b00: case(addr[1:0])
2'b00: be=4'b0001;
2'b01: be=4'b0010;
2'b10: be=4'b0100;
2'b11: be=4'b1000;
endcase
2'b01: be = addr[1] ? 4'b1100 : 4'b0011;
2'b10: be = 4'b1111;
default: be = 4'b1111;
endcase
end
endmodule