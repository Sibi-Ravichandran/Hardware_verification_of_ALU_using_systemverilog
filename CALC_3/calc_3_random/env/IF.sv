// Project		: COEN 6541 - CALC 3
// File Name	: IF.sv
// Description	: The interface is a part of the environment. Interface will group the signals, 
// specifies the direction (Modport) and Synchronize the signals(Clocking Block).
// 
// --------------------------------------------------------------------------

// Define the calc interface: 
`ifndef CALC3_IF_DEFINE
`define CALC3_IF_DEFINE

// class interface: 
interface calc_if(input bit c_clk,a_clk,b_clk);

	// Inputs and Outputs of the DUT: 
	logic [0:3]  reqcmd_a,reqcmd_b,reqcmd_c,reqcmd_d;
	logic [0:1]  reqtag_a,reqtag_b,reqtag_c,reqtag_d;
	logic [0:31] reqa_data,reqb_data,reqc_data,reqd_data;
	logic [0:3] reqa_d1, reqb_d1, reqc_d1, reqd_d1;
	logic [0:3] reqa_d2, reqb_d2, reqc_d2, reqd_d2;
	logic [0:3] reqa_r1, reqb_r1, reqc_r1, reqd_r1;
	bit [0:31] out_dataa,out_datab,out_datac,out_datad;
	bit [0:1]  out_respa,out_respb,out_respc,out_respd;
	bit [0:1]  out_tag_a,out_tag_b,out_tag_c,out_tag_d;
	logic reset;
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
		output reqa_data;
		output reqb_data;
		output reqc_data;
		output reqd_data;
		// Input to DUT from Driver- Input Tag:
		output reqtag_a;
		output reqtag_b;
		output reqtag_c;
		output reqtag_d;
		// Input to DUT from driver- Reset: 

 		output reqa_d1;
		output reqb_d1;
		output reqc_d1;
		output reqd_d1;
	
		output reqa_d2;
		output reqb_d2;
		output reqc_d2;
		output reqd_d2;

		output reqa_r1;
		output reqb_r1;
		output reqc_r1;
		output reqd_r1;
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
		// Output from DUT to Monitor - Output Tag:
		input out_tag_a;
		input out_tag_b;
		input out_tag_c;
		input out_tag_d;
	endclocking

	// Modports for driver, monitor and Driver: 
	modport driver (clocking driver_cb);
	modport monitor (clocking monitor_cb);
	

        modport DUT (output out_dataa, out_respa, out_tag_a, 
                   out_datab, out_respb, out_tag_b, 
                   out_datac, out_respc, out_tag_c, 
                   out_datad, out_respd, out_tag_d, 
                   scan_out, 
                  input a_clk, b_clk, c_clk, 
                   reqcmd_a, reqa_d1, reqa_d2, reqa_data, reqa_r1, reqtag_a, 
                   reqcmd_b, reqb_d1, reqb_d2, reqb_data, reqb_r1, reqtag_b, 
                   reqcmd_c, reqc_d1, reqc_d2, reqc_data, reqc_r1, reqtag_c, 
                   reqcmd_d, reqd_d1, reqd_d2, reqd_data, reqd_r1, reqtag_d, 
                   reset, scan_in);

endinterface
`endif

// --------------------------------------------------------------------------
// End of IF.sv
// --------------------------------------------------------------------------