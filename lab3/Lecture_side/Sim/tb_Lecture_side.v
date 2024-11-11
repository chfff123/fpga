`timescale 1ns/1ns
module tb_Lecture_side();

////
//\* Parameter and Internal Signal \//
////

//reg define
 reg sys_clk;
 reg sys_rst_n;
 reg[2:0] coin;


 //wire define
 wire change;
 wire sell;

 ////
 //\* Main Code \//
 ////

 //初始化系统时钟、全局复位
 initial begin
 sys_clk = 1'b1;
 coin <= 2'b00;
 sys_rst_n <= 1'b0;
 #20
 sys_rst_n <= 1'b1;
 end

 //sys_clk:模拟系统时钟，每10ns电平翻转一次，周期为20ns，频率为50MHz
 always #10 sys_clk = ~sys_clk;

always@(posedge sys_clk)begin
if(coin==0)begin 
  coin <= {$random} % 2+{$random} % 2;
end 
else if(coin!=0)begin
	coin<=0;
	end
end

 wire [2:0] st_cur = Lecture_side_inst.st_cur;



 initial begin
 $timeformat(-9, 0, "ns", 6);
 $monitor("@time %t: sell=%b coin=%b change=%b st_cur=%b", $time,sell,coin,change,st_cur);
 end
 //------------------------------------------------------------

 ////
 //\* Instantiation \//
 ////

 //------------------------complex_fsm_inst------------------------
Lecture_side Lecture_side_inst(
 .sys_clk (sys_clk ), //input sys_clk
 .sys_rst_n (sys_rst_n ), //input sys_rst_n
 .coin (coin ), //input pi_money_one

 .sell (sell ), //output po_money
 .change (change) //output po_cola
 );

 endmodule