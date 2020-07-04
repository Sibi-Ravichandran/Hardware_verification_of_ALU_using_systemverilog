// Project		: COEN 6541 - CALC 3
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
	
	
	calc3_top c1 ( cif.out_dataa, cif.out_respa, cif.out_tag_a, 
                   cif.out_datab, cif.out_respb, cif.out_tag_b, 
                   cif.out_datac, cif.out_respc, cif.out_tag_c, 
                   cif.out_datad, cif.out_respd, cif.out_tag_d, 
                   cif.scan_out, cif.a_clk, cif.b_clk, cif.c_clk, 
                   cif.reqcmd_a, cif.reqa_d1, cif.reqa_d2, cif.reqa_data, cif.reqa_r1, cif.reqtag_a, 
                   cif.reqcmd_b, cif.reqb_d1, cif.reqb_d2, cif.reqb_data, cif.reqb_r1, cif.reqtag_b, 
                   cif.reqcmd_c, cif.reqc_d1, cif.reqc_d2, cif.reqc_data, cif.reqc_r1, cif.reqtag_c, 
                   cif.reqcmd_d, cif.reqd_d1, cif.reqd_d2, cif.reqd_data, cif.reqd_r1, cif.reqtag_d, 
                   cif.reset, cif.scan_in);
endmodule  

// --------------------------------------------------------------------------
// End of top.sv
// --------------------------------------------------------------------------