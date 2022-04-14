//握手机制
module cdc_fast2slow_s_1bit (
    input wire clk_fast,
    input wire rstn,
    input wire fast_d,
    input wire clk_slow,

    output wire slow_q
);

localparam IDLE = 1'b0;
localparam HOLD = 1'b1;

reg gt_ctrl;
reg state, next_stat;

wire clk_fast_gt, d_en;
wire d_en1;
wire hand_sig1, hand_sig2; //反馈信号

assign clk_fast_gt = clk_fast & gt_ctrl; //门控时钟

dff #(1) dff_gt (clk_fast_gt, fast_d, d_en);
dff #(1) dff_slow1 (clk_slow, d_en, d_en1);
dff #(1) dff_slow2 (clk_slow, d_en1, slow_q);
dff #(1) dff_fb1 (clk_slow, slow_q, hand_sig1);
dff #(1) dff_fb2 (clk_slow, hand_sig1, hand_sig2);

// 状态机
always @(posedge clk_fast or negedge rstn) begin
    if (rstn == 1'b0)   state <= IDLE;
    else state <= next_stat;
end

always @(negedge clk_fast ) begin
    case (state)
        IDLE: begin
            if (fast_d == 1'b1) begin
                gt_ctrl <= 1'b0;
                next_stat <= HOLD;
            end
            else
                gt_ctrl <= 1'b1;
        end
        HOLD: begin
            if (hand_sig2 == 1'b1) begin
                gt_ctrl <= 1'b1;
                next_stat <= IDLE;
            end
            else
                gt_ctrl <= 1'b0;
        end
    endcase
end

endmodule //cdc_fast2slow_s_1bit