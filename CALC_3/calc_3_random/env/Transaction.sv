// Project		: COEN 6541	- CALC 2
// File Name	: Transaction.sv
// Description	: The transaction is a part of the environment. 
// This holds the fields required to generate the stimulus are declared in the transaction class.
// transaction class can also be used as placeholder for the activity monitored by monitor on 
// DUT signals. This trasaction file is for the generator to driver. 
//
// --------------------------------------------------------------------------

// Define the Calc interface:
`ifndef IF_DEFINE
`define IF_DEFINE
// Define the Calc1 Transaction:
`ifndef TRANS_DEFINE
`define TRANS_DEFINE

// Class Transaction: 
class Transaction;
 
	// Create user defined Data types for request command and input data: 
	typedef logic [0:3] cmd;
	typedef logic [0:1] tag;
	typedef logic [0:31] data;
	typedef logic [0:3] reg_d1;
  	typedef logic [0:3] reg_d2;
 	typedef logic [0:3] reg_r1;
 
	// Randomize the request command: 
	rand cmd reqcmd_a;
	rand cmd reqcmd_b;
	rand cmd reqcmd_c;
	rand cmd reqcmd_d;
	
	// Randomize the data 
	rand data data1, data2, data3, data4, data5, data6, data7, data8;
	
	// Randomize the request tag: 
	randc tag reqtag_a;
	randc tag reqtag_b;
	randc tag reqtag_c;
	randc tag reqtag_d;	
	
	// Randomize d1,d2 and r1
	 rand reg_d1 reqa_d1, reqb_d1, reqc_d1, reqd_d1;
 	 rand reg_d2 reqa_d2, reqb_d2, reqc_d2, reqd_d2;
 	 rand reg_r1 reqa_r1, reqb_r1, reqc_r1, reqd_r1;
	
	// Request command can have any one of the values: 0,1,2,5,6,9,10,12,13:
	constraint reqcmd_c1 {reqcmd_a inside {1,2,5,6,9,10};}
	constraint req1cmd { reqcmd_a dist{9:=80, 10:=10 , 1:=10};}
	constraint reqcmd_c2 {reqcmd_b inside {1,2,5,6,9,10};}
	constraint reqcmd_c3 {reqcmd_c inside {1,2,5,6,9,10};}
	constraint reqcmd_c4 {reqcmd_d inside {1,2,5,6,9,10};}
	
	
	//constraint req1cmd { reqcmd_a dist{9:=90, 10:=5 , 1:=5};}
	//constraint req2cmd { reqcmd_b dist{1:=90, 2:=10};}
	//constraint req3cmd { reqcmd_c dist{1:=90, 2:=10};}
	//constraint req4cmd { reqcmd_d dist{1:=90, 2:=10};}
	
	// Request command can have any one of the values: 0,1,2,3:
	constraint reqtag_a_c1 {reqtag_a inside {0,1,2,3};}
	constraint reqtag_b_c2 {reqtag_b inside {0,1,2,3};}
	constraint reqtag_c_c3 {reqtag_c inside {0,1,2,3};}
	constraint reqtag_d_c4 {reqtag_d inside {0,1,2,3};}	
	


	// Reset: 
	bit reset = 0;
 
	// Define the statice variable count and initialize it to '0':
	static int count=0;
	int ALU_count_a=0, Shift_count_a=0, nop_count_a=0;
	int ALU_count_b=0, Shift_count_b=0, nop_count_b=0;
	int ALU_count_c=0, Shift_count_c=0, nop_count_c=0;
	int ALU_count_d=0, Shift_count_d=0, nop_count_d=0;
	
	int id, trans_cnt;
	
	// Constructor: 
	function new;
		id = count++; // Increment the ID to note down the number of transaction
	endfunction
 
	// Function to print the data that has been generated:
	function void print_trans(string prefix);
   		$display ($time," : %s PORTA opcode : %d  dataa :  %h	tag: %h ALU_count_a: %d Shift_count_a: %d nop_count_a: %d",prefix, this.reqcmd_a, this.data1,  this.reqtag_a, this.ALU_count_a, this.Shift_count_a, this.nop_count_a);
		$display ($time," : %s PORTB opcode : %d  dataa :   %h	tag: %h ALU_count_b: %d Shift_count_b: %d nop_count_b: %d",prefix, this.reqcmd_b, this.data3, this.reqtag_b, this.ALU_count_b, this.Shift_count_b, this.nop_count_b);
		$display ($time," : %s PORTC opcode : %d  dataa :  %h	tag: %h ALU_count_c: %d Shift_count_c: %d nop_count_c: %d",prefix, this.reqcmd_c, this.data5, this.reqtag_c, this.ALU_count_c, this.Shift_count_c, this.nop_count_c);
		$display ($time," : %s PORTD opcode : %d  dataa :  %h	tag: %h ALU_count_d: %d Shift_count_d: %d nop_count_d: %d",prefix, this.reqcmd_d, this.data7, this.reqtag_d, this.ALU_count_d, this.Shift_count_d, this.nop_count_d);
	endfunction: print_trans
 
	// Function to create a copy of the object:
	function Transaction copy();
 
		Transaction copytr = new();
		//PORT-A:
		copytr.reqcmd_a = this.reqcmd_a;
		copytr.reqa_d1 = this.reqa_d1;
		copytr.reqa_d2 = this.reqa_d2;
		copytr.reqtag_a = this.reqtag_a;
		copytr.data1 = this.data1;
 		copytr.data2 = this.data2;
		copytr.reqa_r1 = this.reqa_r1;
		// PORT-B:
		copytr.reqcmd_b = this.reqcmd_b;
		copytr.reqb_d1 = this.reqb_d1;
 		copytr.reqb_d2 = this.reqb_d2;
		copytr.reqtag_b = this.reqtag_b;
		copytr.data3 = this.data3;
 		copytr.data4 = this.data4;
		copytr.reqb_r1 = this.reqb_r1;
		
		// PORT-C:
		copytr.reqcmd_c = this.reqcmd_c;
		copytr.reqc_d1 = this.reqc_d1;
 		copytr.reqc_d2 = this.reqc_d2;
		copytr.reqtag_c = this.reqtag_c;
		copytr.data5 = this.data5;
 		copytr.data6 = this.data6;
 		copytr.reqc_r1 = this.reqc_r1;
		// PORT-D:
		copytr.reqcmd_d = this.reqcmd_d;
		copytr.reqd_d1 = this.reqd_d1;
 		copytr.reqd_d2 = this.reqd_d2;
		copytr.reqtag_d = this.reqtag_d;
		copytr.data7 = this.data7;
		copytr.data8 = this.data8;
		copytr.reqd_r1 = this.reqd_r1;
		
		this.ALU_count_a=0;
		this.ALU_count_b=0;
		this.ALU_count_c=0;
		this.ALU_count_d=0;
		
		this.Shift_count_a=0;
		this.Shift_count_b=0;
		this.Shift_count_c=0;
		this.Shift_count_d=0;
		
		this.nop_count_a=0;
		this.nop_count_b=0;
		this.nop_count_c=0;
		this.nop_count_d=0;
		
		if (this.reqcmd_a == 1 || this.reqcmd_a == 2 || this.reqcmd_a == 10 || this.reqcmd_a == 9)
			this.ALU_count_a++;
		if (this.reqcmd_b == 1 || this.reqcmd_b == 2 || this.reqcmd_b == 10 || this.reqcmd_b == 9)
			this.ALU_count_b++;
		if (this.reqcmd_c == 1 || this.reqcmd_c == 2 || this.reqcmd_c == 10 || this.reqcmd_c == 9)
			this.ALU_count_c++;
		if (this.reqcmd_d == 1 || this.reqcmd_d == 2 || this.reqcmd_d == 10 || this.reqcmd_d == 9)
			this.ALU_count_d++;			
		if (this.reqcmd_a == 5 || this.reqcmd_a == 6)
		if (this.reqcmd_b == 5 || this.reqcmd_b == 6)
			this.Shift_count_b++;
		if (this.reqcmd_c == 5 || this.reqcmd_c == 6)
			this.Shift_count_c++;
		if (this.reqcmd_d == 5 || this.reqcmd_d == 6)
			this.Shift_count_d++;
		if (this.reqcmd_a == 0)
			this.nop_count_a++;
		if (this.reqcmd_b == 0)
			this.nop_count_b++;
		if (this.reqcmd_c == 0)
			this.nop_count_c++;
		if (this.reqcmd_d == 0)
			this.nop_count_d++;
			
		copytr.ALU_count_a=this.ALU_count_a;
		copytr.ALU_count_b=this.ALU_count_b;
		copytr.ALU_count_c=this.ALU_count_c;
		copytr.ALU_count_d=this.ALU_count_d;
		
		copytr.Shift_count_a=this.Shift_count_a;
		copytr.Shift_count_b=this.Shift_count_b;
		copytr.Shift_count_c=this.Shift_count_c;
		copytr.Shift_count_d=this.Shift_count_d;
		
		copytr.nop_count_a=this.nop_count_a;
		copytr.nop_count_b=this.nop_count_b;
		copytr.nop_count_c=this.nop_count_c;
		copytr.nop_count_d=this.nop_count_d;
		
		// Deep copy:
		copy = copytr;
		
		this.ALU_count_a=0;
		this.ALU_count_b=0;
		this.ALU_count_c=0;
		this.ALU_count_d=0;
		
		this.Shift_count_a=0;
		this.Shift_count_b=0;
		this.Shift_count_c=0;
		this.Shift_count_d=0;
		
		this.nop_count_a=0;
		this.nop_count_b=0;
		this.nop_count_c=0;
		this.nop_count_d=0;
		
	endfunction: copy
 
endclass: Transaction
`endif 
`endif

// --------------------------------------------------------------------------
// End of Transaction.sv
// --------------------------------------------------------------------------