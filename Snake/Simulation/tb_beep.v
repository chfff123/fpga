`timescale 1ns/ 1ns
module tb_beep();

//// Internal Signal \//
////
//wfine
    reg enb1;
    reg enb2;
	 reg output_beep;
	 reg [17:0] freq_datas;
    reg sys_clk; // 系统时钟, 频率50MHz
    reg sys_rst_n; // 系统复位，低有效
    wire beep ;// 输出蜂鸣器控制信号t \//
 ////

 //Init sys_clk,sys_rst_n
 initial
 begin
	 sys_clk = 1'b1;
	 sys_rst_n <= 1'b0;
	 enb1 <= 1'b1;
	 enb2 <= 1'b0;
	 #200
	 sys_rst_n <= 1'b1;
 end

 //Generate system clock 50MHz
 always #10 sys_clk = ~sys_clk ;
 always #20 enb1 = ~enb1 ;
 always #20 enb2 = ~enb2;
		
 
always@(posedge sys_clk or negedge sys_rst_n) begin
 if (enb1) begin
	freq_datas <= 18'd190839;
	output_beep <= 1'b1;
	end
 else if (enb2)begin
	freq_datas <= 18'd127550;
	output_beep <= 1'b1;
	end
	else begin
	output_beep <= 1'b0;
	freq_datas <= 18'b0;
	end
end
 
 //------------------------------------------------------------
 //Get the internal variables

 //------------------------------------------------------------

 ////
 //\* Instantiation \//
 ////

 //------------- vga_rom_pic_inst -------------
beep
#(
 .TIME_500MS(25'd24999), //0.5s计数值
 .DO (18'd190 ), //"哆"音调分频计数值（频率262）
 .SO (18'd127 ) //"梭"音调分频计数值（频率392）
) 
beep_inst(
    .enb1(enb1),
    .enb2(enb2),
	 .freq_datas(freq_datas),
	 .output_beep(output_beep),
    .sys_clk(clk), // 系统时钟, 频率50MHz
    .sys_rst_n(rst_n), // 系统复位，低有效
	 
    .beep(beep) // 输出蜂鸣器控制信号t \//
);

endmodule