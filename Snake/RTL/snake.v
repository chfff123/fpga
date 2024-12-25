//蛇运动情况控制模块
module snake(
	input clk,		//25MHz
	input rst_n,	//系统复位
	input cube,
	 
	input wire sw2,	//游戏难度选择
	input wire sw1,
	input wire sw0,
	input key0_right,	//方向控制按钮，控制向左移动
	input key1_left,	//方向控制按钮，控制向右移动
	input key2_down,	//方向控制按钮，控制向上移动
	input key3_up,		//方向控制按钮，控制下左移动
	 
	input [9:0]pos_x,	//扫描像素点的x轴坐标， 范围0-640，所以二进制需10位
	input [9:0]pos_y,	//扫描像素点的y轴坐标， 范围0-480
	
	output [5:0]head_x,	//蛇的头部x轴坐标，范围0-40，所以二进制需6位
	output [5:0]head_y,	//蛇的头部y轴坐标，范围0-30
	
	input add_cube,		  //蛇体长增加标志
	input died,
	input [1:0]game_status,//四种游戏状态̬
	input snake_display,//蛇整体显示标志
	
	output reg hit_body,//撞到自身标志
	output reg hit_wall, //撞到墙标志
	output reg enb1,
	output reg hit_wall_died,
	
	output reg [1:0]snake_show//用于表示当前扫描扫描的部件 四种状态 00：无 01：头 10：身体 11：墙
);
	
	
	
	
	localparam UP = 2'b00;
	localparam DOWN = 2'b01;
	localparam LEFT = 2'b10;
	localparam RIGHT = 2'b11;
	
	localparam NONE = 2'b00;//无色块显示（显示黑色）
	localparam HEAD = 2'b01;//显示蛇的头
	localparam BODY = 2'b10;//显示蛇的身体
	localparam WALL = 2'b11;//显示墙壁
	
   localparam RESTART = 2'b00;
	localparam PLAY = 2'b10;
	localparam DIE = 2'b11;	//游戏结束
	
	reg [3:0]cube_num;//蛇的节数
	reg [5:0]cube_x[15:0];
	reg [5:0]cube_y[15:0];//体长坐标 单位："格子" 
	reg [15:0]is_exist;   //用于控制身子的亮灭，即控制身子长度
	
	reg addcube_state;
	reg died_state;
	
	
	reg[31:0]clk_cnt;//计数器
	reg[23:0] speed;     //蛇的速度，值越小速度越快
	
	reg[1:0]direct_r;		//寄存方向
	reg[1:0]direct_next;	//寄存下一个方向
	
	//wire[1:0]direct;
	//assign direct = direct_r;
	
	assign head_x = cube_x[0];
	assign head_y = cube_y[0]; 
	
	always @(posedge clk or negedge rst_n) begin		
		if(!rst_n) begin
		   if(sw0==0) begin
				 speed <= 24'd12500000;//0.5s移动一次
				 end
			else if(sw1==0) begin
				 speed <= 24'd6250000;//0.5s移动一次
				 end
			else if(sw2==0) begin
				 speed <= 24'd3125000;//0.5s移动一次
				 end
			else begin
				 speed <= 24'd12500000;//0.5s移动一次
				 end
			direct_r<=RIGHT;
		end
		else if(game_status==RESTART) begin
			if(sw0==0) begin
				 speed <= 24'd12500000;//0.5s移动一次
				 end
			else if(sw1==0) begin
				 speed <= 24'd6250000;//0.5s移动一次
				 end
			else if(sw2==0) begin
				 speed <= 24'd3125000;//0.5s移动一次
			end
			else begin
				speed <= 24'd12500000;//0.5s移动一次
			end
			direct_r<=RIGHT;
		end
		else begin
			direct_r <= direct_next;
			speed <= speed;//0.5s移动一次
		end		
	end
    
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			clk_cnt <= 0;
								
			cube_x[0] <= 10;	//初始化时蛇身只显示3个长度，这是蛇身第一节
			cube_y[0] <= 5;
					
			cube_x[1] <= 9;	//初始化时蛇身只显示3个长度，这是蛇身第二节
			cube_y[1] <= 5;
					
			cube_x[2] <= 8;	//初始化时蛇身只显示3个长度，这是蛇身第三节
			cube_y[2] <= 5;

			cube_x[3] <= 7;
			cube_y[3] <= 5;
					
			cube_x[4] <= 6;
			cube_y[4] <= 5;
					
			cube_x[5] <= 0;
			cube_y[5] <= 0;
					
			cube_x[6] <= 0;
			cube_y[6] <= 0;
					
			cube_x[7] <= 0;
			cube_y[7] <= 0;
					
			cube_x[8] <= 0;
			cube_y[8] <= 0;
					
			cube_x[9] <= 0;
			cube_y[9] <= 0;					
					
			cube_x[10] <= 0;
			cube_y[10] <= 0;
					
			cube_x[11] <= 0;
			cube_y[11] <= 0;
					
         cube_x[12] <= 0;
			cube_y[12] <= 0;
					
			cube_x[13] <= 0;
			cube_y[13] <= 0;
					
			cube_x[14] <= 0;
			cube_y[14] <= 0;
					
			cube_x[15] <= 0;
			cube_y[15] <= 0;//蛇身限制长度是16

			hit_wall <= 0;
			hit_body <= 0;
		end	
		else if(game_status==RESTART) begin
			clk_cnt <= 0;
                                                    
			cube_x[0] <= 10;	//初始化时蛇身只显示3个长度，这是蛇身第一节
			cube_y[0] <= 5;
					
			cube_x[1] <= 9;	//初始化时蛇身只显示3个长度，这是蛇身第二节
			cube_y[1] <= 5;
					
			cube_x[2] <= 8;	//初始化时蛇身只显示3个长度，这是蛇身第三节
			cube_y[2] <= 5;

			cube_x[3] <= 7;
			cube_y[3] <= 5;
					
			cube_x[4] <= 6;
			cube_y[4] <= 5;
					
			cube_x[5] <= 0;
			cube_y[5] <= 0;
					
			cube_x[6] <= 0;
			cube_y[6] <= 0;
					
			cube_x[7] <= 0;
			cube_y[7] <= 0;
					
			cube_x[8] <= 0;
			cube_y[8] <= 0;
					
			cube_x[9] <= 0;
			cube_y[9] <= 0;					
					
			cube_x[10] <= 0;
			cube_y[10] <= 0;
					
			cube_x[11] <= 0;
			cube_y[11] <= 0;
					
         cube_x[12] <= 0;
			cube_y[12] <= 0;
					
			cube_x[13] <= 0;
			cube_y[13] <= 0;
					
			cube_x[14] <= 0;
			cube_y[14] <= 0;
					
			cube_x[15] <= 0;
			cube_y[15] <= 0;//蛇身限制长度是16
                    
			hit_wall <= 0;
			hit_body <= 0; 
		end
		else begin
			clk_cnt <= clk_cnt + 1;
				if(clk_cnt == speed) begin
					clk_cnt <= 0;
					if(game_status==PLAY) begin
						if((direct_r==UP && cube_y[0] == 1)||(direct_r==DOWN && cube_y[0] == 28)||(direct_r==LEFT && cube_x[0] == 1)||(direct_r==RIGHT && cube_x[0] == 38))begin
							hit_wall <= 1; end//撞到墙壁				
							//如果蛇是向上运动，且蛇头的y坐标跟上面墙的y坐标（cube_y[0] == 1）重合
							//如果蛇是向下运动，且蛇头的y坐标跟下面墙的y坐标（cube_y[0] == 28）重合
							//如果蛇是向左运动，且蛇头的x坐标跟左面墙的x坐标（cube_x[0] == 1）重合
							//如果蛇是向右运动，且蛇头的x坐标跟上面墙的x坐标（cube_x[0] == 38）重合
											
						else if((cube_y[0] == cube_y[1] && cube_x[0] == cube_x[1] && is_exist[1] == 1)||
								(cube_y[0] == cube_y[2] && cube_x[0] == cube_x[2] && is_exist[2] == 1)||
								(cube_y[0] == cube_y[3] && cube_x[0] == cube_x[3] && is_exist[3] == 1)||
								(cube_y[0] == cube_y[4] && cube_x[0] == cube_x[4] && is_exist[4] == 1)||
								(cube_y[0] == cube_y[5] && cube_x[0] == cube_x[5] && is_exist[5] == 1)||
								(cube_y[0] == cube_y[6] && cube_x[0] == cube_x[6] && is_exist[6] == 1)||
								(cube_y[0] == cube_y[7] && cube_x[0] == cube_x[7] && is_exist[7] == 1)||
								(cube_y[0] == cube_y[8] && cube_x[0] == cube_x[8] && is_exist[8] == 1)||
								(cube_y[0] == cube_y[9] && cube_x[0] == cube_x[9] && is_exist[9] == 1)||
								(cube_y[0] == cube_y[10] && cube_x[0] == cube_x[10] && is_exist[10] == 1)||
								(cube_y[0] == cube_y[11] && cube_x[0] == cube_x[11] && is_exist[11] == 1)||
								(cube_y[0] == cube_y[12] && cube_x[0] == cube_x[12] && is_exist[12] == 1)||
								(cube_y[0] == cube_y[13] && cube_x[0] == cube_x[13] && is_exist[13] == 1)||
								(cube_y[0] == cube_y[14] && cube_x[0] == cube_x[14] && is_exist[14] == 1)||
								(cube_y[0] == cube_y[15] && cube_x[0] == cube_x[15] && is_exist[15] == 1)) begin
								hit_body <= 1; end//头的Y坐标=任一位身体的Y坐标 且 头的X坐标=任一位身体的X坐标 且 身体的该长度位存在，说明碰到身体
							else begin
								cube_x[1] <= cube_x[0];
								cube_y[1] <= cube_y[0];
															
								cube_x[2] <= cube_x[1];
								cube_y[2] <= cube_y[1];
															
								cube_x[3] <= cube_x[2];
								cube_y[3] <= cube_y[2];
															
								cube_x[4] <= cube_x[3];
								cube_y[4] <= cube_y[3];
															
								cube_x[5] <= cube_x[4];
								cube_y[5] <= cube_y[4];
															
								cube_x[6] <= cube_x[5];
								cube_y[6] <= cube_y[5];
															
								cube_x[7] <= cube_x[6];
								cube_y[7] <= cube_y[6];
															
								cube_x[8] <= cube_x[7];
								cube_y[8] <= cube_y[7];
															
								cube_x[9] <= cube_x[8];
								cube_y[9] <= cube_y[8];
															
								cube_x[10] <= cube_x[9];
								cube_y[10] <= cube_y[9];
															
								cube_x[11] <= cube_x[10];
								cube_y[11] <= cube_y[10];
															
								cube_x[12] <= cube_x[11];
								cube_y[12] <= cube_y[11];
															 
								cube_x[13] <= cube_x[12];
								cube_y[13] <= cube_y[12];
															
								cube_x[14] <= cube_x[13];
								cube_y[14] <= cube_y[13];
															
								cube_x[15] <= cube_x[14];
								cube_y[15] <= cube_y[14];
									//身体运动算法 本长度位移动的下个坐标为下一个长度位当前坐标 运动节拍按分频后的节奏
									//蛇身体运动，蛇块的前一块坐标赋给后一块，比如 第0个块的坐标赋给第1块，第1块的坐标赋给第2块。。。
								if(direct_r==UP)begin
										if(cube_y[0] == 1)begin
										hit_wall <= 1;//撞上墙
										enb1 <= 1'b1;
										end
										else begin
											cube_y[0] <= cube_y[0]-1;
											enb1 <= 1'b0;
										end
										end
																
								else if(direct_r==DOWN)begin
										if(cube_y[0] == 28)begin
											hit_wall <= 1;//撞下墙
											enb1 <= 1'b1;
											end
										else begin
											cube_y[0] <= cube_y[0] + 1;
											enb1 <= 0;
										end
										end
																	
								else if(direct_r==LEFT)begin
										if(cube_x[0] == 1)begin
											hit_wall <= 1;//撞左墙
											enb1 <= 1'b1;
											end
										else begin
											cube_x[0] <= cube_x[0] - 1;
											enb1 <= 1'b0;
										end
										end
										
								else if(hit_wall_died == 1 )begin
										hit_wall <= 1;
										end

								else if(direct_r==RIGHT)begin
										if(cube_x[0] == 38)begin
											hit_wall <= 1;//撞右墙
											enb1 <= 1'b1;
											end
										else begin
											cube_x[0] <= cube_x[0] + 1;
											enb1 <= 1'b0;
										end
										end
								//根据按下按键判断是否撞墙 否则按规律改变头部坐标
							end
						end
						end
					end
				end
				
		always @(posedge clk or negedge rst_n) begin
