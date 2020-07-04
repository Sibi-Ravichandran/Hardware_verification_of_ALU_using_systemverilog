// Project		: COEN 6541 - CALC 1
// File Name	: top.sv
// Description	: This file is used to integrate the test bench with the DUT. 
//
// --------------------------------------------------------------------------

module top; // Define Top module

	parameter simulation_cycle = 100; // Set the simulation_cycle as 100 time units.
    bit a_clk, b_clk, c_clk;
	// for every 50 time units toggle the clock. 
	always #(simulation_cycle/2) 
	begin 
		a_clk = ~a_clk;	
		b_clk = ~b_clk;
		c_clk = ~c_clk;
	end
 
	calc_if cif(a_clk, b_clk, c_clk); 	// Handle for calc1 interface 
	test t1(cif);  					// Testbench program
	calc1_top   c1(cif.out_dataa,cif.out_datab,cif.out_datac,cif.out_datad,
                 cif.out_respa,cif.out_respb,cif.out_respc,cif.out_respd,                 
                 cif.scan_out,cif.a_clk,cif.b_clk, cif.c_clk,cif.error_found,
                 cif.reqcmd_a, cif.reqa_dataa_in,
                 cif.reqcmd_b, cif.reqb_dataa_in,
                 cif.reqcmd_c, cif.reqc_dataa_in,
                 cif.reqcmd_d, cif.reqd_dataa_in, 
                 cif.reset,cif.scan_in ); 

endmodule  

// --------------------------------------------------------------------------
// End of top.sv
// --------------------------------------------------------------------------