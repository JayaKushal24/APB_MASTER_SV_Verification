class transaction;
    rand logic [`DATA_WIDTH-1:0]PRDATA,wdata_in;
    rand logic PREADY, PSLVERR, transfer,write_read;
    rand logic [`ADDR_WIDTH-1:0]addr_in;
    rand logic [(`DATA_WIDTH/8)-1:0]strb_in;
    logic reset;
    logic [`ADDR_WIDTH-1:0]PADDR;
    logic PSEL,PENABLE,PWRITE,transfer_done,error;
    logic [`DATA_WIDTH-1:0]PWDATA,rdata_out;
    logic [(`DATA_WIDTH/8)-1:0]PSTRB;
   
    logic [`DATA_WIDTH-1:0]stable_prd,stable_wd;//internal registers
    logic stable_psler,stable_wr;
    logic [`ADDR_WIDTH-1:0]stable_ad;
    logic [(`DATA_WIDTH/8)-1:0]stable_str;
    
    bit [3:0] count=0;
    constraint c_freeze_data{
        if (count!=0){
            PRDATA==const'(stable_prd);
            wdata_in==const'(stable_wd);
            PSLVERR==const'(stable_psler);
            write_read==const'(stable_wr);
            addr_in==const'(stable_ad);
            strb_in==const'(stable_str);
        }
    }

    function void post_randomize();
        if (count!=0)	count=count+1;
        else begin
            stable_prd=PRDATA;
            stable_wd=wdata_in;
            stable_psler=PSLVERR;
            stable_wr=write_read;
            stable_ad=addr_in;
            stable_str=strb_in;
        end
    endfunction

    virtual function transaction copy();
        transaction cp=new();
        cp.PRDATA=this.PRDATA;
        cp.wdata_in=this.wdata_in;
        cp.transfer=this.transfer;
        cp.write_read=this.write_read;
        cp.PREADY=this.PREADY;
        cp.PSLVERR=this.PSLVERR;
        cp.addr_in=this.addr_in;
        cp.strb_in=this.strb_in;
        return cp;
    endfunction
endclass

class transaction1 extends transaction;
    function void post_randomize();
        super.post_randomize();
        if (count==0) begin 
            transfer=1;//idle-setup-access-idle-setup-access...
            count++; 
        end
        if (count==4) begin 
            PREADY=1; 
            transfer=0; 
            count=0; 
        end else	PREADY=0;
    endfunction

    virtual function transaction copy();
        transaction1 copy1=new();
        copy1.PRDATA=this.PRDATA;
        copy1.wdata_in=this.wdata_in;
        copy1.transfer=this.transfer;
        copy1.write_read=this.write_read;
        copy1.PREADY=this.PREADY;
        copy1.PSLVERR=this.PSLVERR;
        copy1.addr_in=this.addr_in;
        copy1.strb_in=this.strb_in;
        return copy1;
    endfunction
endclass


class transaction2 extends transaction;
    function void post_randomize();
        super.post_randomize();
        if (count==0) begin 
            transfer=1; 
            count++; 
        end	
        if (count==4) begin 
            PREADY=1;i//reacrtive 
            transfer=1; //always 1..so idle-setup-access-setup-access...with wait states
            count=0; 
        end else PREADY=0;
    endfunction

    virtual function transaction copy();
        transaction2 copy1 = new();
        copy1.PRDATA=this.PRDATA;
        copy1.wdata_in=this.wdata_in;
        copy1.transfer=this.transfer;
        copy1.write_read=this.write_read;
        copy1.PREADY=this.PREADY;
        copy1.PSLVERR=this.PSLVERR;
        copy1.addr_in=this.addr_in;
        copy1.strb_in=this.strb_in;
        return copy1;
    endfunction
endclass


class transaction3 extends transaction;
    function void post_randomize();
        super.post_randomize();
        PREADY=1;//always 1..proactive..no wait states
        if (count==0) begin 
            transfer=1; 
            count++; 
        end else begin
            transfer=0;
        end
        if (count==4) count=0;
    endfunction

    virtual function transaction copy();
        transaction3 copy1=new();
        copy1.PRDATA=this.PRDATA;
        copy1.wdata_in=this.wdata_in;
        copy1.transfer=this.transfer;
        copy1.write_read=this.write_read;
        copy1.PREADY=this.PREADY;
        copy1.PSLVERR=this.PSLVERR;
        copy1.addr_in=this.addr_in;
        copy1.strb_in=this.strb_in;
        return copy1;
    endfunction
endclass

class transaction4 extends transaction;
    bit first_cycle=0;//flag
    function void post_randomize();
        super.post_randomize();
        PREADY=1;//proacrive...no wait states
        transfer=1;//always 1..so it goes from idle-setup-access-setup-access and loops 
        if (count==0)count++;
        
	if ((first_cycle==0)&&(count==3)) begin//first cycle 3 clk after that 2 clks
            count=0; 
            first_cycle=1; 
        end 
        else if ((first_cycle==1)&&(count==2)) count=0;
    endfunction

    virtual function transaction copy();
        transaction4 copy1 = new();
        copy1.PRDATA=this.PRDATA;
        copy1.wdata_in=this.wdata_in;
        copy1.transfer=this.transfer;
        copy1.write_read=this.write_read;
        copy1.PREADY=this.PREADY;
        copy1.PSLVERR=this.PSLVERR;
        copy1.addr_in=this.addr_in;
        copy1.strb_in=this.strb_in;
        return copy1;
    endfunction
endclass
