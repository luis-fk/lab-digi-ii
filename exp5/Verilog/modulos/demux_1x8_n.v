module demux_1x8 #(
    parameter BITS = 3
) (
    input  [BITS-1:0] IN,    // Entrada única
    input  [2:0]      SEL,   // Seletor para escolher a saída
    output [BITS-1:0] D7,    // Saída 7
    output [BITS-1:0] D6,    // Saída 6
    output [BITS-1:0] D5,    // Saída 5
    output [BITS-1:0] D4,    // Saída 4
    output [BITS-1:0] D3,    // Saída 3
    output [BITS-1:0] D2,    // Saída 2
    output [BITS-1:0] D1,    // Saída 1
    output [BITS-1:0] D0     // Saída 0
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



entrada: largura

saida: bcd -> s_angulo


exemplo

001

saida 

0000 0000 0001
