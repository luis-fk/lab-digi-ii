module sonar_uc (
    input wire       clock,
    input wire       reset,
    input wire       ligar,
    input wire       fim_medida, 
    input wire       fim_transmissao, 
    input wire       fim_contador_serial,
    input wire       fim_contador_intervalo,
    output reg       zera,
    output reg       medir_distancia,
    output reg       transmitir,
    output reg       conta_serial,
    output reg       conta_updown,
    output reg       conta_intervalo,
    output reg       reset_updown,
    output reg       fim_posicao,
    output reg       zera_pwm,
    output reg [3:0] db_estado
);

    // Estados
    reg [3:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial            = 4'b0000; //0
    parameter preparacao         = 4'b0001; //1
    parameter medir              = 4'b0010; //2
    parameter espera_medida      = 4'b0011; //3
    parameter transmissao        = 4'b0100; //4
    parameter espera_transmissao = 4'b0101; //5
    parameter proximo_digito     = 4'b0110; //6
    parameter proxima_posicao    = 4'b0111; //7
    parameter gera_pulso         = 4'b1000; //8
    parameter espera_intervalo   = 4'b1001; //9

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
            inicial             : Eprox = ligar ? preparacao : inicial;
            preparacao          : Eprox = medir;
            medir               : Eprox = espera_medida;
            espera_medida       : Eprox = fim_medida ? transmissao : espera_medida;
            transmissao         : Eprox = espera_transmissao;
            espera_transmissao  : Eprox = fim_transmissao ? (fim_contador_serial ? proxima_posicao : proximo_digito) : espera_transmissao;
            proximo_digito      : Eprox = transmissao;
            proxima_posicao     : Eprox = gera_pulso;
            gera_pulso          : Eprox = espera_intervalo;
            espera_intervalo    : Eprox = fim_contador_intervalo ? preparacao : espera_intervalo;
            default             : Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        zera            = (Eatual == preparacao || Eatual == inicial ) ? 1'b1 : 1'b0;
        zera_pwm        = (Eatual == inicial ) ? 1'b1 : 1'b0;
        medir_distancia = (Eatual == medir      ) ? 1'b1 : 1'b0;
        transmitir      = (Eatual == transmissao) ? 1'b1 : 1'b0;
        conta_serial    = (Eatual == proximo_digito  ) ? 1'b1 : 1'b0;
        conta_updown    = (Eatual == proxima_posicao) ? 1'b1 : 1'b0;
        conta_intervalo = (Eatual == espera_intervalo ) ? 1'b1 : 1'b0;
        reset_updown    = (Eatual == inicial) ? 1'b1 : 1'b0;
        fim_posicao     = (Eatual == gera_pulso) ? 1'b1 : 1'b0;

        case (Eatual)
                inicial:            db_estado = 4'b0000;
                preparacao:         db_estado = 4'b0001;
                medir:              db_estado = 4'b0010;
                espera_medida:      db_estado = 4'b0011;
                transmissao:        db_estado = 4'b0100;
                espera_transmissao: db_estado = 4'b0101;
                proximo_digito:     db_estado = 4'b0110;
                proxima_posicao:    db_estado = 4'b0111;
                gera_pulso:          db_estado = 4'b1000;
                espera_intervalo:   db_estado = 4'b1001;

            default:               db_estado = 4'b1111;
        endcase
    end

endmodule