`include "../design/APB_Master.sv"
`include "package.svh"
`include "interface.sv"

module top();
	import apb_package::*;
	logic clk=0;
	logic reset;
	initial begin
		forever #5 clk=~clk;
	end
	initial begin
		reset=1;
		@(posedge clk);
		reset=0;
		repeat(1)@(posedge clk);
		reset=1;
		repeat(100)@(posedge clk);
	end
	apb_if 	vif	(clk,reset);
	APB 	DUT	(.PCLK(clk),.PRESETn(reset),//bridge-dut
			.transfer(vif.transfer),.write_read(vif.write_read),.addr_in(vif.addr_in),.wdata_in(vif.wdata_in),.strb_in(vif.strb_in),//bridge-dut
			.PRDATA(vif.PRDATA),.PREADY(vif.PREADY),.PSLVERR(vif.PSLVERR),//slave-dut
			.PADDR(vif.PADDR),.PSEL(vif.PSEL),.PENABLE(vif.PENABLE),.PWRITE(vif.PWRITE),.PWDATA(vif.PWDATA),.PSTRB(vif.PSTRB),//dut-slave
			.rdata_out(vif.rdata_out),.transfer_done(vif.transfer_done),.error(vif.error));//dut-bridge
					
//test1 t=new(vif.DRV,vif.MON);
//test2 t=new(vif.DRV,vif.MON);
//test3 t=new(vif.DRV,vif.MON);
//test4 t=new(vif.DRV,vif.MON);
//test_regression t= new(vif.DRV,vif.MON);
	`ifdef TEST1
	        test1 t=new(vif.DRV,vif.MON);
	`elsif TEST2
	        test2 t=new(vif.DRV,vif.MON);
	`elsif TEST3
	        test3 t=new(vif.DRV,vif.MON);
	`elsif TEST4
	        test4 t=new(vif.DRV,vif.MON);
	`elsif TEST5 
	        test_regression t =new(vif.DRV,vif.MON);
	`else
	        initial begin
	                $error("No test selected");
	                $finish;
	        end
	`endif
	initial begin
		t.run();
		$finish();
	end
endmodule
