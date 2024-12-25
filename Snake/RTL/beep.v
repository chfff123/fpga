module beep
#(
    parameter TIME_500MS = 25'd24999999, // 0.5s 计数值
    parameter DO = 18'd190839, // "哆"音调分频计数值（频率262）
    parameter SO = 18'd127550  // "梭"音调分频计数值（频率392）
)
(
    input wire enb1,
    input wire enb2,
	 input [17:0] freq_datas,
	 input output_beep,
    input wire sys_clk, // 系统时钟, 频率50MHz
    input wire sys_rst_n, // 系统复位，低有效
    output reg beep // 输出蜂鸣器控制信号
);


    // Parameter and Internal Signal
    reg [24:0] cnt; // 0.5s计数器
    reg [17:0] freq_cnt; // 音调计数器
    reg [17:0] freq_data; // 音调分频计数值

    wire [16:0] duty_data; // 占空比计数值

    // 设置50％占空比
    assign duty_data = freq_data >> 1'b1;
	 
    // 频率选择逻辑
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            freq_data <= 0; // 默认无声
        end 
        else if (enb1==1) begin
                freq_data <= DO; // 选择"哆"
					 end
        else if (enb2==1) begin
                freq_data <= SO; // 选择"梭"
            end 
			else begin
                freq_data <= 0; // 其他情况不发声
            end
    end

    // 计数器逻辑和蜂鸣器输出
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            cnt <= 0;
            freq_cnt <= 0;
            beep <= 0;
        end 
        else if (freq_data > 0) begin
                if (cnt < TIME_500MS) begin
                    cnt <= cnt + 1;
                end 
					 else begin
                    cnt <= 0;
                    freq_cnt <= (freq_cnt >= freq_data) ? 0 : freq_cnt + 1; // 计数器
                    beep <= (freq_cnt < duty_data) ? 1'b1 : 1'b0; // 输出蜂鸣器波形
                end
            end 
		 else begin
                // 如果没有频率数据，保持蜂鸣器静音
                beep <= 0;
                cnt <= 0; // 重置计数器
                freq_cnt <= 0; // 重置频率计数器
            end
        end
		  
endmodule