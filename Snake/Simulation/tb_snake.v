`timescale 1ns/ 1ns
module tb_snake();

reg clk;
    reg rst_n;
    reg sw2, sw1, sw0;
    reg key0_right, key1_left, key2_down, key3_up;
    reg [9:0] pos_x, pos_y;
    reg add_cube, died;

    // Outputs
    wire [5:0] head_x, head_y;

    // Instantiate the Unit Under Test (UUT)
    snake snake_inst (
        .clk(clk),
        .rst_n(rst_n),
        .sw2(sw2),
        .sw1(sw1),
        .sw0(sw0),
        .key0_right(key0_right),
        .key1_left(key1_left),
        .key2_down(key2_down),
        .key3_up(key3_up),
        .pos_x(pos_x),
        .pos_y(pos_y),
        .head_x(head_x),
        .head_y(head_y),
        .add_cube(add_cube),
        .died(died)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50MHz clock
    end
	 
	wire [1:0] direct_r = snake_inst.direct_r;		//寄存方向
	wire [3:0] cube_num = snake_inst.cube_num;//蛇的节数


    // Test stimulus
    initial begin
        // Initialize inputs
        rst_n = 0;
        sw2 = 0; sw1 = 0; sw0 = 0;
        key0_right = 0; key1_left = 0; key2_down = 0; key3_up = 0;
        pos_x = 0; pos_y = 0;
        add_cube = 0; died = 0;

        // Reset the system
        #50 rst_n = 1;

        // Test Case 1: Default state
        #100;

        // Test Case 2: Move snake right
        key0_right = 1;
        #100 key0_right = 0;

        // Test Case 3: Move snake left
        key1_left = 1;
        #100 key1_left = 0;

        // Test Case 4: Move snake down
        key2_down = 1;
        #100 key2_down = 0;

        // Test Case 5: Move snake up
        key3_up = 1;
        #100 key3_up = 0;

        // Test Case 6: Add cube
        add_cube = 1;
        #50 add_cube = 0;

        // Test Case 7: Death scenario
        died = 1;
        #50 died = 0;

        // Finish simulation
        #500 $stop;
    end

endmodule
