module tb_ahb_to_apb_bridge;
reg HCLK, HRESETn;
reg [31:0] HADDR; reg [1:0] HTRANS; reg HWRITE; reg [2:0] HSIZE;
reg [2:0] HBURST; reg [31:0] HWDATA; reg HREADY_in;
wire HREADY_out; wire [1:0] HRESP; wire [31:0] HRDATA;
wire [31:0] PADDR; wire PWRITE; wire [31:0] PWDATA;
wire PSEL; wire PENABLE; wire [0:0] PSELx_vec; wire [31:0] PRDATA; wire PREADY; wire PSLVERR;


ahb_to_apb_bridge_top #(.SLAVES(1)) uut(HCLK,HRESETn,HADDR,HTRANS,HWRITE,HSIZE,HBURST,HWDATA,HREADY_in,HREADY_out,HRESP,HRDATA,PADDR,PWRITE,PWDATA,PSEL,PENABLE,PSELx_vec,PRDATA,PREADY,PSLVERR);
apb_slave_model u_slave(PCLK,HRESETn,PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA,PREADY,PSLVERR);


initial HCLK=0; always #5 HCLK=~HCLK;
initial begin
HRESETn=0; HREADY_in=1; HADDR=0; HTRANS=2'b00; HWRITE=0; HSIZE=3'd2; HBURST=3'd0; HWDATA=0;
#20 HRESETn=1;
// Write transaction
@(posedge HCLK); HADDR=32'h4000_0000; HTRANS=2'b10; HWRITE=1; HWDATA=32'hDEADBEEF;
@(posedge HCLK); HTRANS=2'b00;
#20;
// Read transaction
@(posedge HCLK); HADDR=32'h4000_0000; HTRANS=2'b10; HWRITE=0;
@(posedge HCLK); HTRANS=2'b00;
#50;
$finish;
end
endmodule