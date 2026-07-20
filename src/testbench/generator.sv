class generator;
	transaction t1;
	mailbox #(transaction) mbx_gen_drv;
	function new(mailbox #(transaction) mbx_gen_drv);
		this.mbx_gen_drv=mbx_gen_drv;
		t1=new();
	endfunction
	task run();
		for(int i=1;i<=`STIMULUS;i++) begin
			assert(t1.randomize());
			mbx_gen_drv.put(t1.copy());
			$display("Generator testcase@(%0t):%0d PRDATA:%0h PREADY:%0b PSLVERR:%0b transfer:%0b write_read:%0b addr_in:%0h wdata_in:%0h strb_in:%0b",
				$time,i,t1.PRDATA,t1.PREADY,t1.PSLVERR,t1.transfer,t1.write_read,t1.addr_in,t1.wdata_in,t1.strb_in);
		end
	endtask
endclass
