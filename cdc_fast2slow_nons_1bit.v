// 脉冲展宽，无握手机制
module cdc_fast2slow_nons_1bit #(
    // 需要将脉冲展宽为(delay+1)个快时钟周期
    // 脉冲长度至少为慢时钟周期的1.5倍
    parameter delay = 2 
)(
    input wire clk_fast,
    input wire fast_d,
    input wire clk_slow,
    
    output wire slow_q
);

wire [delay : 0] fast_d_shift, fast_d_shift_r;
wire afterp_pluse; //展宽后的脉冲
wire pluse_delay;

assign fast_d_shift = {fast_d, fast_d_shift_r[delay : 1]};
assign afterp_pluse =| fast_d_shift; 

dff #(delay+1) dff_shift (clk_fast, fast_d_shift, fast_d_shift_r); //脉冲展宽
dff #(1) dff_slow1 (clk_slow, afterp_pluse, pluse_delay);
dff #(1) dff_slow2 (clk_slow, pluse_delay, slow_q);

endmodule //cdc_fast2slow_nons_1bit