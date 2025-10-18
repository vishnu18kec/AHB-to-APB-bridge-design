module apb_master_ctrl #(parameter SLAVES = 4)(
input wire PCLK,
input wire PRESETn,
input wire req_valid,
output reg req_ready,
input wire [31:0] req_addr,
input wire req_write,
input wire [3:0] req_be,
input wire [31:0] req_wdata,
input wire [SLAVES-1:0] req_psel_mask,
output reg [31:0] PADDR,
output reg PWRITE,
output reg [31:0] PWDATA,
output reg PSEL,
output reg PENABLE,
output reg [SLAVES-1:0] PSELx_vec,
input wire [31:0] PRDATA,
input wire PREADY,
input wire PSLVERR,
output reg resp_valid,
input wire resp_ready,
output reg [31:0] resp_rdata,
output reg resp_err
);
reg [1:0] state, next_state;
reg [31:0] lat_addr;
reg lat_write;
reg [3:0] lat_be;
reg [31:0] lat_wdata;
reg [SLAVES-1:0] lat_psel_mask;
reg access_done;


always @(posedge PCLK or negedge PRESETn) begin
if (!PRESETn) begin
state <= 0; lat_addr<=0; lat_write<=0; lat_be<=0; lat_wdata<=0; lat_psel_mask<=0; access_done<=0;
end else begin
state <= next_state;
if (req_valid && req_ready) begin
lat_addr<=req_addr; lat_write<=req_write; lat_be<=req_be; lat_wdata<=req_wdata; lat_psel_mask<=req_psel_mask;
end
if (state==2'd2 && PREADY) access_done<=1'b1;
else if (resp_valid && resp_ready) access_done<=1'b0;
end
end


always @(*) begin
next_state = state;
PENABLE = 0; PSELx_vec = (state!=0)?lat_psel_mask:0;
PSEL = |PSELx_vec; PADDR = lat_addr; PWRITE = lat_write; PWDATA = lat_wdata;
req_ready = (state==0); resp_valid=access_done; resp_rdata=PRDATA; resp_err=PSLVERR;
case(state)
0: if(req_valid && req_ready) next_state=1;
1: begin PENABLE=0; next_state=2; end
2: begin PENABLE=1; if(PREADY) next_state=0; end
default: next_state=0;
endcase
end
endmodule