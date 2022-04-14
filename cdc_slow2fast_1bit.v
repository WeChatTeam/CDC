// 打两拍
module cdc_slow2fast_1bit (
    input wire slow_d,
    input wire clk_fast,

    output wire fast_q
);

wire slow_q1;

dff #(1) dff_fast1 (clk_fast, slow_d, slow_q1);
dff #(1) dff_fast2 (clk_fast, slow_q1, fast_q);

endmodule //cdc_slow2fast_1bit