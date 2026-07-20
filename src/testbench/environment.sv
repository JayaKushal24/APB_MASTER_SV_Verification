class environment;
	mailbox#(transaction)mbx_gen_drv;
	mailbox#(transaction)mbx_drv_ref;
	mailbox#(transaction)mbx_ref_sco;
	mailbox#(transaction)mbx_mon_sco;
	
	generator gen;
	driver drv;
	monitor mon;
	reference_model ref_model;
	scoreboard sco;
	
	virtual apb_if.DRV drv_vif;
	virtual apb_if.MON mon_vif;
	
	function new(virtual apb_if.DRV drv_if,virtual apb_if.MON mon_if);
		this.drv_vif=drv_if;
		this.mon_vif=mon_if;
	endfunction
	
	task build();
		begin
			mbx_gen_drv=new();
			mbx_drv_ref=new();
			mbx_ref_sco=new();
			mbx_mon_sco=new();
			gen=new(mbx_gen_drv);
			drv=new(mbx_gen_drv,mbx_drv_ref,drv_vif);
			mon=new(mon_vif,mbx_mon_sco);
			ref_model=new(mbx_drv_ref,mbx_ref_sco);
			sco=new(mbx_ref_sco,mbx_mon_sco);
		end
	endtask
	
	task run();
		fork
			gen.run();
			drv.run();
			ref_model.run();
			mon.run();
			sco.run();
		join
		sco.final_report();
	endtask
	
endclass
