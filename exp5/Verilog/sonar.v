/* --------------------------------------------------------------------------
 *  Arquivo   : exp3_sensor.v
 * --------------------------------------------------------------------------
 *  Descricao : circuito de teste do componente interface_hcsr04.v
 *              inclui componentes para dispositivos externos
 *              detector de borda e codificadores de displays de 7 segmentos
 *
 *              usar para sintetizar projeto no Intel Quartus Prime
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */
 
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
    
    assign db_saida_serial = saida_serial;
    assign medida = s_medida;

    modulo_controle INT2 (
        .clock      (clock  ),
        .reset      (reset  ),
        .posicao    (posicao),
	    .controle   (controle),
        .db_controle()  
    );
wire s_conta_updown;
wire s_reset_updown;
    sonar_fd exp5_fd(
        .clock                  (clock),
        .reset                  (s_zera),
        .medir                  (s_medir_distancia),
        .echo                   (echo),
        .display_mode           (display_mode),
        .transmitir             (s_transmitir),
        .conta_updown           (s_conta_updown),
        .reset_updown           (s_reset_updown),
        .trigger                (s_trigger),
        .pwm                    (pwm),
        .fim_distancia          (),
        .fim_transmissao        (s_fim_transmissao),
        .fim_contador_serial    (),
        .fim_contador_intervalo (),
        .saida_serial           (saida_serial),
        .medida                 (s_medida)
        );
wire s_fim_distancia;
    sonar_uc exp5 uc(
        .clock                 (clock),
        .reset                 (reset),
        .ligar                 (s_ligar),
        .fim_medida            (fim_medicao), 
        .fim_transmissao       (s_fim_transmissao), 
        .fim_contador_serial   (),
        .fim_contador_intervalo(),
        .zera                  (),
        .medir_distancia       (),
        .transmitir            (),
        .conta_serial          (),
        .conta_updown          (s_conta_updown),
        .conta_intervalo       (),
        .reset_updown          (s_reset_updown),
        .pronto                (),
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