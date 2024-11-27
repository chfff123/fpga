`timescale  1ns/1ns

module  tb_vga_char();

wire            hsync       ;
wire    [15:0]  rgb         ;
wire            vsync       ;

//reg   define
reg             sys_clk     ;
reg             sys_rst_n   ;


initial
    begin
        sys_clk     =   1'b1;
        sys_rst_n   <=  1'b0;
        #200
        sys_rst_n   <=  1'b1;
    end

always  #10 sys_clk = ~sys_clk  ;

wire [9:0] pix_x = vga_char_inst.vga_ctrl_inst.pix_x;
wire [9:0] pix_y = vga_char_inst.vga_ctrl_inst.pix_y;
wire [15:0] pix_data = vga_char_inst.vga_ctrl_inst.p
ix_data;
wire [9:0] char_x = vga_char_inst.vga_pic_inst.char_x;
wire [9:0] char_y = vga_char_inst.vga_pic_inst.char_y;



vga_char    vga_char_inst
(
    .sys_clk    (sys_clk    ), 
    .sys_rst_n  (sys_rst_n  ),  

    .hsync      (hsync      ), 
    .vsync      (vsync      ),  
    .rgb        (rgb        )   
);

endmodule

