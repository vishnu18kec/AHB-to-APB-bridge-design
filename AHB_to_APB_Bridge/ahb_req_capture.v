module ahb_req_capture (
input wire HCLK,
input wire HRESETn,
input wire [31:0] HADDR,
input wire [1:0] HTRANS,
input wire HWRITE,
input wire [2:0] HSIZE,
input wire [2:0] HBURST,
input wire [31:0] HWDATA,
input wire HREADY_in,
output reg req_valid,
input wire req_ready,
output reg [31:0] req_addr,
output reg req_write,
output reg [2:0] req_size,
output reg [31:0] req_wdata
);
wire ahb_transfer = (HTRANS == 2'b10) || (HTRANS == 2'b11);
always @(posedge HCLK or negedge HRESETn) begin
if (!HRESETn) begin
req_valid <= 1'b0;
req_addr <= 32'b0;
req_write <= 1'b0;
req_size <= 3'b0;
req_wdata <= 32'b0;
end else begin
if (ahb_transfer && HREADY_in && !req_valid) begin
req_addr <= HADDR;
req_write <= HWRITE;
req_size <= HSIZE;
req_wdata <= HWDATA;
req_valid <= 1'b1;
end else if (req_valid && req_ready) begin
req_valid <= 1'b0;
end
end
end
endmodule