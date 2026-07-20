class driver;
    transaction t1;
    mailbox #(transaction) mbx_gen_drv;
    mailbox #(transaction) mbx_drv_ref;
	
    virtual apb_if.DRV vif;

    function new(mailbox #(transaction)mbx_gen_drv,mailbox #(transaction)mbx_drv_ref,virtual apb_if.DRV vif);
        this.mbx_gen_drv=mbx_gen_drv;
        this.mbx_drv_ref=mbx_drv_ref;
        this.vif=vif;
    endfunction

    task run();
        wait(vif.drv_cb.PRESETn==1);
        @(vif.drv_cb);
        //@(vif.drv_cb);
        for (int i=1; i<=`STIMULUS;i++) begin
            mbx_gen_drv.get(t1);
            //@(vif.drv_cb);
            vif.drv_cb.PRDATA<=t1.PRDATA;
            vif.drv_cb.PREADY<=t1.PREADY;
            vif.drv_cb.PSLVERR<=t1.PSLVERR;
            vif.drv_cb.transfer<=t1.transfer;
            vif.drv_cb.write_read<=t1.write_read;
            vif.drv_cb.addr_in<=t1.addr_in;
            vif.drv_cb.wdata_in<=t1.wdata_in;
            vif.drv_cb.strb_in<=t1.strb_in;
            @(vif.drv_cb);
            t1.reset=vif.drv_cb.PRESETn;
	    $display("driver testcase@(%0t):%0d PRDATA:%0h PREADY:%0b PSLVERR:%0b transfer:%0b write_read:%0b addr_in:%0h wdata_in:%0h strb_in:%0b",
		    	$time,i,t1.PRDATA,t1.PREADY,t1.PSLVERR,t1.transfer,t1.write_read,t1.addr_in,t1.wdata_in,t1.strb_in);		
            mbx_drv_ref.put(t1);
        end
    endtask
endclass
