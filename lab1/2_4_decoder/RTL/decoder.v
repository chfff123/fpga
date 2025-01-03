module decoder(
input wire in0,
input wire in1,
input wire Enable,
output wire out0,
output wire out1,
output wire out2,
output wire out3
);

assign out0 = !(in0&in1&Enable);

assign out1 = !(in0&(!in1)&Enable);

assign out2 = !((!in0)&(in1)&Enable);

assign out3 = !((!in0)&(!in1)&Enable);

endmodule