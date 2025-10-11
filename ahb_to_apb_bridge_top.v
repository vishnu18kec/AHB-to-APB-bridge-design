module ahb_to_apb_bridge_top #(parameter SLAVES=4)(
    input  wire         HCLK,
    input  wire         HRESETn,
    input  wire [31:0]  HADDR,
    input  wire [1:0]   HTRANS,
    input  wire         HWRITE,
    input  wire [2:0]   HSIZE,
    input  wire [2:0]   HBURST,
    input  wire [31:0]  HWDATA,
    input  wire         HREADY_in,
    output reg          HREADY_out,
    output reg [1:0]    HRESP,
    output reg [31:0]   HRDATA,
    output wire [31:0]  PADDR,
    output wire         PWRITE,
    output wire [31:0]  PWDATA,
    output wire         PSEL,
    output wire         PENABLE,
    output wire [SLAVES-1:0] PSELx_vec,
    input  wire [31:0]  PRDATA,
    input  wire         PREADY,
    input  wire         PSLVERR
);

    wire        req_valid, req_ready;
    wire [31:0] req_addr, req_wdata;
    wire        req_write;
    wire [2:0]  req_size;
    wire [3:0]  req_be;
    wire [31:0] aligned_addr;
    wire [SLAVES-1:0] psel_mask;
    wire resp_valid, resp_ready;
    wire [31:0] resp_rdata;
    wire resp_err;

    ahb_req_capture u_capture(
        .HCLK(HCLK), .HRESETn(HRESETn),
        .HADDR(HADDR), .HTRANS(HTRANS), .HWRITE(HWRITE), .HSIZE(HSIZE),
        .HBURST(HBURST), .HWDATA(HWDATA), .HREADY_in(HREADY_in),
        .req_valid(req_valid), .req_ready(req_ready),
        .req_addr(req_addr), .req_write(req_write),
        .req_size(req_size), .req_wdata(req_wdata)
    );

    byte_en_generator u_be(
        .addr(req_addr), .hsize(req_size),
        .be(req_be), .aligned_addr(aligned_addr)
    );

    addr_decode #(.SLAVES(SLAVES)) u_decode(
        .addr(aligned_addr),
        .psel_vec(psel_mask)
    );

    apb_master_ctrl #(.SLAVES(SLAVES)) u_apb(
        .PCLK(HCLK), .PRESETn(HRESETn),
        .req_valid(req_valid), .req_ready(req_ready),
        .req_addr(aligned_addr), .req_write(req_write), .req_be(req_be),
        .req_wdata(req_wdata), .req_psel_mask(psel_mask),
        .PADDR(PADDR), .PWRITE(PWRITE), .PWDATA(PWDATA),
        .PSEL(PSEL), .PENABLE(PENABLE), .PSELx_vec(PSELx_vec),
        .PRDATA(PRDATA), .PREADY(PREADY), .PSLVERR(PSLVERR),
        .resp_valid(resp_valid), .resp_ready(resp_ready),
        .resp_rdata(resp_rdata), .resp_err(resp_err)
    );

    always @(*) begin
        HREADY_out = HREADY_in && req_ready && (!PSEL || PREADY);
        HRESP = resp_err ? 2'b01 : 2'b00;
        HRDATA = resp_valid ? resp_rdata : 32'b0;
    end

    reg resp_ready_reg;
    assign resp_ready = resp_ready_reg;
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn)
            resp_ready_reg <= 1'b0;
        else
            resp_ready_reg <= resp_valid && HREADY_in;
    end

endmodule
