module ahb_slave(HADDR,HWDATA,HTRANS,HREADYin,HWRITE,HRESP, HRDATA,
		HSIZE,HCLK,HRESETn,HADDR_1,HWDATA_1,HADDR_2,HWDATA_2,
		HADDR_3,HWDATA_3,HWRITEreg,valid,TEMP_SEL,PRDATA);

input	[31:0]HADDR,HWDATA,PRDATA;
input	[1:0]HTRANS;
input	HREADYin,HWRITE;
input	[2:0]HSIZE;
input	HCLK,HRESETn;
	

output reg	[31:0]HADDR_1,
		HWDATA_1,
		HADDR_2,
		HWDATA_2,
		HADDR_3,
		HWDATA_3;

output 		[31:0]HRDATA;
	

output reg 	HWRITEreg,valid;
output reg	[1:0]HRESP;
output reg	[2:0]TEMP_SEL;



assign HRDATA=PRDATA;


parameter IDLE=2'b00,
	  BUSY=2'b01,
	  NONSEQ=2'b10,
	  SEQ=2'b11;



always@(posedge HCLK,negedge HRESETn)
  begin
	HRESP=0;

	if(~HRESETn)
       	 begin
          HADDR_1<=0;
	  HADDR_2<=0;
	  HADDR_3<=0;
	 end

	
	else
	  begin
	    HADDR_1<=HADDR;
	    HADDR_2<=HADDR_1;
	    HADDR_3<=HADDR_2;
	  end
 end


always@(posedge HCLK, negedge HRESETn)
  begin
	if(~HRESETn)
	  begin
	    HWDATA_1<=0;
	    HWDATA_2<=0;
	    HWDATA_3<=0;
	  end

	else
	  begin
	   HWDATA_1<=HWDATA;
	   HWDATA_2<=HWDATA_1;
	   HWDATA_3<=HWDATA_2;
	  end
  end


always@(posedge HCLK, negedge HRESETn)
  begin
	if(~HRESETn)
	   HWRITEreg<=0;
	else
	   HWRITEreg<=HWRITE;
  end
       

always@(*)
  begin
    if(~HRESETn)
       valid=0;
    
    else if((HADDR>32'h8000_0000 && HADDR< 32'h8c00_0000) /*&&  (HTRANS==NONSEQ || HTRANS==SEQ)*/)
     
         valid=1'b1;
    else
         valid=1'b0;
   end


always@(*)
  begin

   
        if( (32'h8c00_0000 >= HADDR>=32'h8800_0001)) 
		TEMP_SEL=3'b100;
	 else if((32'h8800_0000 >= HADDR>=32'h8400_0001))
		TEMP_SEL=3'b010;
 	 else if((32'h8400_0000 >= HADDR>=32'h8000_0000))
		TEMP_SEL=3'b001;
	 
  end
endmodule



 
     
    








	
	    
	









	
	
	
	
