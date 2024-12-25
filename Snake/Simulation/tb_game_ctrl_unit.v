`timescale 1ns/ 1ns
module tb_game_ctrl_unit();

//// Internal Signal \//
////
//wfine
   reg clk;//25MHz
	reg rst_n;//系统复位
	
	reg key0_right;//方向控制按钮，控制向左移动
	reg key1_left;//方向控制按钮，控制向右移动
	reg key2_down;//方向控制按钮，控制向上移动
	reg key3_up;//方向控制按钮，控制向下移动
	reg sw2;//完成难度选择的操作
	reg sw1;
	reg sw0;
	reg [1:0] game_statues;
	
	reg hit_wall;//撞墙标志
	reg hit_body;//撞自身标志
	reg [11:0]bcd_data;//分数累计到100则游戏成功
	
	wire snake_display;//蛇整体显示标志
	wire [1:0] game_status;//当前游戏状态
 ////

 //Init sys_clk,sys_rst_n
 //Init sys_clk,sys_rst_n
 initial
 begin
	 clk = 1'b1;
	 rst_n <= 1'b0;
	 hit_wall <= 1'b0;
	 hit_body <= 1'b0;
	 sw2 <= 1'b1;
	 sw1 <= 1'b1;
	 sw0 <= 1'b1;
	 game_statues <= 2'b0;
	 #200
	 rst_n <= 1'b1;
	 key0_right <= 1'b0;
	 key1_left <= 1'b0;
	 key2_down <= 1'b0;
	 key3_up <= 1'b0;
	 #400
	 sw1 <= 0;
	 #20
	 game_statues<=2'b01;
	 #20
	 game_statues<=2'b10;
	 #20000
	 hit_body <= 1'b1;
	 #20
	 game_statues <= 2'b11;
	 #20
	 game_statues <= 2'b0;
 end
 
 

 //Generate system clock 50MHz
always #10 clk = ~clk ;

wire [32:0] cnt_clk = game_ctrl_unit_inst.cnt_clk;

 
 
always #20 begin
    // 生成一个随机数，范围是0-3，对应四个按键
    case ({$random} % 4)
        0: begin
            key0_right <= 1'b1;
            key1_left  <= 1'b0;
            key2_down  <= 1'b0;
            key3_up    <= 1'b0;
        end
        1: begin
            key0_right <= 1'b0;
            key1_left  <= 1'b1;
            key2_down  <= 1'b0;
            key3_up    <= 1'b0;
        end
        2: begin
            key0_right <= 1'b0;
            key1_left  <= 1'b0;
            key2_down  <= 1'b1;
            key3_up    <= 1'b0;
        end
        3: begin
            key0_right <= 1'b0;
            key1_left  <= 1'b0;
            key2_down  <= 1'b0;
            key3_up    <= 1'b1;
        end
    endcase
end
 
 //Generate system clock 50MHz
 
 //------------------------------------------------------------
 //Get the internal variables

 //------------------------------------------------------------

 ////
 //\* Instantiation \//
 ////

 //------------- vga_rom_pic_inst -------------
game_ctrl_unit game_ctrl_unit_inst(
	.clk(clk),
	.rst_n(rst_n),
	.key0_right(key0_right),
	.key1_left(key1_left),
	.key2_down(key2_down),
	.key3_up(key3_up),
	.hit_body(hit_body),
	.hit_wall(hit_wall),
	.bcd_data(bcd_data),
	.game_statues(game_statues),
	
	.snake_display(snake_display)
	);

endmodule