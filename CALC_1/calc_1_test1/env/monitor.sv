// Project		: COEN 6541 - CALC 2
// File Name	: calc_monitor.sv
// Description	: The monitor is a part of the environment. Monitor converts
// outputs of DUT to low level transaction results
// 
// --------------------------------------------------------------------------

// Define the Monitor interface: 
`define CALC_MONITOR_IF	calc_monitor_if.monitor_cb

// Include the transaction, dut_out and interface files: 
`include "env/Transaction.sv"
`include "env/dut_out_a.sv"
`include "env/dut_out_b.sv"
`include "env/dut_out_c.sv"
`include "env/dut_out_d.sv"
`include "env/IF.sv"

// Class Monitor: 
class monitor;
	
	// Declare variables for verbose and transaction count: 
	bit verbose;
	int trans_cnt = 0;
	
	// Handle for the class dut_out: used to get outputs from the DUT:
	dut_out_A from_dut_A;
	dut_out_B from_dut_B;
	dut_out_C from_dut_C;
	dut_out_D from_dut_D;
	
	virtual calc_if.monitor calc_monitor_if;	// Virtual interface for calc_monitor
    mailbox #(dut_out_A) mon2scb_A;					// mailbox to send the data from the monitor to scoreboard.
    mailbox #(dut_out_B) mon2scb_B;					// mailbox to send the data from the monitor to scoreboard.
    mailbox #(dut_out_C) mon2scb_C;					// mailbox to send the data from the monitor to scoreboard.
    mailbox #(dut_out_D) mon2scb_D;					// mailbox to send the data from the monitor to scoreboard.
  
	// Constructor Function: 
	function new(virtual calc_if.monitor calc_monitor_if,mailbox #(dut_out_A) mon2scb_A, mailbox #(dut_out_B) mon2scb_B, mailbox #(dut_out_C) mon2scb_C, mailbox #(dut_out_D) mon2scb_D, bit verbose = 0); 
		this.calc_monitor_if = calc_monitor_if;
		this.mon2scb_A = mon2scb_A;
		this.mon2scb_B = mon2scb_B;
		this.mon2scb_C = mon2scb_C;
		this.mon2scb_D = mon2scb_D;
		this.verbose = verbose;		
	endfunction : new
  
	// Main Task:
	task main(); 
		from_dut_A= new();
		from_dut_B= new();
		from_dut_C= new();
		from_dut_D= new();
  
		forever begin

		begin 
		fork
				// Get responses only when there is an input command:
				out_get_response_A();
				out_get_response_B();
				out_get_response_C();
				out_get_response_D();		
		join
		end
		
		#100;

		if (verbose)
			from_dut_A.print_response("monitor");
			from_dut_B.print_response("monitor");
			from_dut_C.print_response("monitor");
			from_dut_D.print_response("monitor");
		end
	endtask : main

	// Task to get the response from the DUT:

	// PORT-A
	task out_get_response_A (); 
	begin
		
			@(`CALC_MONITOR_IF.out_dataa or `CALC_MONITOR_IF.out_respa == 0 or `CALC_MONITOR_IF.out_respa == 1 or `CALC_MONITOR_IF.out_respa == 2 or `CALC_MONITOR_IF.out_respa == 3);
			$display("\n",$time, "   ----------Monitor Recieving data from Port -A out of Dut----------");
			from_dut_A.out_respa = `CALC_MONITOR_IF.out_respa;
			from_dut_A.out_dataa = `CALC_MONITOR_IF.out_dataa;
			$display($time," : out_respa %h",from_dut_A.out_respa);
			$display($time," : out_dataa %h",from_dut_A.out_dataa);
			mon2scb_A.put(from_dut_A); // Forward the values to the Scoreboard using mail box. 
	
	end
	endtask: out_get_response_A
	
	// PORT-B
	task out_get_response_B (); 
	begin
			@(`CALC_MONITOR_IF.out_datab or `CALC_MONITOR_IF.out_respb == 0 or `CALC_MONITOR_IF.out_respb == 1 or `CALC_MONITOR_IF.out_respb == 2 or `CALC_MONITOR_IF.out_respb == 3 );
			$display("\n",$time, "   ----------Monitor Recieving data from Port -B out of Dut----------"); 
			from_dut_B.out_respb = `CALC_MONITOR_IF.out_respb;
			from_dut_B.out_datab = `CALC_MONITOR_IF.out_datab;
			$display($time," : out_respb %h",from_dut_B.out_respb);
			$display($time," : out_datab %h",from_dut_B.out_datab);
			mon2scb_B.put(from_dut_B); // Forward the values to the Scoreboard using mail box. 
	
	end
	endtask: out_get_response_B

	// PORT-C:		
	task out_get_response_C (); 
	begin
		
			@(`CALC_MONITOR_IF.out_datac or `CALC_MONITOR_IF.out_respc == 0 or `CALC_MONITOR_IF.out_respc == 1 or `CALC_MONITOR_IF.out_respc == 2 or `CALC_MONITOR_IF.out_respc == 3);
			$display("\n",$time, "   ----------Monitor Recieving data from Port -C out of Dut----------");	
			from_dut_C.out_respc = `CALC_MONITOR_IF.out_respc;
			from_dut_C.out_datac = `CALC_MONITOR_IF.out_datac;
			$display($time," : out_respc %h",from_dut_C.out_respc);
			$display($time," : out_datac %h",from_dut_C.out_datac);
			mon2scb_C.put(from_dut_C); // Forward the values to the Scoreboard using mail box. 
	
	end
	endtask: out_get_response_C

	// PORT-D:		
	task out_get_response_D (); 
	begin
		
			@(`CALC_MONITOR_IF.out_datad or `CALC_MONITOR_IF.out_respd == 0 or `CALC_MONITOR_IF.out_respd == 1 or `CALC_MONITOR_IF.out_respd == 2 or `CALC_MONITOR_IF.out_respd == 3);
			$display("\n",$time, "   ----------Monitor Recieving data from Port -D out of Dut----------");
			from_dut_D.out_respd = `CALC_MONITOR_IF.out_respd;
			from_dut_D.out_datad = `CALC_MONITOR_IF.out_datad;
			$display($time," : out_respd %h",from_dut_D.out_respd);
			$display($time," : out_datad %h",from_dut_D.out_datad);
			mon2scb_D.put(from_dut_D); // Forward the values to the Scoreboard using mail box. 
	end
	endtask : out_get_response_D

endclass : monitor

// --------------------------------------------------------------------------
// End of monitor.sv
// --------------------------------------------------------------------------
  