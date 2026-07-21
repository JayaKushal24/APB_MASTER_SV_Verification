class driver;
    transaction t1;
    mailbox #(transaction) mbx_gen_drv;
    mailbox #(transaction) mbx_drv_ref;
	
    virtual apb_if.DRV vif;
	covergroup drv_cg;
        cp_transfer: coverpoint t1.transfer{
                bins no_transfer={0};
                bins transfer={1};
        }
        cp_write_read: coverpoint t1.write_read{
                bins read={0};
                bins write={1};
        }
        cp_addr: coverpoint t1.addr_in{
                bins low  ={[0:63]};
                bins mid_1 ={[64:127]};
                bins mid_2 ={[128:191]};
                bins high ={[192:255]};
        }
        cp_strb: coverpoint t1.strb_in{
                bins single_byte={4'b0001};
                bins l_halfword={4'b0011};
                bins u_halfword={4'b1100};
                bins full_word={4'b1111};
                bins no_word={4'b0000};
                bins others=default;
        }
	cp_wdata: coverpoint t1.wdata_in{
		option.auto_bin_max=16;
	}
        cross_transfer_rw: cross cp_transfer,cp_write_read;
	cross_wr_addr: cross cp_write_read,cp_addr;
	cross_wr_strb: cross cp_write_read,cp_strb{
                ignore_bins read_strb=binsof(cp_write_read.read);
		}
        cross_transfer_addr: cross cp_transfer,cp_addr {
                ignore_bins no_transfer_addr=binsof(cp_transfer.no_transfer);
        }
endgroup
    function new(mailbox #(transaction)mbx_gen_drv,mailbox #(transaction)mbx_drv_ref,virtual apb_if.DRV vif);
        this.mbx_gen_drv=mbx_gen_drv;
        this.mbx_drv_ref=mbx_drv_ref;
        this.vif=vif;
		drv_cg=new();
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
			$display("driver testcase@(%0t):%0d PRDATA:%0h PREADY:%0b PSLVERR:%0b transfer:%0b write_read:%0b addr_in:%0h wdata_in:%0h strb_in:%0b",$time,i,t1.PRDATA,t1.PREADY,t1.PSLVERR,t1.transfer,t1.write_read,t1.addr_in,t1.wdata_in,t1.strb_in);
			drv_cg.sample();
            mbx_drv_ref.put(t1);
        end
    endtask
endclass
