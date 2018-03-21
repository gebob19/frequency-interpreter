
module main (
	// Inputs
	CLOCK_50,
	SW,
	KEY,
	AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,
	I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,
	I2C_SCLK,
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,
	LEDR,
	LEDG
);
	// Inputs
	input				CLOCK_50;
    input [9:0] SW;
    input [3:0] KEY;
	input				AUD_ADCDAT;

	// Bidirectionals
	inout				AUD_BCLK;
	inout				AUD_ADCLRCK;
	inout				AUD_DACLRCK;
	inout				I2C_SDAT;

	// Outputs
	output				AUD_XCK;
	output				AUD_DACDAT;
	output				I2C_SCLK;
    output [17:0] LEDR;
    output [7:0] LEDG;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [6:0] HEX6;
	output [6:0] HEX7;

	// Internal Wires
	wire				audio_in_available;
	wire		[31:0]	left_channel_audio_in;
	wire		[31:0]	right_channel_audio_in;
	wire				read_audio_in;
	wire				audio_out_allowed;
	wire		[31:0]	left_channel_audio_out;
	wire		[31:0]	right_channel_audio_out;
	wire				write_audio_out;
	wire        [18:0]  delay;
	wire                tick;
	wire                reset;
	wire        [3:0]   frequency;

	// Internal Registers
	reg [18:0] delay_cnt;
	reg snd;
    reg [31:0] buff;

	/*****************************************************************************
	*                             Sequential Logic                              *
	*****************************************************************************/

	assign frequency = SW[3:0];
	assign delay = {frequency, 15'd3000};

	always @(posedge CLOCK_50)
	begin
		if(delay_cnt == delay) begin
			delay_cnt <= 0;
			snd <= !snd;
		end else delay_cnt <= delay_cnt + 1;
	end

	wire [27:0] sample_rate = 28'b10111110101111000001111111;

	ratedivider_28bit rateOne (
		.clock(CLOCK_50),
		.d(sample_rate),
		.enable(tick)
	);

	/*****************************************************************************
	*                            Combinational Logic                            *
	*****************************************************************************/

	assign reset = KEY[0];

	wire [31:0] sound = (SW == 0) ? 0 : snd ? 32'd10000000 : -32'd10000000;

	assign read_audio_in			= audio_out_allowed;
	assign write_audio_out			= audio_out_allowed;
	assign left_channel_audio_out	= sound;
	assign right_channel_audio_out	= sound;

	always @(posedge tick) 
	begin
		buff <= sound;
	end

	segment_decoder seg0(
		.c(buff[3:0]),
		.h(HEX0)
	);

	segment_decoder seg1(
		.c(buff[7:4]),
		.h(HEX1)
	);

	segment_decoder seg2(
		.c(buff[11:8]),
		.h(HEX2)
	);

	segment_decoder seg3(
		.c(buff[15:12]),
		.h(HEX3)
	);

	segment_decoder seg4(
		.c(buff[19:16]),
		.h(HEX4)
	);

	segment_decoder seg5(
		.c(buff[23:20]),
		.h(HEX5)
	);

	segment_decoder seg6(
		.c(buff[27:24]),
		.h(HEX6)
	);

	segment_decoder seg7(
		.c(buff[31:28]),
		.h(HEX7)
	);

	/*****************************************************************************
	*                              Internal Modules                             *
	*****************************************************************************/

	Audio_Controller Audio_Controller (
		// Inputs
		.CLOCK_50						(CLOCK_50),
		.reset						(~reset),

		.clear_audio_in_memory		(),
		.read_audio_in				(read_audio_in),
		
		.clear_audio_out_memory		(),
		.left_channel_audio_out		(left_channel_audio_out),
		.right_channel_audio_out	(right_channel_audio_out),
		.write_audio_out			(write_audio_out),

		.AUD_ADCDAT					(AUD_ADCDAT),

		// Bidirectionals
		.AUD_BCLK					(AUD_BCLK),
		.AUD_ADCLRCK				(AUD_ADCLRCK),
		.AUD_DACLRCK				(AUD_DACLRCK),


		// Outputs
		.audio_in_available			(audio_in_available),
		.left_channel_audio_in		(left_channel_audio_in),
		.right_channel_audio_in		(right_channel_audio_in),

		.audio_out_allowed			(audio_out_allowed),

		.AUD_XCK					(AUD_XCK),
		.AUD_DACDAT					(AUD_DACDAT),
	);

	/*****************************************************************************
	*                           Finite State Machine                             *
	*****************************************************************************/
    
    localparam STATE_LO3 = 4'b0000;
	localparam STATE_LO2 = 4'b0001;
	localparam STATE_LO1 = 4'b0011;
	localparam STATE_MEL = 4'b0010;
	localparam STATE_ME  = 4'b0110;
	localparam STATE_MEH = 4'b0100;
	localparam STATE_HI1 = 4'b1100;
	localparam STATE_HI2 = 4'b1000;
	localparam STATE_HI3 = 4'b1001;

	localparam INITIAL_STATE = STATE_ME;

	localparam TRANSITION_OFF = 2'b00;
	localparam TRANSITION_HI = 2'b01;
	localparam TRANSITION_ME = 2'b10;
	localparam TRANSITION_LO = 2'b11;

    reg [3:0] current_state, next_state;
    wire [1:0] transition;
	
	assign transition = (frequency + 4) / 5;

    always @(posedge tick)
    begin: state_table
        case (current_state)
            STATE_LO3:begin
                    case (transition)
						TRANSITION_LO: next_state <= STATE_LO3;
						TRANSITION_ME: next_state <= STATE_LO2;
						TRANSITION_HI: next_state <= STATE_LO2;
						default: next_state <= current_state;
					endcase
                end
            STATE_LO2:begin
                    case (transition)
						TRANSITION_LO: next_state <= STATE_LO3;
						TRANSITION_ME: next_state <= STATE_LO1;
						TRANSITION_HI: next_state <= STATE_LO1;
						default: next_state <= current_state;
					endcase
                end
            STATE_LO1:begin
                    case (transition)
						TRANSITION_LO: next_state <= STATE_LO2;
						TRANSITION_ME: next_state <= STATE_MEL;
						TRANSITION_HI: next_state <= STATE_MEL;
						default: next_state <= current_state;
					endcase
                end 
            STATE_MEL:begin
                    case (transition)
						TRANSITION_LO: next_state <= STATE_LO1;
						TRANSITION_ME: next_state <= STATE_ME;
						TRANSITION_HI: next_state <= STATE_ME;
						default: next_state <= current_state;
					endcase
                end 
            STATE_ME:begin
                    case (transition)
						TRANSITION_LO: next_state <= STATE_MEL;
						TRANSITION_ME: next_state <= STATE_ME;
						TRANSITION_HI: next_state <= STATE_MEH;
						default: next_state <= current_state;
					endcase
                end 
            STATE_MEH:begin
                    case (transition)
						TRANSITION_LO: next_state <= STATE_ME;
						TRANSITION_ME: next_state <= STATE_ME;
						TRANSITION_HI: next_state <= STATE_HI1;
						default: next_state <= current_state;
					endcase
                end 
            STATE_HI1:begin
                    case (transition)
						TRANSITION_LO: next_state <= STATE_MEH;
						TRANSITION_ME: next_state <= STATE_MEH;
						TRANSITION_HI: next_state <= STATE_HI2;
						default: next_state <= current_state;
					endcase
                end
            STATE_HI2:begin
                    case (transition)
						TRANSITION_LO: next_state <= STATE_HI1;
						TRANSITION_ME: next_state <= STATE_HI1;
						TRANSITION_HI: next_state <= STATE_HI3;
						default: next_state <= current_state;
					endcase
                end
            STATE_HI3:begin
                    case (transition)
						TRANSITION_LO: next_state <= STATE_HI2;
						TRANSITION_ME: next_state <= STATE_HI2;
						TRANSITION_HI: next_state <= STATE_HI3;
						default: next_state <= current_state;
					endcase
                end
            default: next_state = current_state;
        endcase
    end // state_table
    
    // State Registers
    always @(posedge CLOCK_50)
    begin
        if(reset == 1'b0)
            current_state <= INITIAL_STATE;
        else
            current_state <= next_state;
    end

    // Debugging Output
    assign LEDR[3:0] = current_state;
	assign LEDG[1:0] = transition;
endmodule

