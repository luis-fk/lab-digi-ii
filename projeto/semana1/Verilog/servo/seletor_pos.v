/*
 * contadorg_updown_m.v
 */
 
module contadorg_updown_m #(parameter M = 14, N = 4)
(
    input  wire          clock,
    input  wire          zera_as,
    input  wire          zera_s,
    input  wire          conta,
    output reg  [N-1:0]  posicao_sel,
    output reg           fim,
    output reg           meio
);

	wire [N-1:0] saida_contador;
	
	
	contador_m #(
		.M(14),
		.N(4)
	) contador_maneiro (
    .clock(clock),
    .zera_as(),
    .zera_s(zera_s),
    .conta(conta),
    .Q(saida_contador),
    .fim(),
    .meio()
  );

	
//	always @(*) begin
//		Q <= 4'b0111;
//	end
  
	always @(posedge clock or posedge zera_as) begin
              
		case (saida_contador)
			4'b0000: posicao_sel <= 3'b000; //0  0
			4'b0001: posicao_sel <= 3'b001; //1  1
			4'b0010: posicao_sel <= 3'b010; //2  2
			4'b0011: posicao_sel <= 3'b011; //3  3
			4'b0100: posicao_sel <= 3'b100; //4  4
			4'b0101: posicao_sel <= 3'b101; //5  5
			4'b0110: posicao_sel <= 3'b110; //6  6
			4'b0111: posicao_sel <= 3'b111; //7  7
			4'b1000: posicao_sel <= 3'b110; //8  6
			4'b1001: posicao_sel <= 3'b101; //9  5
			4'b1010: posicao_sel <= 3'b100; //10 4
			4'b1011: posicao_sel <= 3'b011; //11 3
			4'b1100: posicao_sel <= 3'b010; //12 2
			4'b1101: posicao_sel <= 3'b001; //13 1
         default: posicao_sel <= 3'b000; // Valor padrão
		endcase
  end

   
  
endmodule