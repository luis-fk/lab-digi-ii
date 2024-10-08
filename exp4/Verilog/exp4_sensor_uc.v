module exp4_sensor_uc (
    input wire       clock,
    input wire       reset,
    input wire       mensurar,
    input wire       fim_medida,
    input wire       fim_transmissao, 
    input wire       fim_contador,

    input wire       fim_contador32,

    output reg       zera,
    output reg       medir_distancia,
    output reg       transmitir,
    output reg       conta,
    output reg       conta32,
    output reg       pronto,

    output reg       reset_contador32,

    output reg [3:0] db_estado
);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial            = 4'b0000;
    parameter preparacao         = 4'b0001;
    parameter medir              = 4'b0010;
    parameter espera_medida      = 4'b0011;
    parameter transmissao        = 4'b0100;
    parameter espera_transmissao = 4'b0101;
    parameter contador           = 4'b0110;
    parameter espera_contador32  = 4'b0111;
    parameter fim                = 4'b1111;

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
            inicial             : Eprox = mensurar ? preparacao : inicial;
            preparacao          : Eprox = medir;
            medir               : Eprox = espera_medida;
            espera_medida       : Eprox = fim_medida ? transmissao : espera_medida;
            transmissao         : Eprox = espera_transmissao;
            espera_transmissao  : Eprox = fim_transmissao ? (fim_contador ? (fim_contador32 ? fim : espera_contador32) : contador) : espera_transmissao;
            contador            : Eprox = transmissao;
            espera_contador32   : Eprox = fim_contador32 ? preparacao : espera_contador32;
            fim                 : Eprox = mensurar ? medir : fim;
            default             : Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        zera            = (Eatual == preparacao || Eatual == inicial ) ? 1'b1 : 1'b0;
        medir_distancia = (Eatual == medir      ) ? 1'b1 : 1'b0;
        transmitir      = (Eatual == transmissao) ? 1'b1 : 1'b0;
        conta           = (Eatual == contador   ) ? 1'b1 : 1'b0;
        pronto          = (Eatual == fim        ) ? 1'b1 : 1'b0;
        conta32         = (Eatual == espera_contador32 ) ? 1'b1 : 1'b0;
        reset_contador32 = (Eatual == fim ) ? 1'b1 : 1'b0;

        case (Eatual)
            inicial:            db_estado = 4'b0000;
            preparacao:         db_estado = 4'b0001;
            medir:              db_estado = 4'b0010;
            espera_medida:      db_estado = 4'b0011;
            transmissao:        db_estado = 4'b0100;
            espera_transmissao: db_estado = 4'b0101;
            contador:           db_estado = 4'b0110;
            espera_contador32:  db_estado = 4'b0111;
            fim:                db_estado = 4'b1111;
           
            default:            db_estado = 4'b1111;
        endcase
    end


endmodule