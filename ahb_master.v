module ahb_master(HCLK,HRESETn,HWRITE,HREADYin,HWDATA,HADDR,HTRANS,
		  HREADYout,HRESP,HRDATA,HSIZE);

input HCLK,HRESETn,HREADYout;
input [1:0]HRESP;
input [31:0]HRDATA;
output reg HREADYin=1,HWRITE;
output reg[31:0]HWDATA,HADDR;
reg [31:0] HADDRreg;
output reg[2:0]HSIZE;
output reg[1:0]HTRANS;

reg [2:0]HBURST;

parameter EIGHT=3'b000,
	  SIXTEEN=3'b001,
	  THIRTY_TWO=3'b010;

parameter  WRAP_8=3'b100,
	  INC_16=3'b111,
	  WRAP_4=3'b010,
	  INC_8=3'b101,

	  NONSEQ=2'b00,
	  SEQ=2'b01;
	  

          
            

task burst_8;
begin
    case(HBURST)
	WRAP_8:begin
		   
                     begin 
		       wait(HREADYout)  
			 @(posedge HCLK);
                      

	 	       HWRITE=1'b1;
		       HTRANS=NONSEQ;
	       	       HADDR=32'h8001_0000;
	               //@(posedge HCLK);
		   //HWDATA<={$random}%255;
		  
	       	repeat(7)
		   begin
			
		     wait(HREADYout)
			@(posedge HCLK);
			#3;

   			HWRITE=1'b1;
			HTRANS=SEQ;
	           //@(posedge HCLK);
			HADDR={HADDR[31:3],HADDR[2:0]+1'b1};
                         //@(posedge HCLK);
			HWDATA={$random}%255;
		     end
			 wait(HREADYout)
   			@(posedge HCLK);
			#3;
			HWDATA={$random}%255;

		     
		    end
		end
	INC_16:begin
                 @(posedge HCLK);

		wait(HREADYout)
	 	   HWRITE=1'b1;

		   HTRANS=NONSEQ;
	       	   HADDR=32'h8001_0000;
	          // @(posedge HCLK);
		 //  HWDATA={$random}%10000;
		    wait(HREADYout)
			HWRITE=1'b1;

			@(posedge HCLK);
			#3;
			HTRANS=SEQ;
			HADDR=HADDR+1'b1;
	          // @(posedge HCLK);
		
			HWDATA={$random}%10000;
		
		repeat(1)
		   begin
		     wait(HREADYout)
			HWRITE=1'b1;

			@(posedge HCLK);
			#3;
			HTRANS=SEQ;
			HADDR=HADDR+1'b1;
	          // @(posedge HCLK);
			HADDRreg = HADDR;	
			HWDATA={$random}%10000;
		   end
		repeat(1)
		   begin
		     wait(HREADYout)
			HWRITE=1'b1;

			@(posedge HCLK);
			#3;
			HTRANS=NONSEQ;
			HADDR={$random}%10000;//HADDR+1'b1;
	          // @(posedge HCLK);
		
			HWDATA={$random}%10000;
		   end
		   wait(HREADYout)
			HWRITE=1'b1;

			@(posedge HCLK);
			#3;
			HTRANS=SEQ;
			HADDR=HADDR+1'b1;
	          // @(posedge HCLK);
		
			HWDATA={$random}%10000;
			begin
		     wait(HREADYout)
			HWRITE=1'b1;

			@(posedge HCLK);
			#3;
			HTRANS=SEQ;
			//HADDR = HADDRreg+1'b1;
			HADDR=HADDR+1'b1;
	          // @(posedge HCLK);
		
			HWDATA={$random}%10000;
		   end
		repeat(10)
		   begin
		     wait(HREADYout)
			HWRITE=1'b1;

			@(posedge HCLK);
			#3;
			HTRANS=SEQ;
			//HADDR = HADDRreg+1'b1;
			HADDR=HADDR+1'b1;
	          // @(posedge HCLK);
		
			HWDATA={$random}%10000;
		   end
		 wait(HREADYout)
			@(posedge HCLK);
			#3;
			HWDATA={$random}%10000;

		    
		end
	
	WRAP_4:begin
		wait(HREADYout)
	 	   HWRITE=1'b1;

		   @(posedge HCLK);
		   HTRANS=NONSEQ;
	       	   HADDR=32'h8001_0000;
		   //HWDATA<={$random}%255;
		
		repeat(3)
		   begin
		     wait(HREADYout)
			HWRITE=1'b1;

			@(posedge HCLK);
			HTRANS=SEQ;
			HADDR={HADDR[31:3],HADDR[2:1]+1'b1,HADDR[0]};
			//HWDATA<={$random}%255;
		   end
		end


	INC_8:begin
		wait(HREADYout)
	//	@(posedge HCLK);
		 	   HWRITE=1'b1;

		   @(posedge HCLK);
			#3;

		   HTRANS=NONSEQ;
	       	   HADDR=32'h8001_0000;
		   //HWDATA<={$random}%255;
		
		repeat(7)
		   begin
		     wait(HREADYout)
			HWRITE=1'b1;

			@(posedge HCLK);
			#3;

			HTRANS=SEQ;
			HADDR=HADDR+1'b1;
			//HWDATA<={$random}%255;
		   end
		end
	endcase
    end
endtask



task burst_16;

begin
    case(HBURST)
	WRAP_8:begin
		wait(HREADYout)
	 	   HWRITE<=1'b1;

		   @(posedge HCLK);
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
	           @(posedge HCLK);
		   HWDATA<={$random}%1000;
		
		repeat(7)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b1;

			@(posedge HCLK);
			HTRANS<=SEQ;
			HADDR<={HADDR[31:5],HADDR[4:2]+1'b1,HADDR[1:0]};
	           @(posedge HCLK);
			HWDATA<={$random}%1000;
		   end
		end

	INC_16:begin
		wait(HREADYout)
	 	   HWRITE<=1'b1;

		   @(posedge HCLK);
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
	           @(posedge HCLK);
		   HWDATA<={$random}%1000;
		
		repeat(15)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b1;

			@(posedge HCLK);
			HTRANS<=SEQ;
			HADDR<=HADDR+2'b10;
	           @(posedge HCLK);
			HWDATA<={$random}%1000;
		   end
		end
	
	WRAP_4:begin
		wait(HREADYout)
	 	   HWRITE<=1'b1;

		   @(posedge HCLK);
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
		   //HWDATA<={$random}%255;
		
		repeat(3)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b1;

			@(posedge HCLK);
			HTRANS<=SEQ;
			HADDR<={HADDR[31:4],HADDR[3:2]+1'b1,HADDR[1:0]};
			//HWDATA<={$random}%255;
		   end
		end


	INC_8:begin
		wait(HREADYout)
	 	   HWRITE<=1'b1;

		   @(posedge HCLK);
#3;
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
		   //HWDATA<={$random}%255;
		
		repeat(7)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b1;

			@(posedge HCLK);
#3;
			HTRANS<=SEQ;
			HADDR<=HADDR+2'b10;
			//HWDATA<={$random}%255;
		   end
		end
	endcase
    end
endtask


/*
task burst_16();
integer i;
begin
    case(HBURST)
	WRAP_8:begin
		wait(HREADYout)
	 	   HWRITE<=1'b1;

		   @(posedge HCLK);
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
		   HWDATA<={$random}%1000;
		
		repeat(7)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b1;

			@(posedge HCLK);
			HTRANS<=SEQ;
			HADDR<={HADDR[31:5],HADDR[4:2]+1'b1,HADDR[1:0]};
			HWDATA<={$random}%1000;
		   end
		end

	INC_16:begin
		wait(HREADYout)
	 	   HWRITE<=1'b1;

		   @(posedge HCLK);
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
		   HWDATA<={$random}%1000;
		
		repeat(15)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b1;

			@(posedge HCLK);
			HTRANS<=SEQ;
			HADDR<=HADDR+2'b10;
			HWDATA<={$random}%1000;
		   end
		end
	
	WRAP_4:begin
		wait(HREADYout)
	 	   HWRITE<=1'b0;

		   @(posedge HCLK);
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
		   //HWDATA<={$random}%255;
		
		repeat(3)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b0;

			@(posedge HCLK);
			HTRANS<=SEQ;
			HADDR<={HADDR[31:4],HADDR[3:2]+1'b1,HADDR[1:0]};
			//HWDATA<={$random}%255;
		   end
		end


	INC_8:begin
		wait(HREADYout)
	 	   HWRITE<=1'b0;

		   @(posedge HCLK);
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
		   //HWDATA<={$random}%255;
		
		repeat(7)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b0;

			@(posedge HCLK);
			HTRANS<=SEQ;
			HADDR<=HADDR+2'b10;
			//HWDATA<={$random}%255;
		   end
		end
	endcase
    end
endtask

*/


task burst_32;

begin
    case(HBURST)
	WRAP_8:begin
		wait(HREADYout)
	 	   HWRITE<=1'b1;

		   @(posedge HCLK);
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
		   HWDATA<={$random}%255;
		
		repeat(7)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b1;

			@(posedge HCLK);
			HTRANS<=SEQ;
			HADDR<={HADDR[31:6],HADDR[5:3]+1'b1,HADDR[2:0]};
			HWDATA<={$random}%1000;
		   end
		end

	INC_16:begin
		wait(HREADYout)
	 	   HWRITE<=1'b1;

		   @(posedge HCLK);
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
		   HWDATA<={$random}%1000;
		
		repeat(15)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b1;

			@(posedge HCLK);
			HTRANS<=SEQ;
			HADDR<=HADDR+3'b100;
			HWDATA<={$random}%1000;
		   end
		end
	
	WRAP_4:begin
		wait(HREADYout)
	 	   HWRITE<=1'b1;

		   @(posedge HCLK);
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
		   //HWDATA<={$random}%255;
		
		repeat(3)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b1;

			@(posedge HCLK);
			HTRANS<=SEQ;
			HADDR<={HADDR[31:5],HADDR[4:3]+1'b1,HADDR[2:0]};
			//HWDATA<={$random}%255;
		   end
		end


	INC_8:begin
		wait(HREADYout)
	 	   HWRITE<=1'b1;

		   @(posedge HCLK);
		   HTRANS<=NONSEQ;
	       	   HADDR<=32'h8001_0000;
		   //HWDATA<={$random}%255;
		
		repeat(7)
		   begin
		     wait(HREADYout)
			HWRITE<=1'b1;

			@(posedge HCLK);
			HTRANS<=SEQ;
			HADDR<=HADDR+3'b100;
			//HWDATA<={$random}%255;
		   end
		end
	endcase
    end
endtask



initial
begin
//HREADYout<=1'b1;
if(~HRESETn)
  begin
    HADDR=0;
    HWRITE=0;
    HWDATA=0;
    HSIZE=0;
    HTRANS=0;
    HBURST=0;
  end

//hsize=8bit,  wrap-8,     &inc16

else
  begin
  HWRITE = 1'b1;
    HBURST=WRAP_8;
    HSIZE=3'b001;
    case(HSIZE)
	   EIGHT:burst_8;
	   SIXTEEN:burst_16;
	   THIRTY_TWO:burst_32;
    endcase
  end
#1000 $finish();
end

initial 
    $monitor("HCLK=%b,HRESETn=%b,HWRITE=%b,HREADYin=%b,HWDATA=%b,HADDR=%b,HTRANS=%b,HREADYout=%b,HRESP=%b,HRDATA=%b,HSIZE=%b", HCLK,HRESETn,HWRITE,HREADYin,HWDATA,HADDR,HTRANS,HREADYout,HRESP,HRDATA,HSIZE);
    
endmodule










       

	



			
			
		

	
	
    


