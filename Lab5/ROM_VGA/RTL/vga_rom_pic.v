module vga_rom_pic(
input wire sys_clk , 
input wire sys_rst_n , 

output wire hsync , 
output wire vsync , 
output wire [15:0] rgb 

);
 wire vga_clk ; 
 wire locked ; 
 wire rst_n ; 
 wire [9:0] pix_x ; 
 wire [9:0] pix_y ; 
 wire [15:0] pix_data; 


 assign rst_n = (sys_rst_n & locked);


 clk_gen clk_gen_inst
 (
 .areset (~sys_rst_n ), 
 .inclk0 (sys_clk ), 

 .c0 (vga_clk ), 
 .locked (locked ) 
 );


 vga_ctrl vga_ctrl_inst
 (
 .vga_clk (vga_clk ), 
 .sys_rst_n (rst_n ),
 .pix_data (pix_data ), 

 .pix_x (pix_x ), 
 .pix_y (pix_y ), 
 .hsync (hsync ), 
 .vsync (vsync ), 
 .rgb (rgb ) 
 );

 vga_pic vga_pic_inst
 (
 .vga_clk (vga_clk ), //VGA working clock, 25MHz
 .sys_rst_n (rst_n ), //Reset signal. Low level is effective
 .pix_x (pix_x ), //x coordinate of current pixel
 .pix_y (pix_y ), //y coordinate of current pixel

 .pix_data_out (pix_data ) //color information

 );

 endmodule