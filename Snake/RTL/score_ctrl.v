//数码管计分模块
module score_ctrl
(
	input clk,//25MHz
	input rst_n,//系统复位
	
	input add_cube,//蛇吃掉一个苹果，该信号为高
	input [1:0]game_status,//游戏状态

	output [11:0]bcd_data//计分
);
	reg [7:0]bin_data;//二进制计分寄存器，最小值0000 0000 ，最大值0110 0100（也就是十进制100）

   localparam RESTART = 2'b00;//游戏的第1个状态是重启
    
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) 										 //复位时分数归零
			bin_data <= 0;
		else if(game_status==RESTART)					//重启状态下分数归零
			bin_data <= 0;	
		else if(add_cube==1 && bin_data < 8'd100)			//当分数不超过100的时候，蛇每吃掉一个苹果计数器就+1 
			bin_data <= bin_data + 1;
		else 
			bin_data <= bin_data;
		end
	
	assign bcd_data[3:0]  = bin_data%10;				//算出十进制数的个位
	assign bcd_data[7:4]  = (bin_data/10)%10;			//算出十进制数的十位
	assign bcd_data[11:8] = (bin_data/100)%10;		//算出十进制数的百位

endmodule