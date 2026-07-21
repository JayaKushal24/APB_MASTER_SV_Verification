class reference_model;
        transaction t1;
        mailbox#(transaction)mbx_drv_ref;
        mailbox#(transaction)mbx_ref_sco;
        typedef enum {idle,setup,access}state;
        state c_state=idle;

        bit [`DATA_WIDTH-1:0]prev_rdata_out,prev_pwdata;//to store prev values..internal registers
        bit [`ADDR_WIDTH-1:0]prev_addr;
        bit prev_pwrite;
        bit [(`DATA_WIDTH)/8-1:0]prev_strb;
        bit flag_transfer_done,flag_error;

        function new(mailbox#(transaction)mbx_drv_ref,mailbox#(transaction)mbx_ref_sco);
                this.mbx_drv_ref=mbx_drv_ref;
                this.mbx_ref_sco=mbx_ref_sco;
        endfunction

        task run();
                for(int i=0;i<`STIMULUS;i++)begin
                        mbx_drv_ref.get(t1);
                        $display("REF_INPUTS@(%0t):Reset:%0b PRDATA:%0h PREADY:%0b PSLVERR:%0b transfer:%0b write_read:%0b addr_in:%0h wdata_in:%0h strb_in:%0b",
                                $time,t1.reset,t1.PRDATA,t1.PREADY,t1.PSLVERR,t1.transfer,t1.write_read,t1.addr_in,t1.wdata_in,t1.strb_in);
                        if (t1.reset==0) begin
                                c_state=idle;
                                t1.PADDR=0;
                                t1.rdata_out=0;
                                t1.error=0;
                                t1.PSTRB=0;
                                t1.PWDATA=0;
                                t1.PWRITE=0;
                                t1.transfer_done=0;
                                t1.PENABLE=0;
                                t1.PSEL=0;
                                prev_addr=0;
                                prev_pwrite=0;
                                prev_strb=0;
                                prev_pwdata=0;
				prev_rdata_out=0;
				flag_error=0;
				flag_transfer_done=0;
			end
                        else if(t1.reset==1) begin
                                if(c_state==idle) begin
                                        t1.PSEL=0;
                                        //t1.transfer_done=0;
                                        t1.PENABLE=0;
                                        t1.error=0;
                                        t1.PADDR=prev_addr;
                                        t1.PWRITE=prev_pwrite;
                                        t1.PSTRB=prev_strb;
                                        t1.rdata_out=prev_rdata_out;
                                        t1.PWDATA=prev_pwdata;
                                        if(flag_transfer_done)begin//to delay by 1 cycle
                                                t1.transfer_done=1;
                                                flag_transfer_done=0;
										end
                                        else    t1.transfer_done=0;
                                        if(flag_error)begin
                                                t1.error=1;
                                                flag_error=0;
                                        end
                                        else    t1.error=0;
                                        if(t1.transfer==1) c_state=setup;
                                end
                                else if (c_state==setup) begin
                                        t1.PSEL=1;
                                        t1.PENABLE=0;
                                //      t1.transfer_done=0;
                                //      t1.error=0;
                                        t1.PADDR=prev_addr;
                                        t1.PWRITE=prev_pwrite;
                                        t1.PSTRB=prev_strb;
                                        t1.rdata_out=prev_rdata_out;
                                        t1.PWDATA=prev_pwdata;
                                        if(flag_transfer_done)begin//to delay by 1 cycle
                                                t1.transfer_done=1;
                                                flag_transfer_done=0;
										end
                                        else    t1.transfer_done=0;
                                        if(flag_error)begin
                                                t1.error=1;
                                                flag_error=0;
                                        end
                                        else    t1.error=0;

                                        c_state=access;
                                end else if (c_state==access) begin
                                        t1.PSEL=1;
                                        t1.PENABLE=1;
                                        t1.PADDR=t1.addr_in;
                                        prev_addr=t1.addr_in;
                                        t1.PWRITE=t1.write_read;
                                        prev_pwrite=t1.write_read;
                                        if(t1.PWRITE==1) begin//writing
                                                t1.PWDATA=t1.wdata_in;
                                                t1.rdata_out=prev_rdata_out;
                                                prev_pwdata=t1.wdata_in;
                                                t1.PSTRB=t1.strb_in;
                                                prev_strb=t1.strb_in;
                                        end
                                        else begin//reading
                                                t1.rdata_out=prev_rdata_out;
                                                t1.PWDATA=0;
                                                prev_pwdata=0;
                                                prev_strb=0;
                                                t1.PSTRB=0;
                                                prev_strb=0;
                                        end
                                        if (t1.PREADY==1) begin
                                                //t1.transfer_done=1;
                                                flag_transfer_done=1;
                                                //t1.error=t1.PSLVERR;
                                                flag_error=t1.PSLVERR;
                                                if(t1.PWRITE==0) begin
                                                        t1.rdata_out=t1.PRDATA;
                                                        prev_rdata_out=t1.PRDATA;
                                                end

                                                if(t1.transfer==1)                      c_state=setup;
                                                else if (t1.transfer==0)        c_state=idle;
                                        end
                                        else begin
                        t1.transfer_done=0;
                        t1.error=0;
                    end
                                end
                        end
                        $display("REF_EXPECTED@(%0t): PADDR=%0h, PSEL=%0b, PENABLE=%0b, PWRITE=%0b, PWDATA=%0h, PSTRB=%0b, rdata_out=%0h, transfer_done=%0b, error=%0b",
                                                $time,t1.PADDR,t1.PSEL,t1.PENABLE,t1.PWRITE,t1.PWDATA,t1.PSTRB,t1.rdata_out,t1.transfer_done,t1.error);
                        mbx_ref_sco.put(t1);
                end
        endtask
endclass

