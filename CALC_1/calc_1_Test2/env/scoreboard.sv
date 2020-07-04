// Project		: COEN 6541 - CALC 2
// File Name	: scoreboard.sv
// Description	: The scoreboard is a part of the environment. This predicts the 
// results of the commands sent to the DUT and also check whether the expected value 
// is same as the actual result value obtained from the DUT. 
//
// --------------------------------------------------------------------------

// Include the transaction and dut_out file: 
`include "env/Transaction.sv"
`include "env/dut_out_a.sv"
`include "env/dut_out_b.sv"
`include "env/dut_out_c.sv"
`include "env/dut_out_d.sv"


// Class scoreboard:
class scoreboard;

	int max_trans_cnt;
	bit verbose;
	event ended;
	
	// Variable to note the correct results: 
	int correct1, correct2, correct3, correct4;
	bit [0:31] overflow_limit = 32'h FFFFFFFF;

	Transaction to_dut;		// Handle for the class transaction 
	dut_out_A from_dut_A;
	dut_out_B from_dut_B;
	dut_out_C from_dut_C;
	dut_out_D from_dut_D;	// Handle for the class dut_out 
	mailbox #(Transaction) gen2scb;	// mailbox to send data from driver to scoreboard
	mailbox #(dut_out_A)mon2scb_A;  // mailbox to send data from monitor to scoreboard
    mailbox #(dut_out_B)mon2scb_B;
	mailbox #(dut_out_C)mon2scb_C;
	mailbox #(dut_out_D)mon2scb_D;
	
	
	// variables for calculating the expected result:
	bit [0:1] expected_respa, expected_respb, expected_respc, expected_respd;
	bit [0:31] expected_dataa, expected_datab, expected_datac, expected_datad;
	bit [0:35] overflow_output_a;
	bit [0:35] overflow_output_b;
	bit [0:35] overflow_output_c;
	bit [0:35] overflow_output_d;

	// Constructor function 
	function new (int max_trans_cnt, mailbox #(Transaction) gen2scb, mailbox #(dut_out_A) mon2scb_A, mailbox #(dut_out_B) mon2scb_B, mailbox #(dut_out_C) mon2scb_C, mailbox #(dut_out_D) mon2scb_D, bit verbose = 0);
	
		this.max_trans_cnt = max_trans_cnt;
		this.gen2scb = gen2scb;
		this.mon2scb_A = mon2scb_A;
		this.mon2scb_B = mon2scb_B;
		this.mon2scb_C = mon2scb_C;
		this.mon2scb_D = mon2scb_D;
		this.verbose = verbose;
	endfunction

	// Task to calculate the expected data and response: 
	task expected_output();

		//------------------------------------ADDITION cmd=0001------------------------// 
		// PORT-A:
		if (to_dut.reqcmd_a== 4'b0001) 
		begin
			expected_dataa  = to_dut.reqa_dataa_in + to_dut.reqa_datab_in;
			overflow_output_a = to_dut.reqa_dataa_in + to_dut.reqa_datab_in;
			if((expected_dataa< to_dut.reqa_dataa_in) && (expected_dataa< to_dut.reqa_datab_in) || overflow_limit < overflow_output_a)
				expected_respa = 2'b10;		

		end
		// PORT-B:
		if (to_dut.reqcmd_b== 4'b0001) 
		begin
			expected_datab 		= to_dut.reqb_dataa_in + to_dut.reqb_datab_in;
			overflow_output_b 	= to_dut.reqb_dataa_in + to_dut.reqb_datab_in;
			if((expected_datab< to_dut.reqb_dataa_in) && (expected_datab< to_dut.reqb_datab_in) || overflow_limit < overflow_output_b)
				expected_respb = 2'b10;
		end
		// PORT-C:
		if (to_dut.reqcmd_c== 4'b0001) 
		begin
			expected_datac = to_dut.reqc_dataa_in + to_dut.reqc_datab_in;
			overflow_output_c = to_dut.reqc_dataa_in + to_dut.reqc_datab_in;
			if((expected_datac< to_dut.reqc_dataa_in) && (expected_datac< to_dut.reqc_datab_in) || overflow_limit < overflow_output_c)
				expected_respc = 2'b10;
		end
		// PORT-D:
		if (to_dut.reqcmd_d== 4'b0001)
		begin
			expected_datad = to_dut.reqd_dataa_in + to_dut.reqd_datab_in;
			overflow_output_d = to_dut.reqd_dataa_in + to_dut.reqd_datab_in;
			if((expected_datad< to_dut.reqd_dataa_in) && (expected_datad< to_dut.reqd_datab_in) || overflow_limit < overflow_output_d)
				expected_respd = 2'b10;
		end  
  
		//------------------------------------SUBTRACTION cmd=0010------------------------//
		// PORT-A:
		if (to_dut.reqcmd_a== 4'b0010) 
		begin
			expected_dataa = to_dut.reqa_dataa_in - to_dut.reqa_datab_in;
			if(to_dut.reqa_dataa_in< to_dut.reqa_datab_in)
				expected_respa = 2'b10;
		end
		// PORT-B:
		if (to_dut.reqcmd_b== 4'b0010) 
		begin
			expected_datab = to_dut.reqb_dataa_in - to_dut.reqb_datab_in;
			if(to_dut.reqb_dataa_in< to_dut.reqb_datab_in)
				expected_respb = 2'b10;
		end
		// PORT-C:
		if (to_dut.reqcmd_c== 4'b0010) 
		begin
			expected_datac = to_dut.reqc_dataa_in - to_dut.reqc_datab_in;
			if(to_dut.reqc_dataa_in< to_dut.reqc_datab_in)
				expected_respc = 2'b10;
		end
		// PORT-D:
		if (to_dut.reqcmd_d== 4'b0010) 
		begin
			expected_datad = to_dut.reqd_dataa_in - to_dut.reqd_datab_in;
			if(to_dut.reqd_dataa_in< to_dut.reqd_datab_in)
				expected_respd = 2'b10;
		end 
		
		//------------------------------------LEFT SHIFT cmd=0101------------------------//
		// PORT-A:
		if (to_dut.reqcmd_a== 4'b0101) 
		begin
			expected_dataa = (to_dut.reqa_dataa_in << (to_dut.reqa_datab_in & 31));
			expected_respa = 2'b01;
		end
		// PORT-B:
		if (to_dut.reqcmd_b== 4'b0101) 
		begin
			expected_datab = (to_dut.reqb_dataa_in << (to_dut.reqb_datab_in & 31));
			expected_respb = 2'b01;
		end  
		// PORT-C:
		if (to_dut.reqcmd_c== 4'b0101) 
		begin
			expected_datac = (to_dut.reqc_dataa_in << (to_dut.reqc_datab_in & 31));
			expected_respc = 2'b01;
		end
		// PORT-D:
		if (to_dut.reqcmd_d== 4'b0101) 
		begin
			expected_datad = (to_dut.reqd_dataa_in << (to_dut.reqd_datab_in & 31));
			expected_respd = 2'b01;
		end
		
		//------------------------------------RIGHT SHIFT cmd=0110------------------------//
		// PORT-A:
		if (to_dut.reqcmd_a== 4'b0110) 
		begin 
			expected_dataa = (to_dut.reqa_dataa_in >> (to_dut.reqa_datab_in & 31));
			expected_respa = 2'b01;
		end
		// PORT-B:
		if (to_dut.reqcmd_b== 4'b0110) 
		begin
			expected_datab = (to_dut.reqb_dataa_in >> (to_dut.reqb_datab_in & 31));
			expected_respb = 2'b01;
		end
		// PORT-C:
		if (to_dut.reqcmd_c== 4'b0110) 
		begin
			expected_datac = (to_dut.reqc_dataa_in >> (to_dut.reqc_datab_in & 31));
			expected_respc = 2'b01;
		end
		// PORT-D:
		if (to_dut.reqcmd_d== 4'b0110) 
		begin
			expected_datad = (to_dut.reqd_dataa_in >> (to_dut.reqd_datab_in & 31));
			expected_respd = 2'b01;
		end
 
		//--------------------------------cmd=invalid---------------------------//
		// PORT-A:
		if ((to_dut.reqcmd_a==3)||(to_dut.reqcmd_a==4)||(to_dut.reqcmd_a>6))
			expected_respa = 2'b10;
		// PORT-B:
		if ((to_dut.reqcmd_b==3)||(to_dut.reqcmd_b==4)||(to_dut.reqcmd_b>6))
			expected_respb = 2'b10;
		// PORT-C:
		if ((to_dut.reqcmd_c==3)||(to_dut.reqcmd_c==4)||(to_dut.reqcmd_c>6))
			expected_respc = 2'b10;
		// PORT-D:
		if ((to_dut.reqcmd_d==3)||(to_dut.reqcmd_d==4)||(to_dut.reqcmd_d>6))
			expected_respd = 2'b10;
			
				//--------------------------------cmd=no operation---------------------------//
		// PORT-A:
		if (to_dut.reqcmd_a==4'b0000)
			expected_respa = 2'b00;
		// PORT-B:
		if (to_dut.reqcmd_b==4'b0000)
			expected_respb = 2'b00;
		// PORT-C:
		if (to_dut.reqcmd_c==4'b0000)
			expected_respc = 2'b00;
		// PORT-D:
		if (to_dut.reqcmd_d==4'b0000)
			expected_respd = 2'b00;

		// Check whether the actual and expected values are the same on all ports of the DUT:
		// PORT-A:
		if(from_dut_A.out_respa==2'b00 && expected_respa==2'b00)
		begin
			$display ($time, " : Match! No response!: PORT-A : expected dataa : %h  output_dataa : %h",expected_dataa,from_dut_A.out_dataa);
			$display ($time, " : Match! No response: PORT-A : no response : expected responsea : %h  output_responsea : %h\n",expected_respa, from_dut_A.out_respa);
		end
		else if (from_dut_A.out_respa==2'b11)
			$display ($time, " : ERROR! : PORT-A unsued response %h\n",from_dut_A.out_respa);
		else if (from_dut_A.out_respa==2'b10 && expected_respa==2'b10)
			$display ($time, " : Match! Congrats!! : PORT-A overflow/underflow or invalid command %h\n",from_dut_A.out_respa);
		else 
		begin
			if (expected_dataa != from_dut_A.out_dataa )
				$display ($time, " : ERROR! not match : PORT-A expected data : %h  output_data : %h\n",expected_dataa,from_dut_A.out_dataa);
			else 
			begin
				$display($time, " : Data match at PORT-A");
				$display ($time, " : Match! Congrats!! : PORT-A expected data : %h  output_data : %h\n",expected_dataa,from_dut_A.out_dataa);  
				correct1++;
			end
		end
   
		// PORT-B:
		if(from_dut_B.out_respb==2'b00) 
		begin
			$display ($time, " : Match! No response! : PORT-B : expected datab : %h  output_datab : %h",expected_datab,from_dut_B.out_datab);
			$display ($time, " : Match! No response! : PORT-B : no response : expected responseb : %h  output_responseb : %h\n",expected_respb, from_dut_B.out_respb);
		end
		else if (from_dut_B.out_respb==2'b11)
			$display ($time, " : ERROR! : PORT-B unsued response %h\n",from_dut_B.out_respb);
		else if (from_dut_B.out_respb==2'b10 && expected_respb==2'b10)
			$display ($time, " : Match! Congrats!! : PORT-B overflow/underflow or invalid command %h\n",from_dut_B.out_respb);
		else 
		begin
			if (expected_datab != from_dut_B.out_datab) 
				$display ($time, " : ERROR! : PORT-B expected data : %h  output_data : %h\n",expected_datab, from_dut_B.out_datab);
			else 
			begin
				$display($time, " : Data match at PORT-B"); 
				$display ($time, " : Match! Congrats!! : PORT-B expected data : %h  output_data : %h\n",expected_datab,from_dut_B.out_datab);  
				correct2++;
			end
		end

		// PORT-C:
		if(from_dut_C.out_respc==2'b00) 
		begin
			$display ($time, " : Match! No response! : PORT-C : expected datac : %h  output_datac : %h",expected_datac,from_dut_C.out_datac);
			$display ($time, " : Match! No response! : PORT-C : no response : expected responsec : %h  output_responsec : %h\n",expected_respc, from_dut_C.out_respc);
		end
		else if (from_dut_C.out_respc==2'b11)
			$display ($time, " : ERROR! : PORT-C unsued response %h\n",from_dut_C.out_respc);
		else if (from_dut_C.out_respc==2'b10 && expected_respc==2'b10)
			$display ($time, " : Match! Congrats!! : PORT-C overflow/underflow or invalid command %h\n",from_dut_C.out_respc);
		else 
		begin
			if (expected_datac != from_dut_C.out_datac)
				$display ($time, " : ERROR! : PORT-C expected data : %h  output_data : %h\n",expected_datac,from_dut_C.out_datac);
			else 
			begin
				$display($time, ": Data match at PORT-C");
				$display ($time, " : Match! Congrats!! : PORT-C expected data : %h  output_data : %h\n",expected_datac,from_dut_C.out_datac);  
				correct3++;
			end
		end 
    
		// PORT-D:
		if(from_dut_D.out_respd==2'b00) 
		begin
			$display ($time, " : Match! No response! : PORT-D : expected datad : %h  output_datad : %h",expected_datad,from_dut_D.out_datad);
			$display ($time, " : Match! No response! : PORT-D : no response : expected responsed : %h  output_responsed : %h\n",expected_respd, from_dut_D.out_respd);
		end
		else if (from_dut_D.out_respd==2'b11)
			$display ($time, " : ERROR! : PORT-D unsued response %h\n",from_dut_D.out_respd);
		else if (from_dut_D.out_respd==2'b10 && expected_respd==2'b10)
			$display ($time, " :  Match! Congrats!! : PORT-D overflow/underflow or invalid command %h\n",from_dut_D.out_respd);
		else
		begin
			if (expected_datad != from_dut_D.out_datad) 
				$display ($time, " : ERROR! : PORT-D expected data : %h  output_data : %h\n",expected_datad, from_dut_D.out_datad);
			else
			begin
				$display($time, " : Data match at PORT-D"); 
				$display ($time, " : Match! Congrats!! : PORT-D expected data : %h  output_data : %h\n",expected_datad,from_dut_D.out_datad);
				correct4++;
			end
		end
	
	endtask : expected_output

	// Main Task: 
	task main(); 
  
		$display("\n",$time," : scoreboard for %d transactions", max_trans_cnt);
 
	forever 
	begin
   
		gen2scb.get(to_dut);	// get the values from the driver 
		
		mon2scb_A.get(from_dut_A);  // get the values from the monitor
		mon2scb_B.get(from_dut_B);  // get the values from the monitor
		mon2scb_C.get(from_dut_C);  // get the values from the monitor
		mon2scb_D.get(from_dut_D);  // get the values from the monitor
  
		to_dut.print_trans("Scoreboard vals from generator");
		from_dut_A.print_response("Scoreboard vals from DUT PORT-A");
		from_dut_B.print_response("Scoreboard vals from DUT PORT-B");
		from_dut_C.print_response("Scoreboard vals from DUT PORT-C");
		from_dut_D.print_response("Scoreboard vals from DUT PORT-D");

			expected_output();
		 
		if(--max_trans_cnt<1) 
		begin
			-> ended;
		end 
	end
endtask: main

endclass: scoreboard

// ----------------------------------------------------------------------------
// End of scoreboard.sv
// ----------------------------------------------------------------------------