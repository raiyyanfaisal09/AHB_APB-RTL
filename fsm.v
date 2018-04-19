module fsm(HADDR_1,HADDR_2,HADDR_3,HWDATA_1,HWDATA_2,HWDATA_3,HWRITE,HWRITEreg,HSIZE,
           TEMP_SEL,valid,PADDR,PWDATA,PSEL,PWRITE,PENABLE,HCLK,HRESETn,HTRANS,HREADYout);

input	[31:0]HADDR_1,
	      HADDR_2,
	      HADDR_3,

	      HWDATA_1,
	      HWDATA_2,
	      HWDATA_3;

input	[1:0]HTRANS;
input	[2:0]HSIZE,
	     TEMP_SEL;

input	HRESETn,
	HCLK,
	valid,
	HWRITE,
	HWRITEreg;


output reg	[31:0]PADDR,
		      PWDATA;
output reg	[2:0]PSEL;
output reg	PWRITE,
		PENABLE,
		HREADYout;

reg [2:0]STATE,NX_STATE;
reg tmp;


parameter	ST_IDLE=3'b000,
		ST_WWAIT=3'b001,
		ST_READ=3'b010,
		ST_WRITE=3'b011,
		ST_WRITEP=3'b100,
		ST_RENABLE=3'b101,
		ST_WENABLE=3'b110,
		ST_WENABLEP=3'b111;


always@(posedge HCLK, negedge HRESETn)
begin
  if(~HRESETn)
    STATE<=ST_IDLE;
  else
    STATE<=NX_STATE;
end



always@(*)
 begin

      NX_STATE=ST_IDLE;
	PSEL = 0;
	PENABLE = 0;
	HREADYout = 0;
        PWRITE = 0;
	case(STATE)

         ST_IDLE:begin
	          PSEL=0;
		  PENABLE=0;
		  HREADYout=1'b1;

		  if(~valid)
		    NX_STATE=ST_IDLE;
		  else if(valid && HWRITE)
		    NX_STATE=ST_WWAIT;
		  else 
		    NX_STATE=ST_READ;
		end

	 ST_WWAIT:begin
		  
		  HREADYout=1'b1;
	//	  PSEL=0;
		  PENABLE=0;
                  tmp=1;

		  if(~valid)
		    NX_STATE=ST_WRITE;
		  else if(valid)
		    NX_STATE=ST_WRITEP;
		end


	ST_READ: begin
		 PSEL=TEMP_SEL;
		 PENABLE=1'b0;
		 PADDR=HADDR_1;
		 PWRITE=1'b0;
		HREADYout=1'b0;
		 
		 NX_STATE=ST_RENABLE;
		end


	ST_WRITE:begin
		 PSEL=TEMP_SEL;
		 PADDR=HADDR_2;
		 PWRITE=1'b1;
		 PWDATA=HWDATA_1;
		 PENABLE=1'b0;
		  if(~valid)
		      NX_STATE=ST_WENABLE;
		  else if(valid)
		      NX_STATE=ST_WENABLEP;
		 end


	ST_WRITEP: begin
		//	if()
		//	   PADDR=HADDR_2;
		//	else
			if(tmp == 1)
			PADDR=HADDR_2;
			else
			PADDR=HADDR_3;
			PSEL=TEMP_SEL;
			PENABLE=1'b0;
			PWRITE=1'b1;
			PWDATA=HWDATA_1;
		HREADYout=1'b0;

			NX_STATE=ST_WENABLEP;
                    end


	ST_RENABLE: begin
		     PENABLE=1'b1;
		     PSEL=TEMP_SEL;
		     PWRITE=1'b0;
		     HREADYout=1'b1;

		      if(~valid)
			NX_STATE=ST_IDLE;
		      else if(valid && ~HWRITE)
			NX_STATE=ST_READ;
		      else if(valid && HWRITE)
			NX_STATE=ST_WWAIT;
		   end

	ST_WENABLE: begin
		      PENABLE=1'b1;
		      PSEL=TEMP_SEL;
		      PWRITE=1'b1;
		      HREADYout=1'b1;

			if(valid && ~HWRITE)
			NX_STATE=ST_READ;
		      else if(~valid)
			NX_STATE=ST_IDLE;
		      else if(valid && HWRITE)
			NX_STATE=ST_WWAIT;
		    end

	ST_WENABLEP: begin
			tmp=0;
		       PSEL=TEMP_SEL;
		       PENABLE=1'b1;
		       PWRITE=1'b1;
		       HREADYout=1'b1;
		//	PADDR=HADDR_3;
		//	PWDATA=HWDATA_3;
		//HREADYout=1'b0;

		       
		       if(~HWRITEreg)
			NX_STATE=ST_READ;
		       else if(~valid && HWRITEreg)
			NX_STATE=ST_WRITE;
		       else if(valid && HWRITEreg)
			NX_STATE=ST_WRITEP;
		     end
		 default:NX_STATE=ST_IDLE;
		endcase
             end
          
endmodule		    
		





	
