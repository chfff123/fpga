`timescale 1ns/1ns
module tb_counter();

//reg define
reg sys_clk;
reg sys_rst_n;

//wire define
wire led_out;
wire [24:0] cnt; // 添加观察 cnt 的 wire

// 初始化输入信号
initial begin
    sys_clk = 1'b1;
    sys_rst_n = 1'b0;
    #20
    sys_rst_n = 1'b1;
end

// sys_clk: 每10ns电平翻转一次，产生一个50MHz的时钟信号
always #10 sys_clk = ~sys_clk;

// 实例化带参数的 counter 模块
led_counter
counter_inst (
    .sys_clk (sys_clk),       // input sys_clk
    .sys_rst_n (sys_rst_n),   // input sys_rst_n
    .led_out (led_out),       // output led_out
    .cnt (cnt)                // output cnt
);

// 显示 cnt 和 led_out 的值
always @(posedge sys_clk) begin
    $display("Time = %0t, cnt = %d, led_out = %b", $time, cnt, led_out);
end

endmodule