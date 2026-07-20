class monitor;
	transaction t1;
	mailbox#(transaction)mbx_mon_sco;
	virtual apb_if.MON vif;
	function new(virtual apb_if.MON vif,mailbox#(transaction)mbx_mon_sco);
		this.vif=vif;
		this.mbx_mon_sco=mbx_mon_sco;
	endfunction
	task run();
		wait(vif.mon_cb.PRESETn==1);
		repeat(1) @(vif.mon_cb);
		for(int i=1;i<=`STIMULUS;i++) begin
			@(vif.mon_cb);
			t1=new();
			t1.PADDR=vif.mon_cb.PADDR; 
			t1.PSEL=vif.mon_cb.PSEL;
			t1.PENABLE=vif.mon_cb.PENABLE;
			t1.PWRITE=vif.mon_cb.PWRITE;
			t1.PWDATA=vif.mon_cb.PWDATA;
			t1.PSTRB=vif.mon_cb.PSTRB;
			t1.rdata_out=vif.mon_cb.rdata_out;
			t1.transfer_done=vif.mon_cb.transfer_done;
			t1.error=vif.mon_cb.error;
			mbx_mon_sco.put(t1);
			$display("MONITOR(%d)@(%0t): PADDR=%0h, PSEL=%0b, PENABLE=%0b, PWRITE=%0b, PWDATA=%0h, PSTRB=%0b, rdata_out=%0h, transfer_done=%0b, error=%0b",i,
				$time,t1.PADDR,t1.PSEL,t1.PENABLE,t1.PWRITE,t1.PWDATA,t1.PSTRB,t1.rdata_out,t1.transfer_done,t1.error);
		end
	endtask
endclass
