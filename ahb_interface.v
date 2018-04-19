module ahb_int(PENABLE,PWRITE,PSEL,PADDR,PWDATA,PRDATA);
input PENABLE,PWRITE;
input [2:0]PSEL;
input [31:0]PADDR,PWDATA;
output reg [31:0]PRDATA;


always@(*)
begin
  if(~PWRITE)
    begin
	if(PENABLE )
	  PRDATA={$random}%10000;
	else
	  PRDATA=32'bx;
     end
end
endmodule
