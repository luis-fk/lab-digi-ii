module decoder(
    input  [2:0] posicao, 
    output [11:0] angulo  
);

    assign angulo = (posicao == 3'b000) ? {12'b0000_0001_0000} : //10º
            (posicao == 3'b001) ? {12'b0000_0010_0000} : //20º
            (posicao == 3'b010) ? {12'b0000_0011_0000} : //30º
            (posicao == 3'b011) ? {12'b0000_0100_0000} : //40º
            (posicao == 3'b100) ? {12'b0000_0101_0000} : //50º
            (posicao == 3'b101) ? {12'b0000_0110_0000} : //60º
            (posicao == 3'b110) ? {12'b0000_0111_0000} : //70º
            (posicao == 3'b111) ? {12'b0000_1000_0000} : //80º
            12'b0; 

endmodule