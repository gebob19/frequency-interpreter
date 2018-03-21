module ratedivider_28bit(clock, d, enable);
    input [27:0] d;
    input clock;
    output reg enable;
    reg [27:0] q;
    always @(posedge clock)
    begin
        if (q == 0)
            q <= d;
        else
            q <= q - 28'b0000000000000000000000000001;
        enable <= (q == 0) ? 1 : 0;
    end
endmodule