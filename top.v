module top_tb();
reg HCLK;
reg HRESETn=0;

wire [31:0]wdata,prdata,paddr;
wire [2:0]psel;
wire pwrite,penable;


ahb_master MASTER(.HCLK(HCLK),		.HRESETn(HRESETn),	.HWRITE(BRIDGE.HWRITE),
		  .HREADYin(BRIDGE.HREADYin),	.HWDATA(BRIDGE.HWDATA),	.HADDR(BRIDGE.HADDR),
		  .HTRANS( BRIDGE.HTRANS),	.HREADYout( BRIDGE.HREADYout),	.HRESP( BRIDGE.HRESP),
		  .HRDATA(BRIDGE.HRDATA),	.HSIZE(BRIDGE.HSIZE));


top BRIDGE(.HADDR( MASTER.HADDR),	.HWDATA( MASTER.HWDATA),	.HTRANS( MASTER.HTRANS),
	   .HREADYin( MASTER.HREADYin),	.HWRITE( MASTER.HWRITE),	.HRESP( MASTER.HRESP),
	   .HRDATA( MASTER.HRDATA),	.HREADYout( MASTER.HREADYout),	.HSIZE( MASTER.HSIZE),
	   .HRESETn( MASTER.HRESETn),	.HCLK(HCLK),			.PADDR(paddr),
	   .PWDATA(wdata),		.PSEL(psel),			.PWRITE(pwrite),
	   .PENABLE(penable),		.PRDATA(prdata));


ahb_int SLAVE(.PENABLE(penable), .PWRITE(pwrite),	.PSEL(psel),
	      .PADDR(paddr),	 .PWDATA(wdata),	.PRDATA(prdata));






always
begin
HCLK=1'b1;
#10;
HCLK=~HCLK;
#10;
end


task rst;
begin
@(negedge HCLK);
HRESETn=1'b0;
@(negedge HCLK);
HRESETn=1'b1;
end
endtask

initial
begin
rst;
#10000 $finish();
end

endmodule




