// Project		: COEN 6541 - CALC1
// File Name	: IF.sv
// Description	: The interface is a part of the environment. Interface will group the signals, 
// specifies the direction (Modport) and Synchronize the signals(Clocking Block).
// 
// --------------------------------------------------------------------------

// Define the calc interface: 
`ifndef CALC1_IF_DEFINE
`define CALC1_IF_DEFINE

// class interface: 
interface calc_if(input bit c_clk,a_clk,b_clk);

	// Inputs and Outputs of the DUT: 
	logic [0:3]  reqcmd_a,reqcmd_b,reqcmd_c,reqcmd_d;
	logic [0:31] reqa_dataa_in,reqb_dataa_in,reqc_dataa_in,reqd_dataa_in;
	bit [0:31] out_dataa,out_datab,out_datac,out_datad;
	bit [0:1]  out_respa,out_respb,out_respc,out_respd;
	logic [1:7]  reset;

	logic [0:3] 	error_found=1111;
	reg	scan_in;
	reg scan_out;

	// Clocking block - Driver: 
	clocking driver_cb @(posedge c_clk);
		// Input to DUT from driver- Request command:
		output reqcmd_a;
		output reqcmd_b;
		output reqcmd_c;
		output reqcmd_d;
		// Input to DUT from driver- Data: 
		output reqa_dataa_in;
		output reqb_dataa_in;
		output reqc_dataa_in;
		output reqd_dataa_in;
		// Input to DUT from driver- Reset: 
		output reset;
	endclocking

	// Clocking block - Monitor:
	clocking monitor_cb @(posedge c_clk);
		// Output from DUT to Monitor- Output Response:
		input out_respa;
		input out_respb;
		input out_respc;
		input out_respd;
		// Output from DUT to Monitor- Output Data:
		input out_dataa;
		input out_datab;
		input out_datac;
		input out_datad;
	endclocking

	// Modports for driver, monitor and Driver: 
	modport driver (clocking driver_cb);
	modport monitor (clocking monitor_cb);
	modport DUT (input reqcmd_a,reqcmd_b,reqcmd_c,reqcmd_d,reqa_dataa_in,reqb_dataa_in,reqc_dataa_in,reqd_dataa_in,reset, a_clk, b_clk, c_clk, scan_in,
             output out_respa,out_respb,out_respc,out_respd,out_dataa,out_datab,out_datac,out_datad, error_found, scan_out );


endinterface
`endif

// --------------------------------------------------------------------------
// End of IF.sv
// --------------------------------------------------------------------------