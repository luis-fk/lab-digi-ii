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
 
module exp4_sensor (
    input wire        clock,
    input wire        reset,
    input wire        medir,
    input wire        echo,
    output wire [11:0] medida,
    output wire       trigger,
    output wire [6:0] hex0,
    output wire [6:0] hex1,
    output wire [6:0] hex2,
    output wire       pronto,
    output wire       saida_serial,
    output wire       db_medir,
    output wire       db_echo,
    output wire       db_trigger,
    output wire [6:0] db_estado
);

    // Sinais internos
    wire        s_medir  ;
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

    assign medida = s_medida;

    exp4_sensor_fd exp4_fd (
        .clock          (clock             ),
        .reset          (s_zera            ),
        .medir          (s_medir_distancia ),
        .echo           (echo              ),
        .transmitir     (s_transmitir      ),
        .conta          (s_conta           ),
        .trigger        (s_trigger         ),
        .fim_contador   (s_fim_contador    ),
        .fim_medicao    (fim_medicao       ),
        .fim_transmissao(s_fim_transmissao ),
        .db_estado      (),
        .saida_serial   (saida_serial      ),
        .medida         (s_medida          )
    );

    exp4_sensor_uc exp4_uc (
        .clock          (clock            ),
        .reset          (reset            ),
        .mensurar       (s_medir          ),
        .fim_medida     (fim_medicao      ),
        .fim_transmissao(s_fim_transmissao),
        .fim_contador   (s_fim_contador   ),
        .zera           (s_zera           ),
        .medir_distancia(s_medir_distancia),
        .transmitir     (s_transmitir     ),
        .conta          (s_conta          ),
        .pronto         (pronto           ),
        .db_estado      (s_estado         )
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
        .sinal(medir  ), 
        .pulso(s_medir)
    );

    // Sinais de saída
    assign trigger = s_trigger;

    // Sinal de depuração (estado da UC)
    hexa7seg H5 (
        .hexa   (s_estado ), 
        .display(db_estado)
    );

    assign db_echo    = echo;
    assign db_trigger = s_trigger;
    assign db_medir   = medir;

endmodule