/* --------------------------------------------------------------------------
 *  Arquivo   : contador_cm_uc-PARCIAL.v
 * --------------------------------------------------------------------------
 *  Descricao : unidade de controle do componente contador_cm
 *              
 *              incrementa contagem de cm a cada sinal de tick enquanto
 *              o pulso de entrada permanece ativo
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */

module contador_cm_uc (
    input wire clock,
    input wire reset,
    input wire pulso, // echo
    input wire tick,
    output reg zera_tick,
    output reg conta_tick,
    output reg zera_bcd,
    output reg conta_bcd,
    output reg pronto
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; // 3 bits são suficientes para os estados

    // Parâmetros para os estados
	/* completar */
    parameter inicial    = 3'b000;
    parameter prepara    = 3'b001; // zera tudo
    parameter conta      = 3'b010; // conta o contador_m; muda de estado para conta_cm quando metade = 1
    parameter conta_cm   = 3'b011; // conta cm
    parameter fim        = 3'b100; // salva no reg

    // Memória de estado
    always @(posedge clock, posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial    : Eprox = pulso ? prepara : inicial;
            prepara    : Eprox = pulso ? conta : fim;
            conta      : Eprox = pulso ? (tick ? conta_cm : conta) : fim;
            conta_cm   : Eprox = pulso ? conta : fim;
            fim        : Eprox = inicial;
        endcase
    end

    // Lógica de saída (Moore)
    always @(*) begin
	
        zera_tick  = (Eatual == prepara)  ? 1'b1 : 1'b0;
        zera_bcd   = (Eatual == prepara)  ? 1'b1 : 1'b0;
        conta_tick = (Eatual == conta || Eatual == conta_cm)    ? 1'b1 : 1'b0;
        conta_bcd  = (Eatual == conta_cm) ? 1'b1 : 1'b0;
        pronto     = (Eatual == fim)      ? 1'b1 : 1'b0;
    end

endmodule