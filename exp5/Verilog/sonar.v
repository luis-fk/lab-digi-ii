module sonar (
    input wire        clock,
    input wire        reset,
    input wire        ligar,
    input wire        echo,
    input wire        display_mode,
    //saidas
    output wire       trigger,
    output wire       pwm,
    output wire       saida_serial,
    output wire       fim_posicao,
    output wire [11:0] medida,
    //hexas
    output wire [6:0]  hex0,
    output wire [6:0]  hex1,
    output wire [6:0]  hex2,
    output wire [6:0]  hex3,
    output wire [6:0]  hex4,
    output wire [6:0]  hex5,
    //dbs
    output wire       db_fim_transmissao,
    output wire       db_fim_posicao,
    output wire       db_saida_serial
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
    wire [11:0] s_distancia;
    wire [3:0]  s_estado ;
    wire s_conta_updown;
    wire s_reset_updown;
    wire s_fim_posicao;
    
    assign fim_posicao = s_fim_posicao;
    assign db_fim_posicao = s_fim_posicao;
    assign medida = s_distancia;
    assign db_saida_serial = saida_serial;
    assign db_fim_transmissao = s_fim_transmissao;

    sonar_fd exp5_fd(
        .clock                  (clock),
        .reset                  (s_zera),
        .medir                  (s_medir_distancia),
        .echo                   (echo),
        .transmitir             (s_transmitir),
        .conta_updown           (s_conta_updown),
        .reset_updown           (s_reset_updown),
        .conta_serial           (s_conta_serial),
        .conta_intervalo        (s_conta_intervalo),
        //saidas
        .trigger                (s_trigger),
        .pwm                    (pwm),
        .fim_distancia          (s_fim_distancia),
        .fim_transmissao        (s_fim_transmissao),
        .fim_contador_serial    (s_fim_contador_serial),
        .fim_contador_intervalo (s_fim_contador_intervalo),
        .saida_serial           (saida_serial),
        .distancia              (s_distancia),
        .angulo                 (s_angulo),
        .db_estado_interface    (s_db_estado_interface),
        .db_estado_serial       (s_db_estado_serial),
        .db_saida_serial        (s_db_saida_serial),
        .db_controle_servo      (s_db_controle_servo),
        .db_posicao_servo       (s_db_posicao_servo)
    );

    wire [3:0] s_db_estado_interface;
    wire [3:0] s_db_estado_serial;
    wire s_db_saida_serial;
    wire s_db_controle_servo;
    wire [2:0] s_db_posicao_servo;

    wire [11:0] s_angulo; 
    wire [3:0] db_estado_sonar;

    wire [3:0] s_angulo_unidade;
    wire [3:0] s_angulo_dezena;
    wire [3:0] s_angulo_centena;

    wire [3:0] s_distancia_unidade;
    wire [3:0] s_distancia_dezena;
    wire [3:0] s_distancia_centena;

    wire s_fim_distancia;
    wire s_fim_contador_serial;
    wire s_fim_contador_intervalo;
    wire s_conta_serial;
    wire s_conta_intervalo; 
    
    assign s_angulo_unidade = s_angulo[3:0];
    assign s_angulo_dezena = s_angulo[7:4];
    assign s_angulo_centena = s_angulo[11:8];

    assign s_distancia_unidade = s_distancia[3:0];
    assign s_distancia_dezena = s_distancia[7:4];
    assign s_distancia_centena = s_distancia[11:8];

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
        .fim_posicao           (s_fim_posicao),
        .db_estado             (db_estado_sonar)
        );

   wire [23:0] displays;

    // há dois modos de operação:
        // -modo 1: a saida será {distancia, angulo} (cada um com 3 displays)
        // -modo 2: a saída será {posicao do servo, 0, 0, estado do sonar, estado da interface, estado da serial}
        
    // mux para a multiplexação de recursos
    assign displays = (display_mode == 1'b1) ? {s_distancia_centena,      s_distancia_dezena, s_distancia_unidade, s_angulo_centena, s_angulo_dezena,       s_angulo_unidade} 
                                            :  {1'b0, s_db_posicao_servo, 4'b0,               4'b0,                db_estado_sonar,  s_db_estado_interface, s_db_estado_serial};

    // Displays para medida (4 dígitos BCD)
    hexa7seg H0 (
        .hexa   (displays[3:0]), 
        .display(hex0         )
    );

    hexa7seg H1 (
        .hexa   (displays[7:4]), 
        .display(hex1         )
    );

    hexa7seg H2 (
        .hexa   (displays[11:8]), 
        .display(hex2          )
    );

    hexa7seg H3 (
        .hexa   (displays[15:12]), 
        .display(hex3          )
    );

    hexa7seg H4 (
        .hexa   (displays[19:16]), 
        .display(hex4          )
    );

    hexa7seg H5 (
        .hexa   (displays[23:20]), 
        .display(hex5          )
    );

    // Trata entrada medir (considerando borda de subida)
    edge_detector DB (
        .clock(clock  ),
        .reset(reset  ),
        .sinal(~ligar ), 
        .pulso(s_ligar)
    );

    // Sinais de saída
    assign trigger = s_trigger;

endmodule