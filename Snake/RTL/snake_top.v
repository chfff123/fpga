//游戏最顶层模块
module snake_top
(
   input clk,				//系统时钟50M
	input rst_n,			//系统复位，引脚绑定到SW[3]，因为SW[2:0]已经作为游戏难度选择开关了
	
	input key0_right,  			//方向控制按钮，控制向左移动
	input key1_left, 			//方向控制按钮，控制向右移动
	input key2_down,    			//方向控制按钮，控制向上移动
	input key3_up, 		 		//方向控制按钮，控制向下移动

	output vga_hsync,		//VGA 行行步信号
	output vga_vsync,		//VGA 场同步信号
	output [15:0]vga_rgb,	//RGB三分量，每个分量位8bit	
	output [6:0]hex0,	//七段数码管输出
	output [6:0]hex1,	//七段数码管输出
	output [6:0]hex2,	//七段数码管输出
	output beep
);


	wire clk_25m;
	wire pll_locked;
	wire [1:0]snake_show;//变量，用于表示当前扫描的部件（是蛇头还是蛇身还是其他）
	
	wire [9:0]pos_x;//VGA像素x轴坐标
	wire [9:0]pos_y;//VGA像素y轴坐标
	
	wire [5:0]apple_x;//食物的x轴坐标
	wire [4:0]apple_y;//食物的y轴坐标
	
	wire [5:0]posion_x;//食物的x轴坐标
	wire [4:0]posion_y;//食物的y轴坐标
	
	wire [5:0]head_x;//蛇头的x轴坐标
	wire [5:0]head_y;//蛇头的y轴坐标
	
	wire add_cube;//为1代表蛇吃掉一个苹果，蛇身增长1，直到增长到16个 就不再增长
	wire died;
	
	wire[1:0]game_status;//代表游戏状态
	
	wire hit_wall;//撞墙标志
	wire hit_body;//撞自己身体标志
	wire snake_display;//蛇整体能显示的标志	
	
	wire [11:0]bcd_data;//在数码管上显示的10进制数
	
	wire  beep_clk;
	
	
//实例化PLL
    pll pll_inst (
    
			.areset(~rst_n),//因为在PLL IP里面复位是高电平有效
			.inclk0(clk),
			.c0(clk_25m),
			.locked(pll_locked)
    );
	 
assign vga_clk = clk_25m;
assign vga_sync_n=1'b0;   //If not IOG, Sync input should be tied to 0; 
	
    game_ctrl_unit U0 (//控制游戏的几个状态
       .clk(clk_25m),
	    .rst_n(rst_n),
	    .key0_right(key0_right),
	    .key1_left(key1_left),
	    .key2_down(key2_down),
	    .key3_up(key3_up),
       .game_status(game_status),
		 .snake_display(snake_display),
		 .hit_wall(hit_wall),
		 .hit_body(hit_body),
		 .bcd_data(bcd_data),
		 .sw0(key1_left),
		 .sw1(key3_up),
		 .sw2(key2_down)
	);
	
	apple_generate U1 (//初始化给定一个食物坐标，用蛇头坐标跟食物坐标对比来判断是否吃掉食物，如果被吃掉，就产生新的苹果坐标
		.clk(clk_25m),
		.rst_n(rst_n),
		.apple_x(apple_x),
		.apple_y(apple_y),
		.head_x(head_x),
		.head_y(head_y),
		.posion_x(posion_x),
		.posion_y(posion_y),
		.add_cube(add_cube),
		.enb2(enb2)
	);
	
	snake U2 (
	   .clk(clk_25m),
		.rst_n(rst_n),
		.sw0(key1_left),
		.sw1(key3_up),
		.sw2(key2_down),
		.key0_right(key0_right),
		.key1_left(key1_left),
		.key2_down(key2_down),
		.key3_up(key3_up),
		.snake_show(snake_show),
		.pos_x(pos_x),
		.pos_y(pos_y),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube),
		.died(died),
		.game_status(game_status),
		.hit_body(hit_body),
		.snake_display(snake_display),
		.hit_wall(hit_wall),
		.enb1(enb1)
	);

	VGA_control U3 (
		.clk(clk_25m),
		.rst_n(rst_n),
		.game_status(game_status),
		.snake_show(snake_show),
		.bcd_data(bcd_data),
		.pos_x(pos_x),
		.pos_y(pos_y),
		.apple_x(apple_x),
		.apple_y(apple_y),
		.vga_rgb(vga_rgb),
      .vga_hs(vga_hsync),
      .vga_blank_n(vga_blank_n),
      .vga_vs(vga_vsync),
		.posion_x(posion_x),
		.posion_y(posion_y)
	);

score_ctrl u4(
		.clk(clk_25m),
		.rst_n(rst_n),
		.add_cube(add_cube),
		.game_status(game_status),
		.bcd_data(bcd_data) //输出分数
);
	
seg_display	u5	(
		.clk(clk_25m),
		.rst_n(rst_n),
		.seg_data(bcd_data[3:0]), //显示分数的个位
		.seg_out(hex0)
		);
		
seg_display	u6	(
		.clk(clk_25m),
		.rst_n(rst_n),
		.seg_data(bcd_data[7:4]), //显示分数的十位
		.seg_out(hex1)
		);
		
seg_display	u7	(
		.clk(clk_25m),
		.rst_n(rst_n),
		.seg_data(bcd_data[11:8]), //显示分数的百位
		.seg_out(hex2)
		);
		
beep  beep_inst
 (
 .sys_clk (clk ), //系统时钟,频率50MHz
 .sys_rst_n (rst_n ), //系统复位，低有效
 .enb1(enb1),
 .enb2(enb2),

 .beep (beep ) //输出蜂鸣器控制信号
 );
		
endmodule
