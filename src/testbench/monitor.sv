class monitor;
	transaction t1;
	mailbox#(transaction)mbx_mon_sco;
	virtual apb_if.MON vif;
        covergroup mon_cg;
		cp_transfer_done: coverpoint t1.transfer_done {
		        bins pending = {0};
		        bins done    = {1};
		}
		cp_error:coverpoint t1.error{
		        bins no_error={0};
			bins slave_error={1};
		}
		cp_apb_state: coverpoint{t1.PSEL,t1.PENABLE}{
			bins idle_state={2'b00};
		        bins setup_state={2'b10};
		        bins access_state={2'b11};
		        illegal_bins invalid_state={2'b01};
		}
                cp_state_transition: coverpoint({t1.PSEL,t1.PENABLE}){
	                bins idle_setup=(2'b00=>2'b10);
	                bins setup_access=(2'b10=>2'b11);
		        bins access_idle =(2'b11=>2'b00);
			bins access_setup=(2'b11=>2'b10);
		}
	endgroup



	function new(virtual apb_if.MON vif,mailbox#(transaction)mbx_mon_sco);
		this.vif=vif;
		this.mbx_mon_sco=mbx_mon_sco;
		mon_cg=new();
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
			mon_cg.sample();
		end
	endtask
endclass
