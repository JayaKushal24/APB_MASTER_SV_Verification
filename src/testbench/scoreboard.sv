class scoreboard;
	transaction t1,t2;
	mailbox#(transaction)mbx_ref_sco;
	mailbox#(transaction)mbx_mon_sco;
	int pass_count=0;
	int fail_count=0;
	function new(mailbox#(transaction)mbx_ref_sco,mailbox#(transaction)mbx_mon_sco);
		this.mbx_ref_sco=mbx_ref_sco;
		this.mbx_mon_sco=mbx_mon_sco;
	endfunction
	task run();
		repeat(`STIMULUS)begin
			mbx_ref_sco.get(t1);
			mbx_mon_sco.get(t2);
			$display("SCB_REF@(%0t) PADDR=%0h, PSEL=%0b, PENABLE=%0b, PWRITE=%0b, PWDATA=%0h, PSTRB=%0b, rdata_out=%0h, transfer_done=%0b, error=%0b",
				$time,t1.PADDR,t1.PSEL,t1.PENABLE,t1.PWRITE,t1.PWDATA,t1.PSTRB,t1.rdata_out,t1.transfer_done,t1.error);
			$display("SCB_MON@(%0t) PADDR=%0h, PSEL=%0b, PENABLE=%0b, PWRITE=%0b, PWDATA=%0h, PSTRB=%0b, rdata_out=%0h, transfer_done=%0b, error=%0b",
				$time,t2.PADDR,t2.PSEL,t2.PENABLE,t2.PWRITE,t2.PWDATA,t2.PSTRB,t2.rdata_out,t2.transfer_done,t2.error);
			compare_report();
			$display("*******************************************************************************************************************");
		end
	endtask
	
	task compare_report();
		if((t1.PSEL==1)&&(t1.PENABLE==1)&&(t1.PREADY==1)&&(t1.PSLVERR==1)) begin
			if(t1.PSLVERR==t2.PSLVERR) begin
				pass_count=pass_count+1;
				$display("pass_count :%d",pass_count);
			end else begin
				fail_count=fail_count+1;
				$display("fail_count :%d",fail_count);
			end
		end 
		else begin
			if((t1.PADDR===t2.PADDR)&&(t1.PSEL===t2.PSEL)&&(t1.PENABLE===t2.PENABLE)&&(t1.PWRITE===t2.PWRITE)&&(t1.PWDATA===t2.PWDATA)&&(t1.PSTRB===t2.PSTRB)&&
					(t1.rdata_out===t2.rdata_out)&&(t1.transfer_done===t2.transfer_done)&&(t1.error===t2.error))begin	
				pass_count=pass_count+1;
				$display("pass_count :%d",pass_count);
			end else begin
				fail_count=fail_count+1;
				$display("fail_count :%d",fail_count);
			end
		end
	endtask
	
	task final_report();
		$display("****************************************************");
		$display("Total tests@every clk: %0d",pass_count+fail_count);
		$display("Total Pass: %d",pass_count);
		$display("Total Fail: %d",fail_count);
		$display("****************************************************");		
	endtask
	
endclass
