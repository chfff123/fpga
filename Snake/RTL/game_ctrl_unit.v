//游戏控制模块 根据游戏状态产生相应控制信号

module game_ctrl_unit
(
	input clk,//25MHz
	input rst_n,//系统复位
	
	input key0_right,//方向控制按钮，控制向左移动
	input key1_left,//方向控制按钮，控制向右移动
	input key2_down,//方向控制按钮，控制向上移动
	input key3_up,//方向控制按钮，控制向下移动
	input sw2,//完成难度选择的操作
	input sw1,
	input sw0,
	input wire [1:0] game_statues,
	
	input hit_wall,//撞墙标志
	input hit_body,//撞自身标志
	input [11:0]bcd_data,//分数累计到100则游戏成功
	
	output reg snake_display,//蛇整体显示标志
	output reg [1:0]game_status//当前游戏状态
);
	
	//游戏分四个状态
	parameter RESTART = 2'b01;		//游戏重启
	parameter START = 2'b00;			//游戏开始
	parameter PLAY = 2'b10;			//游戏进行
	parameter DIE = 2'b11;				//游戏结束
	
	reg [32:0]cnt_clk;
	reg[31:0]flash_cnt;//蛇闪烁时间计数器

	//状态机定义初始状态，并描述状态转移与输出
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt_clk<=0;
			flash_cnt<=0;
			snake_display<=1;
			game_status <= RESTART;		//复位后游戏状态进入重启状态
		end
		
		else begin
			case(game_status)	
				RESTART:begin           //游戏重启状态
					cnt_clk<=cnt_clk+1;
					if(cnt_clk>10)begin// "欢迎来到贪吃蛇游戏“ 界面显示需要6s时间
						if((~sw0)||(~sw1)||(~sw2)) begin
							game_status <= START;//选择游戏难度后进入START状态
						end
						else begin
							game_status <= RESTART;
						end
					end
					else begin
						game_status <= RESTART;
					end
				end
				
				START:begin
					if ((~key0_right) ||( ~key1_left) || (~key2_down) ||( ~key3_up))//四个按键有任意一个按键被按下即可开始游戏
						game_status <= PLAY;
					else 
					    game_status <= START;
				end
				
				PLAY:begin
					if(hit_wall || hit_body||bcd_data[11:8]>=1'd1)//如果撞墙或者撞自身则	游戏结束
					   game_status <= DIE;
					else
					   game_status <= PLAY;
				end
				
				//下面代码是在制造闪烁效果
				//snake_display信号初始化的时候为高
				//snake_display信号在0-0.5秒为高，在 0.5-1秒为低，在 1-1.5秒高 在1.5-2低 2-2.5秒高 在2.5-3秒低 
				DIE:begin
					if(flash_cnt <= 100_000_000) begin//flash_cnt计时4秒
						flash_cnt <= flash_cnt + 1'b1;	
						if(flash_cnt == 12_500_000)begin//0-0.5秒 高
							snake_display <= 1'b0;end
						else if(flash_cnt == 25_000_000)begin//0.5-1秒低
							snake_display <= 1'b1;end
						else if(flash_cnt == 37_500_000)begin//1-1.5秒高
							snake_display <= 1'b0;end
						else if(flash_cnt == 50_000_000)begin//1.5-2秒低
							snake_display <= 1'b1;end
						else if(flash_cnt == 62_500_000)begin//2-2.5秒高
							snake_display <= 1'b0;end
						else if(flash_cnt == 75_000_000)begin//2.5-3秒低
							snake_display <= 1'b1;
						end
					end
					//游戏结束后按任意按键重新开始
					else if((~key0_right) ||( ~key1_left) || (~key2_down) ||( ~key3_up) ) begin
						cnt_clk<=0;
						flash_cnt<=0;
						game_status <= RESTART;

					end			
					else begin
						game_status <= DIE;
					end
				end 
				
				default:begin                
							game_status <= RESTART; //游状态 从游戏结束 到游戏重启
					end
			endcase	
		end
	end
endmodule

