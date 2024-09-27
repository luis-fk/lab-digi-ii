module demux_1x8_n #(
    parameter BITS = 3
) (
    input  [BITS-1:0] IN, 
    input  [2:0]      SEL, 
    output [BITS-1:0] D7,
    output [BITS-1:0] D6,
    output [BITS-1:0] D5,
    output [BITS-1:0] D4,
    output [BITS-1:0] D3,
    output [BITS-1:0] D2,
    output [BITS-1:0] D1,
    output [BITS-1:0] D0 
);

    assign D7 = (SEL == 3'b111) ? IN : {BITS{1'b0}};
    assign D6 = (SEL == 3'b110) ? IN : {BITS{1'b0}};
    assign D5 = (SEL == 3'b101) ? IN : {BITS{1'b0}};
    assign D4 = (SEL == 3'b100) ? IN : {BITS{1'b0}};
    assign D3 = (SEL == 3'b011) ? IN : {BITS{1'b0}};
    assign D2 = (SEL == 3'b010) ? IN : {BITS{1'b0}};
    assign D1 = (SEL == 3'b001) ? IN : {BITS{1'b0}};
    assign D0 = (SEL == 3'b000) ? IN : {BITS{1'b0}};

endmodule
