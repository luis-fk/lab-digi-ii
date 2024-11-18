module comporta_uc (
    input wire       clock,
    input wire       reset,
    input wire       abrirComporta,
    input wire       inicioPosicao,
    input wire       fimPosicao,
    input wire       fimContadorIntervalo,
    input wire       pesoMaxIgualZero,
    input wire       comando,
    output reg       contaIntervalo,
    output reg       contaUpdown,
    output reg       zeraIntervalo,
    output reg       zeraUpdown,
    output reg [3:0] dbEstado

);
    // Estados
    reg [3:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial         = 4'b0000;
    parameter prepara         = 4'b0001;
    parameter mudaPosicao     = 4'b0010;
    parameter esperaIntervalo = 4'b0011;
    parameter mudaPosicao2    = 4'b0100;
    parameter esperaFechar    = 4'b0100;
    parameter mudaPosicao3    = 4'b0100;
    parameter esperaIntervalo2 = 4'b0011;


    // Estado
    always @(posedge clock, posedge reset) begin
        if (reset) 
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial         : Eprox = abrirComporta ? (comando ? prepara : (pesoMaxIgualZero ? inicial : prepara)) : inicial;
            prepara         : Eprox = mudaPosicao;
            mudaPosicao     : Eprox = esperaIntervalo;
            esperaIntervalo : Eprox = fimPosicao ? esperaFechar : (fimContadorIntervalo ? (inicioPosicao ? inicial : mudaPosicao) : esperaIntervalo);
            esperaFechar    : Eprox = abrirComporta ? esperaFechar : mudaPosicao;
            default         : Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        zeraUpdown     = (Eatual == inicial || Eatual == prepara) ? 1'b1 : 1'b0;
        zeraIntervalo  = (Eatual == prepara)         ? 1'b1 : 1'b0;
        contaUpdown    = (Eatual == mudaPosicao)     ? 1'b1 : 1'b0;
        contaIntervalo = (Eatual == esperaIntervalo) ? 1'b1 : 1'b0;

        case (Eatual)
            inicial:         dbEstado = 4'b0000;
            prepara:         dbEstado = 4'b0001;
            mudaPosicao:     dbEstado = 4'b0010;
            esperaIntervalo: dbEstado = 4'b0011;
            esperaFechar:    dbEstado = 4'b0100;
            default:      dbEstado = 4'b1111;
        endcase
    end

endmodule