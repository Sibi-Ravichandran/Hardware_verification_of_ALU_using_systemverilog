package A;
class coverage;
  logic [0:3] reqcmd_a,reqcmd_b,reqcmd_c,reqcmd_d;
  logic [0:31] reqa_data, reqb_data, reqc_data, reqd_data;
  
 covergroup cg;
   coverpoint reqcmd_a;
   coverpoint reqcmd_b;
   coverpoint reqcmd_c;
   coverpoint reqcmd_d;
   coverpoint reqa_data;
   coverpoint reqb_data;
   coverpoint reqc_data;
   coverpoint reqd_data;
  

 endgroup : cg
  
  function new();
    cg=new;
endfunction : new

function void funcov( reqcmd_a,reqcmd_b,reqcmd_c,reqcmd_d, 
     reqa_data, reqb_data, reqc_data, reqd_data);
    $display (" Coverage");
    this.reqcmd_a=reqcmd_a;
    this.reqcmd_b=reqcmd_b;
    this.reqcmd_c=reqcmd_c;
    this.reqcmd_d=reqcmd_d;
    this.reqa_data=reqa_data;
    this.reqb_data=reqb_data;
    this.reqc_data=reqc_data;
    this.reqd_data=reqd_data;
 
  cg.sample;
 endfunction : funcov
endclass : coverage
endpackage : A
