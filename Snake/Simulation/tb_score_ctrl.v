`timescale 1ns/ 1ns
module tb_score_ctrl();

//// Internal Signal \//
////
//wfine
   reg clk;//25MHz
	reg rst_n;//系统复位
	
	reg add_cube;//蛇吃掉一个苹果，该信号为高
	reg [1:0]game_status;//游戏状态

	wire [11:0]bcd_data;//计分
 ////

 //Init sys_clk,sys_rst_n
 initial
 begin
	 clk = 1'b1;
	 rst_n <= 1'b0;
	 add_cube <= 1'b0;
	 game_status <= 2'b1;
	 #200
	 rst_n <= 1'b1;
	 #440
	 add_cube <= 1'b1;
 end

 //Generate system clock 50MHz
 always #10 clk = ~clk ;
 
 //------------------------------------------------------------
 //Get the internal variables

 //------------------------------------------------------------

 ////
 //\* Instantiation \//
 ////

 //------------- vga_rom_pic_inst -------------
score_ctrl score_ctrl_inst(
	.clk(clk),
	.rst_n(rst_n),
	.add_cube(add_cube),
	.game_status(game_status),
	
	.bcd_data(bcd_data)
);

endmodule