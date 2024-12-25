`timescale 1ns/ 1ns
module tb_apple_generate();

//// Internal Signal \//
////
//wfine
	reg clk; //时钟25MHz
	reg rst_n;//系统复位
	reg [5:0]head_x;//蛇的头部x轴坐标
	reg [5:0]head_y;//蛇的头部y轴坐标
	
	 wire [5:0]apple_x;//苹果的x轴坐标
	 wire [4:0]apple_y;//苹果的y轴坐标

	 wire [5:0]posion_x;//苹果的x轴坐标
	 wire [4:0]posion_y;//苹果的y轴坐标

	 wire add_cube;//蛇吃掉一个苹果标志
	 wire died;
	 wire enb2;
 //\* Clk And Rst \//
 ////

 //Init sys_clk,sys_rst_n
 initial
 begin
	 clk = 1'b1;
	 rst_n <= 1'b0;
	 #200
	 rst_n <= 1'b1;

 end

 //Generate system clock 50MHz
 always #10 clk = ~clk ;
 
always@(posedge clk or negedge rst_n) begin
	if(head_x == apple_x && head_y == apple_y)begin
			head_x <= 6'h24;
			head_y <= 6'h10;
			end
	else begin
			head_x <= apple_x;
			head_y <= apple_y;
			end
	end
	
 
 //------------------------------------------------------------
 //Get the internal variables

 //------------------------------------------------------------

 ////
 //\* Instantiation \//
 ////

 //------------- vga_rom_pic_inst -------------
apple_generate apple_generate_inst(
.clk(clk),
.rst_n(rst_n),
.head_x(head_x),
.head_y(head_y),
.apple_x(apple_x),
.apple_y(apple_y),

.add_cube(add_cube),
.enb2(enb2),
.posion_x(posion_x),
.posion_y(posion_y)
);

 endmodule