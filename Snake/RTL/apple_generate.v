//食物（苹果）产生控制模块
//初始化给定一个食物坐标，输入蛇头坐标跟食物坐标对比来判断是否吃掉食物，如果被吃掉，就产生新的苹果坐标
module apple_generate(
	input clk,  //时钟25MHz
	input rst_n,//系统复位
	
	input [5:0]head_x,//蛇的头部x轴坐标
	input [5:0]head_y,//蛇的头部y轴坐标
	
	output reg [5:0]apple_x,//苹果的x轴坐标
	output reg [4:0]apple_y,//苹果的y轴坐标
	
	output reg [5:0]posion_x,//苹果的x轴坐标
	output reg [4:0]posion_y,//苹果的y轴坐标

	output reg add_cube,//蛇吃掉一个苹果标志
	output reg died,
	output reg enb2
);

	reg [31:0]clk_cnt;
	reg [10:0]random_num;//寄存器没有初始化
	reg [10:0]random_num2;
	
	always@(posedge clk)
		random_num <= random_num + 999;  //用加法产生随机数  
		//随机数高六位为食物x的坐标，低五位为苹果Y坐标
		
	always@(posedge clk)
		random_num2 <= random_num + 99;  //用加法产生随机数  

	
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			clk_cnt <= 0;
			apple_x <= 24;
			apple_y <= 10;
			add_cube <= 0;
			enb2 <= 0;
		end
		else begin
			if(apple_x == head_x && apple_y == head_y) begin//当蛇头坐标和苹果坐标一样时，表示蛇吃掉一个苹果
				add_cube <= 1;
				enb2 <= 1;
				apple_x <= (random_num[10:5] > 38) ? (random_num[10:5] - 25) : (random_num[10:5] == 0) ? 1 : random_num[10:5];
				apple_y <= (random_num[4:0] > 28) ? (random_num[4:0] - 3) : (random_num[4:0] == 0) ? 1:random_num[4:0];
			end    //判断随机数是否超出频幕坐标范围 将随机数转换为下个苹果的X Y坐标
				
				//如果 apple_x满足条件 random num[10:5] > 38，那apple_x值就取 random num[10:5] - 25
				//如果apple_x不满足条件random num[10:5] > 38，就看apple_x满不满足 random_num[10:5] == 0，
				//如果apple_x满足random_num[10:5] == 0，apple_x就取1， 否则apple_x就取random_num[10:5]
				//random num[10:5] > 38是苹果x坐标到显示器最右边（边框）
				//random_num[10:5] == 0是苹果x坐标到显示器最左边（边框）
				//apple_y 同理
			else begin
				add_cube <= 0;
				enb2 <= 0;
			end
		end
	end
		
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			posion_x <= 14;
			posion_y <= 18;
			died <= 0;
		end
		else begin
			if(posion_x == head_x && posion_y == head_y) begin//当蛇头坐标和苹果坐标一样时，表示蛇吃掉一个苹果
				died <= 1;
				posion_x <= (random_num2[10:5] > 38) ? (random_num2[10:5] - 25) : (random_num2[10:5] == 0) ? 1 : random_num2[10:5];
				posion_y <= (random_num2[4:0] > 28) ? (random_num2[4:0] - 3) : (random_num2[4:0] == 0) ? 1:random_num2[4:0];
			end    //判断随机数是否超出频幕坐标范围 将随机数转换为下个苹果的X Y坐标
				
				//如果 apple_x满足条件 random num[10:5] > 38，那apple_x值就取 random num[10:5] - 25
				//如果apple_x不满足条件random num[10:5] > 38，就看apple_x满不满足 random_num[10:5] == 0，
				//如果apple_x满足random_num[10:5] == 0，apple_x就取1， 否则apple_x就取random_num[10:5]
				//random num[10:5] > 38是苹果x坐标到显示器最右边（边框）
				//random_num[10:5] == 0是苹果x坐标到显示器最左边（边框）
				//apple_y 同理
			else
				died <= 0;
			end
		end
		
		
		
		
endmodule