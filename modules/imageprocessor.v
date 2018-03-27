module imageprocessor(
	// Inputs
	clock,
	resetn,
	image,
	color_background,
	color_foreground,
	// Outputs
	x,
	y,
	color
);
	input			clock;
	input   		resetn;
	input  [19199:0] image;
	input [2:0] color_background;
	input [2:0] color_foreground;

	output	[7:0]	x;
	output	[6:0]	y;
	output	[2:0]	color;
	
	painter p(
		.reset_n(resetn),
		.clock(clock),
		.image(image),
		.color_background(color_background),
		.color_foreground(color_foreground),
		.x(x),
		.y(y),
		.color(color)
	);
endmodule

module painter(
	// Inputs
	reset_n,
	clock,
	image,
	color_background,
	color_foreground,
	// Outputs
	x,
	y,
	color
);
	input reset_n, clock;
	input [19199:0] image;
	input [2:0] color_background;
	input [2:0] color_foreground;
		
	output [7:0] x;
	output [6:0] y;
	output [2:0] color;
	reg [0:14] count;
	reg [0:2] color_out;

	always @(posedge clock) // creates curr coordinates for 4x4 from origin (x,y)
	begin
		if (count == 19199)
			count <= 0;
		else
			count <= count + 1'b1;
		
		if (image[19199 - count] == 1'b1)
			color_out <= color_foreground;
		else
			color_out <= color_background;
	end
	
	assign color = color_out;
	assign x = count % 160;
	assign y = 120 - (count / 160);
endmodule
