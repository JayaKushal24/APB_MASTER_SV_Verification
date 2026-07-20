class test;
	virtual apb_if.DRV drv_vif;
	virtual apb_if.MON mon_vif;
	environment env;
	function new(virtual apb_if.DRV drv_vif,virtual apb_if.MON mon_vif);
		this.drv_vif=drv_vif;
		this.mon_vif=mon_vif;
	endfunction
	task run();
		env=new(drv_vif,mon_vif);
		env.build();
		env.run();
	endtask
endclass

class test1 extends test;
	transaction1 trans1;
  	function new(virtual apb_if drv_vif,virtual apb_if mon_vif);//need to change here
    	super.new(drv_vif,mon_vif);
  	endfunction
  	task run();
    	env=new(drv_vif,mon_vif);
    	env.build();
    	trans1=new();
    	env.gen.t1= trans1;
    	env.run();
  	endtask
endclass

class test2 extends test;
	transaction2 trans2;
  	function new(virtual apb_if drv_vif,virtual apb_if mon_vif);
    	super.new(drv_vif,mon_vif);
  	endfunction
  	task run();
    	env=new(drv_vif,mon_vif);
    	env.build();
    	trans2=new();
    	env.gen.t1= trans2;
    	env.run();
  	endtask
endclass

class test3 extends test;
	transaction3 trans3;
  	function new(virtual apb_if drv_vif,virtual apb_if mon_vif);
    	super.new(drv_vif,mon_vif);
  	endfunction
  	task run();
    	env=new(drv_vif,mon_vif);
    	env.build();
    	trans3=new();
    	env.gen.t1= trans3;
    	env.run();
  	endtask
endclass

class test4 extends test;
	transaction4 trans4;
  	function new(virtual apb_if drv_vif,virtual apb_if mon_vif);
    	super.new(drv_vif,mon_vif);
  	endfunction
  	task run();
    	env=new(drv_vif,mon_vif);
    	env.build();
    	trans4=new();
    	env.gen.t1= trans4;
    	env.run();
  	endtask
endclass

class test_regression extends test;
	transaction1 trans1;
	transaction2 trans2;
	transaction3 trans3;
	transaction4 trans4;
  	function new(virtual apb_if drv_vif,virtual apb_if mon_vif);
    	super.new(drv_vif,mon_vif);
 	endfunction
 	task run();
    	env=new(drv_vif,mon_vif);
   	env.build;
    		
   	trans1 =new();
   	env.gen.t1=trans1;
   	env.run();
			
   	trans2 =new();
	env.gen.t1=trans2;
    	env.run();
   	
	trans3 =new();
    	env.gen.t1=trans3;
    	env.run();
   	 	
	trans4 =new();
    	env.gen.t1=trans4;
    	env.run();
  
	endtask
endclass
