library verilog;
use verilog.vl_types.all;
entity calc_if is
    port(
        c_clk           : in     vl_logic;
        a_clk           : in     vl_logic;
        b_clk           : in     vl_logic
    );
end calc_if;
