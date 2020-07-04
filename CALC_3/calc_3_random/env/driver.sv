// Project		: COEN 6541 - CALC 2
// File Name	: driver.sv
// Description	: The driver is a part of the environment. This is used to convert 
// low level commands to inputs of DUT
//
// --------------------------------------------------------------------------

// Define the Calc Driver interface: 
`define CALC_DRIVER_IF calc_driver_if.driver_cb

// Include the transaction and interface files:
`include "env/Transaction.sv"
`include "env/IF.sv"

// Class Driver: 
class Driver;
	
	virtual calc_if.driver calc_driver_if;
    Transaction trans; // Create handle for the class transaction.
    mailbox #(Transaction) gen2drv; // Mailbox to receive data from generator and pass the same to scoreboard.
  
	bit verbose;	  
	
	// Constructor:
	function new (virtual calc_if.driver calc_driver_if, mailbox #(Transaction) gen2drv, bit verbose = 0);
		this.calc_driver_if = calc_driver_if;
		this.gen2drv = gen2drv;
		this.verbose = verbose;
	endfunction: new

	// Main Task: 
	task main();  

		if (verbose)
		$display($time," : ------------starting calc driver----------\n");
  
		forever begin
    
		gen2drv.get(trans); // Use mailbox and receive the data that was sent from the generator. 
    
		if (verbose)
			trans.print_trans("Driver");  
   
		if (trans.reset == 0) begin
			cmd_data_send();
			#1000;
			
		end  
		else begin
			reset();
		end
		end 
  
		if (verbose)
			$display($time," : ending driver transaction \n"); 

	endtask : main

task reset();
  `CALC_DRIVER_IF.reset <= 1'b1;
  `CALC_DRIVER_IF.reqcmd_a <= 4'b0000;
  `CALC_DRIVER_IF.reqa_data <= 32'h00000000;
  `CALC_DRIVER_IF.reqtag_a <= 2'b00;
  `CALC_DRIVER_IF.reqa_d1 <= 4'b0000;  
  `CALC_DRIVER_IF.reqa_d2 <= 4'b0000;  
  `CALC_DRIVER_IF.reqa_r1 <= 4'b0000; 
 
  
  `CALC_DRIVER_IF.reqcmd_b <= 4'b0000;
  `CALC_DRIVER_IF.reqb_data <= 32'h00000000;
  `CALC_DRIVER_IF.reqtag_b <= 2'b00;
  `CALC_DRIVER_IF.reqb_d1 <= 4'b0000;  
  `CALC_DRIVER_IF.reqb_d2 <= 4'b0000;  
  `CALC_DRIVER_IF.reqb_r1 <= 4'b0000; 
  
  
  `CALC_DRIVER_IF.reqcmd_c <= 4'b0000;
  `CALC_DRIVER_IF.reqc_data <= 32'h00000000;
  `CALC_DRIVER_IF.reqtag_c <= 2'b00;
  `CALC_DRIVER_IF.reqc_d1 <= 4'b0000;  
  `CALC_DRIVER_IF.reqc_d2 <= 4'b0000;  
  `CALC_DRIVER_IF.reqc_r1 <= 4'b0000; 
  
  
  `CALC_DRIVER_IF.reqcmd_d <= 4'b0000;
  `CALC_DRIVER_IF.reqd_data <= 32'h00000000;
  `CALC_DRIVER_IF.reqtag_d <= 2'b00;
  `CALC_DRIVER_IF.reqd_d1 <= 4'b0000;  
  `CALC_DRIVER_IF.reqd_d2 <= 4'b0000;  
  `CALC_DRIVER_IF.reqd_r1 <= 4'b0000;
  
  @`CALC_DRIVER_IF; 
  @`CALC_DRIVER_IF;
  @`CALC_DRIVER_IF;
  @`CALC_DRIVER_IF; 
  @`CALC_DRIVER_IF;
  @`CALC_DRIVER_IF;
  @`CALC_DRIVER_IF;
  `CALC_DRIVER_IF.reset <= 1'b0;
  $display ($time, " : reset complete \n");
  endtask : reset   

	// Task to send command and data: 
	task cmd_data_send();
	begin
	
		@`CALC_DRIVER_IF;
   
		$display("\n",$time," : ------------Sending data-1 on all port of dut----------");
    
		// PORT-A:
		`CALC_DRIVER_IF.reqcmd_a <= trans.reqcmd_a;
		`CALC_DRIVER_IF.reqa_data <= trans.data1;
		`CALC_DRIVER_IF.reqtag_a <= trans.reqtag_a;
		`CALC_DRIVER_IF.reqa_d1 <= trans.reqa_d1;  
          	`CALC_DRIVER_IF.reqa_d2 <= trans.reqa_d2;  
  		`CALC_DRIVER_IF.reqa_r1 <= trans.reqa_r1;
		
		$display("\n",$time,": 1 trans.my_cmda %h",trans.reqcmd_a);
		$display($time,": A trans.my_dataa %h",trans.data1);
		$display($time,": A trans.reqtag_a %h",trans.reqtag_a);
		$display($time,": A trans.reqa_d1 %h",trans.reqa_d1);
		$display($time,": A trans.reqa_d2 %h",trans.reqa_d2);
		$display($time,": A trans.reqa_r1 %h",trans.reqa_r1);
		
		// PORT-B:
		`CALC_DRIVER_IF.reqcmd_b <= trans.reqcmd_b;
		`CALC_DRIVER_IF.reqb_data <= trans.data3;
		`CALC_DRIVER_IF.reqtag_b <= trans.reqtag_b;
		`CALC_DRIVER_IF.reqb_d1 <= trans.reqb_d1;  
 		`CALC_DRIVER_IF.reqb_d2 <= trans.reqb_d2;  
 		`CALC_DRIVER_IF.reqb_r1 <= trans.reqb_r1;
		$display($time,": \n \n 2 trans.my_cmdb %h",trans.reqcmd_b);
		$display($time,": B trans.my_datab %h",trans.data3);
		$display($time,": B trans.reqtag_b %h",trans.reqtag_b);
		$display($time,": B trans.reqb_d1 %h",trans.reqb_d1);
		$display($time,": B trans.reqb_d2 %h",trans.reqb_d2);
		$display($time,": B trans.reqb_r1 %h",trans.reqb_r1);
		
		// PORT-C:
		`CALC_DRIVER_IF.reqcmd_c <= trans.reqcmd_c;
		`CALC_DRIVER_IF.reqc_data <= trans.data5;
		`CALC_DRIVER_IF.reqtag_c <= trans.reqtag_c;
		`CALC_DRIVER_IF.reqc_d1 <= trans.reqc_d1;  
 		`CALC_DRIVER_IF.reqc_d2 <= trans.reqc_d2;  
  		`CALC_DRIVER_IF.reqc_r1 <= trans.reqc_r1; 
		$display($time,":\n \n 3 trans.my_cmdc %h",trans.reqcmd_c);
		$display($time,": C trans.my_datac %h",trans.data5);
		$display($time,": C trans.reqtag_c %h",trans.reqtag_c);
		$display($time,": C trans.reqc_d1 %h",trans.reqc_d1);
		$display($time,": C trans.reqc_d2 %h",trans.reqc_d2);
		$display($time,": C trans.reqc_r1 %h",trans.reqc_r1);
		
		// PORT-D:
		`CALC_DRIVER_IF.reqcmd_d <= trans.reqcmd_d;
		`CALC_DRIVER_IF.reqd_data <= trans.data7;
		`CALC_DRIVER_IF.reqtag_d <= trans.reqtag_d;
 		`CALC_DRIVER_IF.reqd_d1 <= trans.reqd_d1;  
		`CALC_DRIVER_IF.reqd_d2 <= trans.reqd_d2;  
		`CALC_DRIVER_IF.reqd_r1 <= trans.reqd_r1; 
		$display($time,": \n \n 4 trans.my_cmdd %h",trans.reqcmd_d);
		$display($time,": D trans.my_datad %h",trans.data7);
		$display($time,": D trans.reqtag_d %h\n",trans.reqtag_d);
		$display($time,": D trans.reqd_d1 %h",trans.reqd_d1);
		$display($time,": D trans.reqd_d2 %h",trans.reqd_d2);
		$display($time,": D trans.reqd_r1 %h",trans.reqd_r1);

		//------------------------------------------------data2 pass--------------------------------------------	
	/*	@`CALC_DRIVER_IF;
	   
		$display("\n",$time," : ------------Sending data-2 on all port of dut----------");
		// PORT-A:
		`CALC_DRIVER_IF.reqcmd_a <= 4'b0000;
		`CALC_DRIVER_IF.reqa_data <= 32'h00000000;
		 `CALC_DRIVER_IF.reqtag_a <= 2'b00;
	
		// PORT-B: 
		`CALC_DRIVER_IF.reqcmd_b <= 4'b0000;
		`CALC_DRIVER_IF.reqb_data <= 32'h00000000;
		 `CALC_DRIVER_IF.reqtag_b <= 2'b00;
	
		// PORT-C: 
		`CALC_DRIVER_IF.reqcmd_c <= 4'b0000;
		`CALC_DRIVER_IF.reqc_data <= 32'h00000000;
		`CALC_DRIVER_IF.reqtag_c <= 2'b00;
	
		// PORT-D:
		`CALC_DRIVER_IF.reqcmd_d <= 4'b0000;
		`CALC_DRIVER_IF.reqd_data <= 32'h00000000;
		 `CALC_DRIVER_IF.reqtag_d <= 2'b00;    */
	  
	  
	end
	endtask : cmd_data_send

endclass : Driver

// --------------------------------------------------------------------------
// End of calc_driver.sv
// --------------------------------------------------------------------------