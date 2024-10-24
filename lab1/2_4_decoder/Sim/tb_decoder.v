`timescale 1ns/1ns
module tb_decoder();

reg in0;
reg in1;
reg Enable;                                                                              

wire out0;
wire out1;
wire out2;
wire out3;

initial begin
in0 <= 1'b0;
in1 <= 1'b0;
Enable <= 1'b0;
end

always #10 in0 <= {$random} % 2;

always #10 in1 <= {$random} % 2;

always #10 Enable <= {$random} % 2;

 
 initial begin
 $timeformat(-9, 0, "ns", 6);
 $monitor("@time %t:in0=%b in1=%b Enable=%b out0=%b out1=%b out2=%b out3=%b",$time,in0,in1,Enable,out0,out1,out2,out3);
 end

 decoder decoder_ins
 (
 .in0(in0), //input in1
 .in1(in1), //input in2
 .Enable(Enable), 

 .out0(out0), //output [7:0] out
 .out1(out1),
 .out2(out2),
 .out3(out3)
 );

 endmodule
