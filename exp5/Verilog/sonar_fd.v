 module sonar_fd (
    input wire         clock,
    input wire         reset,
    input wire         medir,
    input wire         echo,
    input wire         transmitir,
    input wire         conta_updown,
    input wire         reset_updown,
    input wire         conta_serial,
    input wire         conta_intervalo,
    input wire         zera_pwm,
    //saidas
    output wire        trigger,
    output wire        pwm,
    output wire        fim_distancia,
    output wire        fim_transmissao,
    output wire        fim_contador_serial,
    output wire        fim_contador_intervalo,
    output wire        saida_serial,
    output wire [11:0] distancia,
    output wire [11:0] angulo,
    // dbs
    output wire [3:0] db_estado_interface,
    output wire [3:0] db_estado_serial,
    output wire       db_saida_serial,
    output wire       db_controle_servo,
    output wire [2:0] db_posicao_servo
);

    wire        s_fim_distancia;
    wire        s_fim_transmissao;
    wire        s_fim_contador_intervalo;

    wire [2:0]  s_valor_contador_updown;
    wire [11:0] s_distancia;
    wire [6:0]  s_medida_ascii;
    wire [6:0]  s_mux_serial_out;
    wire [2:0]  s_mux_posicao_out;
    wire [11:0] s_angulo;
    wire [3:0] s_angulo_unidade;
    wire [3:0] s_angulo_dezena;
    wire [3:0] s_angulo_centena;
    wire [3:0] s_distancia_unidade;
    wire [3:0] s_distancia_dezena;
    wire [3:0] s_distancia_centena;
    wire [2:0] s_valor_contador_serial;
    wire s_fim_contador_serial;

    assign fim_contador_serial = s_fim_contador_serial;
    assign fim_transmissao = s_fim_transmissao;
    assign fim_distancia = s_fim_distancia;
    assign fim_contador_intervalo = s_fim_contador_intervalo;

    assign s_angulo_unidade = s_angulo[3:0];
    assign s_angulo_dezena = s_angulo[7:4];
    assign s_angulo_centena = s_angulo[11:8];

    assign s_distancia_centena = s_distancia[11:8];
    assign s_distancia_dezena = s_distancia[7:4];
    assign s_distancia_unidade = s_distancia[3:0];

    assign angulo = s_angulo;
    assign distancia = s_distancia;

    interface_hcsr04 INT (
        .clock    (clock          ),
        .reset    (reset          ),
        .medir    (medir          ),
        .echo     (echo           ),
        .trigger  (trigger        ),
        .medida   (s_distancia    ),
        .pronto   (s_fim_distancia),
        .db_estado(db_estado_interface)
    );

    controle_servo_3 SERVO (
        .clock      (clock            ),
        .reset      (zera_pwm         ),
        .posicao    (s_mux_posicao_out),
        .controle   (pwm              ),
        .db_reset   (                 ),
        .db_controle(s_db_controle_servo),
        .db_posicao (s_db_posicao_servo)
    );

    wire s_db_controle_servo;
    wire [2:0] s_db_posicao_servo;

    assign db_controle_servo = s_db_controle_servo;
    assign db_posicao_servo = s_db_posicao_servo;


    contadorg_updown_m #( .M(8), .N(3) ) UPDOWN (
        .clock  (clock              ),
        .zera_as(                   ),
        .zera_s (reset_updown       ),
        .conta  (conta_updown       ),
        .Q      (s_valor_contador_updown  ),
        .inicio (                   ),
        .fim    (                   ),
        .meio   (                   ),
        .direcao(                   )
    );

    mux_8x1_n #( .BITS(3) ) MUX_POSICAO (
        .D7     (3'b111),
        .D6     (3'b110),
        .D5     (3'b101),
        .D4     (3'b100),
        .D3     (3'b011),
        .D2     (3'b010),
        .D1     (3'b001),
        .D0     (3'b000),
        .SEL    (s_valor_contador_updown),
        .MUX_OUT(s_mux_posicao_out)
    );

    decoder DECODER_ANGULO(
        .posicao(s_mux_posicao_out),
        .angulo(s_angulo)
    );
// trocar para 200_000_000 dps
    contador_m #( .M(6_000_000), .N(28) ) CONT_INTERVALO (
        .clock  (clock              ),
        .zera_as(                   ),
        .zera_s (reset              ),
        .conta  (conta_intervalo),
        .Q      (                   ),
        .fim    (s_fim_contador_intervalo),
        .meio   (                   )
    );

    contador_m #( .M(8), .N(3) ) CONTADOR_SERIAL (
        .clock  (clock                ),
        .zera_as(                     ),
        .zera_s (reset                ),
        .conta  (conta_serial         ),
        .Q      (s_valor_contador_serial),
        .fim    (s_fim_contador_serial),
        .meio   (                     )
    );

    mux_8x1_n #( .BITS(7) ) MUX_SERIAL (
        .D7     (7'b111_0011                    ),
        .D6     ({ 3'b000, s_distancia_unidade }),
        .D5     ({ 3'b000, s_distancia_dezena  }),
        .D4     ({ 3'b000, s_distancia_centena }),
        .D3     (7'b111_1100                    ),
        .D2     ({ 3'b000, s_angulo_unidade    }),
        .D1     ({ 3'b000, s_angulo_dezena     }),
        .D0     ({ 3'b000, s_angulo_centena    }),
        .SEL    (s_valor_contador_serial        ),
        .MUX_OUT(s_mux_serial_out               )
    );

    binary_to_ascii BIN2ASC (
        .binary_in(s_mux_serial_out),
        .ascii_out(s_medida_ascii)
    );

    tx_serial_7O1 serial (
        .clock          (clock            ),
        .reset          (reset            ),
        .partida        (transmitir       ),
        .dados_ascii    (s_medida_ascii   ),
        .saida_serial   (saida_serial     ), 
        .pronto         (s_fim_transmissao),
        .db_partida     (                 ),
        .db_saida_serial(db_saida_serial  ),
        .db_estado      (db_estado_serial ) 
    );

endmodule