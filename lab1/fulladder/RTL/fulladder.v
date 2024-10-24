module fulladder(
input wire X,
input wire Y,
input wire Carry_in,
output wire Sum,
output wire Carry_out
);

assign Sum = (X^Y^Carry_in);

assign Carry_out = ((X&Y)|(X^Y)&Carry_in);

endmodule