//吃下苹果没？，吃下则add_cube==1，显示体长增加一位，"is_exixt[cube_num]<=1",让第cube_num位"出现"	
		if(!rst_n) begin
			died_state <= 0;
		end  
		else if (game_status == RESTART) begin
              died_state <= 0;
         end
		else begin			
			case(died_state) //判断蛇头与苹果坐标是否重合
				0:begin
					if(!died) begin
						hit_wall_died <= 0;
					end						
				end
				1:begin
					if(died)
						hit_wall_died <= 1;
					end
			endcase
		end
	end


	
	always @(*) begin   //根据当前运动状态即按下键位判断下一步运动情况	
		case(direct_r)	
			UP: begin   //向上运动时，  方向可以左右变
				if(~key1_left)
					direct_next = LEFT;
				else if(~key0_right)
					direct_next = RIGHT;
				else
					direct_next = UP;			
				end		
			DOWN: begin //向下运动时，  方向可以左右变
				if(~key1_left)
					direct_next = LEFT;
				else if(~key0_right)
					direct_next = RIGHT;
				else
					direct_next = DOWN;			
				end		
				LEFT: begin //向左运动时，  方向可以上下变
				if(~key3_up)
					direct_next = UP;
				else if(~key2_down)
					direct_next = DOWN;
				else
					direct_next = LEFT;			
				end
				RIGHT: begin //向右运动时，  方向可以上下变
				if(~key3_up)
					direct_next = UP;
				else if(~key2_down)
					direct_next = DOWN;
				else
					direct_next = RIGHT;
				end	
		endcase
	end
	
	always @(posedge clk or negedge rst_n) begin
