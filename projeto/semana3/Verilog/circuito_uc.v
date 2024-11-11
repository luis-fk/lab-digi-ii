module circuito_uc (
    input wire       clock,
    input wire       reset,
    input wire       fimRecepcao,
    input wire       comando,
    output reg       abrir,
    output reg       enableReg,
    output reg [3:0] dbEstado

);
    // Estados
    reg [3:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial      = 4'b0000;
    parameter esperaDado   = 4'b0001;
    parameter armazenaDado = 4'b0010;
    parameter mudarPosicao = 4'b0011;

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
            inicial      : Eprox = esperaDado;
            esperaDado   : Eprox = fimRecepcao ? (comando ? mudarPosicao : armazenaDado) : esperaDado;
            armazenaDado : Eprox = esperaDado;
            mudarPosicao : Eprox = esperaDado;
            default      : Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        abrir     = (Eatual == mudarPosicao) ? 1'b1 : 1'b0;
        enableReg = (Eatual == armazenaDado) ? 1'b1 : 1'b0;

        case (Eatual)
            inicial:      dbEstado = 4'b0000;
            esperaDado:   dbEstado = 4'b0001;
            armazenaDado: dbEstado = 4'b0010;
            mudarPosicao: dbEstado = 4'b0011;
            default:      dbEstado = 4'b1111;
        endcase
    end

endmodule