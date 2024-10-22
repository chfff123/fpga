`timescale 1ns/1ns
module tb_fulladder();

reg X;
reg Y;
reg Carry_in;

wire Sum;
wire Carry_out;

 
initial begin
X <= 1'b0;
Y <= 1'b0;
Carry_in <= 1'b0;
end

always #10 X <= {$random} % 2;

always #10 Y <= {$random} % 2;

always #10 Carry_in <= {$random} % 2;

initial begin
$timeformat(-9, 0, "ns", 6);
$monitor("@time %t:X=%b Y=%b Carry_in=%b Sum=%b Carry_out=%b",$time,X,Y,Carry_in,Sum,Carry_out);
end


fulladder fulladder_inst
(
.X (X ), //input in1
.Y (Y ), //input in2
.Carry_in (Carry_in ), //input in1


.Sum (Sum ), //output sum
.Carry_out (Carry_out ) //output cout
);

 endmodule