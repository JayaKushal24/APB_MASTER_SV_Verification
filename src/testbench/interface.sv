`include "defines.svh"

interface apb_if(input logic PCLK,input logic PRESETn);
	logic [`DATA_WIDTH-1:0]PWDATA,PRDATA,wdata_in,rdata_out;
    logic [`ADDR_WIDTH-1:0]PADDR,addr_in;
    logic PSEL,PENABLE,PWRITE,PREADY,PSLVERR,transfer,write_read,transfer_done,error;
    logic [(`DATA_WIDTH/8)-1:0]strb_in,PSTRB;
	
	clocking drv_cb@(posedge PCLK);
		default input #1 output #1;
		input PRESETn;
		output PRDATA,PREADY,PSLVERR,transfer,write_read,addr_in,wdata_in,strb_in;
	endclocking
	
	clocking mon_cb@(posedge PCLK); 
		default input #1 output #1;
		input PRESETn,PADDR,PSEL,PENABLE,PWRITE,PWDATA,PSTRB,rdata_out,transfer_done,error;
	endclocking
	
	modport DRV(clocking drv_cb);
	modport MON(clocking mon_cb);
	
endinterface