//吃下苹果没？，吃下则add_cube==1，显示体长增加一位，"is_exixt[cube_num]<=1",让第cube_num位"出现"	
		if(!rst_n) begin
			is_exist <= 16'd31;
			cube_num <= 5;  //蛇初始显示长度为3，is_exist=0000_0000_0111,表示前三位出现
			addcube_state <= 0;
		end  
		else if (game_status == RESTART) begin
		      is_exist <= 16'd31;
              cube_num <= 5;
              addcube_state <= 0;
         end
		else begin			
			case(addcube_state) //判断蛇头与苹果坐标是否重合
				0:begin
					if(add_cube) begin
						cube_num <= cube_num + 1;
						is_exist[cube_num] <= 1;
						addcube_state <= 1;//"吃下"信号
					end						
				end
				1:begin
					if(!add_cube)
						addcube_state <= 0;
				end
			endcase
		end
	end

	always @(pos_x or pos_y ) begin				
		if(pos_x >= 0 && pos_x < 640 && pos_y >= 0 && pos_y < 480) begin
			if(pos_x[9:4] == 0 || pos_y[9:4] == 0 || pos_x[9:4] == 39 || pos_y[9:4] == 29)//在VGA可显示的坐标范围内标记出墙的坐标
				snake_show = WALL;//扫描墙
				
			else if(pos_x[9:4] == cube_x[0] && pos_y[9:4] == cube_y[0] && is_exist[0] == 1) 
				snake_show = (snake_display == 1) ? HEAD : NONE;//扫描头
			else if
				((pos_x[9:4] == cube_x[1] && pos_y[9:4] == cube_y[1] && is_exist[1] == 1)|
				 (pos_x[9:4] == cube_x[2] && pos_y[9:4] == cube_y[2] && is_exist[2] == 1)|
				 (pos_x[9:4] == cube_x[3] && pos_y[9:4] == cube_y[3] && is_exist[3] == 1)|
				 (pos_x[9:4] == cube_x[4] && pos_y[9:4] == cube_y[4] && is_exist[4] == 1)|
				 (pos_x[9:4] == cube_x[5] && pos_y[9:4] == cube_y[5] && is_exist[5] == 1)|
				 (pos_x[9:4] == cube_x[6] && pos_y[9:4] == cube_y[6] && is_exist[6] == 1)|
				 (pos_x[9:4] == cube_x[7] && pos_y[9:4] == cube_y[7] && is_exist[7] == 1)|
				 (pos_x[9:4] == cube_x[8] && pos_y[9:4] == cube_y[8] && is_exist[8] == 1)|
				 (pos_x[9:4] == cube_x[9] && pos_y[9:4] == cube_y[9] && is_exist[9] == 1)|
				 (pos_x[9:4] == cube_x[10] && pos_y[9:4] == cube_y[10] && is_exist[10] == 1)|
				 (pos_x[9:4] == cube_x[11] && pos_y[9:4] == cube_y[11] && is_exist[11] == 1)|
				 (pos_x[9:4] == cube_x[12] && pos_y[9:4] == cube_y[12] && is_exist[12] == 1)|
				 (pos_x[9:4] == cube_x[13] && pos_y[9:4] == cube_y[13] && is_exist[13] == 1)|
				 (pos_x[9:4] == cube_x[14] && pos_y[9:4] == cube_y[14] && is_exist[14] == 1)|
				 (pos_x[9:4] == cube_x[15] && pos_y[9:4] == cube_y[15] && is_exist[15] == 1))
				 snake_show = (snake_display == 1) ? BODY : NONE;//扫描身体
			else snake_show = NONE;
		end
	end
endmodule