module sonar (
    input wire        clock,
    input wire        reset,
    input wire        ligar,
    input wire        echo,
    input wire        display_mode,
    output wire       trigger,
    output wire       pwm,
    output wire       saida_serial,
    output wire       fim_posicao,
    output wire [6:0] db_estado
);

    // Sinais internos
    wire        s_ligar;
    wire        s_transmitir;
    wire        s_fim_transmissao;
    wire        s_fim_contador;
    wire        s_zera;
    wire        s_conta;
    wire        s_medir_distancia;
    wire        fim_medicao ;
    wire        s_trigger;
    wire [11:0] s_medida ;
    wire [3:0]  s_estado ;
    wire        s_fim_contador32;
    wire        s_conta32;
    wire        s_reset_contador32;
    wire s_conta_updown;
    wire s_reset_updown;
    
    assign db_saida_serial = saida_serial;
    assign medida = s_medida;

    sonar_fd exp5_fd(
        .clock                  (clock),
        .reset                  (s_zera),
        .medir                  (s_medir_distancia),
        .echo                   (echo),
        .display_mode           (display_mode),
        .transmitir             (s_transmitir),
        .conta_updown           (s_conta_updown),
        .reset_updown           (s_reset_updown),
        .conta_serial           (s_conta_serial),
        .conta_intervalo        (s_conta_intervalo),
        .trigger                (s_trigger),
        .pwm                    (pwm),
        .fim_distancia          (s_fim_distancia),
        .fim_transmissao        (s_fim_transmissao),
        .fim_contador_serial    (s_fim_contador_serial),
        .fim_contador_intervalo (s_fim_contador_intervalo),
        .saida_serial           (saida_serial),
        .medida                 (s_medida)
        );
   
    wire s_fim_distancia;
    wire s_fim_contador_serial;
    wire s_fim_contador_intervalo;
    wire s_conta_serial;
    wire s_conta_intervalo;

    sonar_uc exp5 (
        .clock                 (clock),
        .reset                 (reset),
        .ligar                 (s_ligar),
        .fim_medida            (s_fim_distancia), 
        .fim_transmissao       (s_fim_transmissao), 
        .fim_contador_serial   (s_fim_contador_serial),
        .fim_contador_intervalo(s_fim_contador_intervalo),
        .zera                  (s_zera),
        .medir_distancia       (s_medir_distancia),
        .transmitir            (s_transmitir),
        .conta_serial          (s_conta_serial),
        .conta_updown          (s_conta_updown),
        .conta_intervalo       (s_conta_intervalo),
        .reset_updown          (s_reset_updown),
        .db_estado             (s_estado)
        );

    // Displays para medida (4 dígitos BCD)
    hexa7seg H0 (
        .hexa   (s_medida[3:0]), 
        .display(hex0         )
    );
    hexa7seg H1 (
        .hexa   (s_medida[7:4]), 
        .display(hex1         )
    );
    hexa7seg H2 (
        .hexa   (s_medida[11:8]), 
        .display(hex2          )
    );
wire [6:0] hex0;
wire [6:0] hex1;
wire [6:0] hex2;

    // Trata entrada medir (considerando borda de subida)
    edge_detector DB (
        .clock(clock  ),
        .reset(reset  ),
        .sinal(~ligar ), 
        .pulso(s_ligar)
    );

    // Sinais de saída
    assign trigger = s_trigger;

    // Sinal de depuração (estado da UC)
    hexa7seg H5 (
        .hexa   (s_estado ), 
        .display(db_estado)
    );

endmodule