`timescale 1ns/1ns
module tb_Refund_function();

reg sys_clk;
reg sys_rst_n;
reg[1:0] coin;

wire[2:0] charge;
wire sell;

initial begin
sys_clk <= 1'b1;
sys_rst_n <= 1'b1;
end

always #10 sys_clk<=~sys_clk;
always #200 sys_rst_n <= ~sys_rst_n;

always@(posedge sys_clk)begin
	if(coin==0)begin
		coin <= {$random}%2+{$random}%2;
	end
	else begin
		coin <= 0;
	end
end



wire [2:0] st_cur = Refund_function_inst.st_cur;

initial begin
$timeformat(-9,0,"ns",6);
$monitor("@time %t:sell=%b charge=%b st_cur=%b sys_rst_n=%b coin=%b",$time,sell,charge,st_cur,sys_rst_n,coin);
end

Refund_function Refund_function_inst(
.sys_clk(sys_clk),
.sys_rst_n(sys_rst_n),
.coin(coin),

.sell(sell),
.charge(charge)
);

endmodule
