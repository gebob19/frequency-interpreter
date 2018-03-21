// Copyright (c) 2012 Ben Reynwar
// Released under MIT License (see LICENSE.txt)

module twiddlefactors (
    input  wire                            clk,
    input  wire [2:0]          addr,
    input  wire                            addr_nd,
    output reg signed [31:0] tf_out
  );

  always @ (posedge clk)
    begin
      if (addr_nd)
        begin
          case (addr)
			
            3'd0: tf_out <= { 16'sd16384,  -16'sd0 };
			
            3'd1: tf_out <= { 16'sd15137,  -16'sd6270 };
			
            3'd2: tf_out <= { 16'sd11585,  -16'sd11585 };
			
            3'd3: tf_out <= { 16'sd6270,  -16'sd15137 };
			
            3'd4: tf_out <= { 16'sd0,  -16'sd16384 };
			
            3'd5: tf_out <= { -16'sd6270,  -16'sd15137 };
			
            3'd6: tf_out <= { -16'sd11585,  -16'sd11585 };
			
            3'd7: tf_out <= { -16'sd15137,  -16'sd6270 };
			
            default:
              begin
                tf_out <= 32'd0;
              end
         endcase
      end
  end
endmodule