module Refund_function(
input sys_clk,
input sys_rst_n,
input[1:0] coin,

output[2:0] charge,
output sell
);

parameter idle=3'd0;
parameter get05=3'd1;
parameter get10=3'd2;
parameter get15=3'd3;
parameter get20=3'd4;
parameter get25=3'd5;

reg sell_r;
reg[2:0] charge_r;

reg[2:0] st_cur;
reg[2:0] st_next;

always@(posedge sys_clk or negedge sys_rst_n) begin
	if(sys_rst_n==0) begin
		st_cur<=0;
	end
	else begin
		st_cur<=st_next;
	end
end

always@(*)begin
	case(st_cur)
	idle:
		case(coin)
			2'b01:st_next = get05;
			2'b10:st_next = get10;
			default: st_next = idle;
		endcase
	get05:
		case(coin)
			2'b01:st_next = get10;
			2'b10:st_next = get15;
			default: st_next = get05;
		endcase
	get10:
		case(coin)
			2'b01:st_next = get15;
			2'b10:st_next = get20;
			default: st_next = get10;
		endcase
	get15:
		case(coin)
			2'b01:st_next = get20;
			2'b10:st_next = get25;
			default: st_next = get15;
		endcase
	get20: st_next = idle;
	get25: st_next = idle;
	default: st_next = idle;
	endcase
end

always@(posedge sys_clk or negedge sys_rst_n)begin
	if(sys_rst_n == 0)begin
		if(st_cur == get05)begin
			charge_r <= 3'b001;
			sell_r <= 1'b0;
			end
		else if(st_cur == get10)begin
			charge_r <= 3'b010;
			sell_r <= 1'b0;
			end
		else if(st_cur == get15)begin
			charge_r <= 3'b011;
			sell_r <= 1'b0;
			end
		else if(st_cur == get20)begin
			charge_r <= 3'b100;
			sell_r <= 1'b0;
			end
		else if(st_cur == get25)begin
			charge_r <= 3'b101;
			sell_r <= 1'b0;
			end
		else begin
			charge_r<= coin;
			sell_r<=1'b0;
			end
		end
	else if(st_cur == get20)begin
			charge_r <= 2'b00;
			sell_r <= 1'b1;
			end
	else if (st_cur == get25)begin
			charge_r <= 2'b01;
			sell_r <= 1'b1;
			end
	else begin
			charge_r<= 2'b00;
			sell_r <= 1'b0;
			end
end

assign sell = sell_r;
assign charge = charge_r;

endmodule		
