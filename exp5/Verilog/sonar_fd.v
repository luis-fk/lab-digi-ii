 module sonar_fd (
    input wire         clock,
    input wire         reset,
    input wire         medir,
    input wire         echo,
    input wire         display_mode,
    input wire         transmitir,
    input wire         conta,
    input wire         conta32,
    input wire         reset_contador32,
    output wire        trigger,
    output wire        pwm,
    output wire        fim_medicao,
    output wire        fim_transmissao,
    output wire [3:0]  db_estado,
    output wire        saida_serial,
    output wire [11:0] medida,
    output wire        fim_contador32
);

wire        s_fim_transmissao;
wire        s_sensor_pronto;
wire        s_serial_pronto;
wire        s_fim_medicao;
wire        s_fim_contador_2seg;
wire        s_contador_updown;
wire [11:0] s_angulo;
wire [11:0] s_distancia;
wire [11:0] s_medida;
wire [6:0]  s_medida_ascii;
wire [6:0]  s_mux_serial_out;
wire [3:0]  s_mux_posicao_out;

assign fim_transmissao = s_fim_transmissao;
assign medida = s_medida;
assign fim_medicao = s_fim_medicao;


interface_hcsr04 INT (
    .clock    (clock        ),
    .reset    (reset        ),
    .medir    (medir        ),
    .echo     (echo         ),
    .trigger  (trigger      ),
    .medida   (s_distancia  ),
    .pronto   (s_fim_medicao),
    .db_estado( db_estado   )
);

controle_servo_3 SERVO (
    .clock      (clock),
    .reset      (reset),
    .posicao    (s_mux_posicao_out),
    .controle   (pwm),
    .db_reset   (),
    .db_controle(),
    .db_posicao ()
);

contadorg_updown_m #( .M(8), .N(3) ) UPDOWN (
    .clock  (clock),
    .zera_as(     ),
    .zera_s (reset),
    .conta  (s_fim_contador_2seg),
    .Q      (s_contador_updown  ),
    .inicio (     ),
    .fim    (     ),
    .meio   (     ),
    .direcao(     )
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
    .SEL    (s_contador_updown),
    .MUX_OUT(s_mux_posicao_out)
);

contador_m #( .M(200_000_000), .N(28) ) CONT_2SEG (
    .clock  (clock           ),
    .zera_as(),
    .zera_s (reset           ),
    .conta  (1'b1            ),
    .Q      (),
    .fim    (s_fim_contador_2seg),
    .meio   ()
);

mux_8x1_n #( .BITS(7) ) MUX_SERIAL (
    .D7     (7'b111_0011              ),
    .D6     ({ 3'b000, s_distancia[11:8]}),
    .D5     ({ 3'b000, s_distancia[7:4] }),
    .D4     ({ 3'b000, s_distancia[3:0] }),
    .D3     (7'b111_1100                 ),
    .D2     (),
    .D1     (),
    .D0     (),
    .SEL    (),
    .MUX_OUT(s_mux_serial_out         )
);

mux_2x1_n #( .BITS(12) ) MUX_DISPLAY (
    .D1     (s_angulo                 ),
    .D0     (s_distancia              ),
    .SEL    (display_mode             ),
    .MUX_OUT(s_medida                 )
);

binary_to_ascii BIN2ASC (
    .binary_in(s_mux_serial_out     ),
    .ascii_out(s_medida_ascii)
);

tx_serial_7O1 serial (
    .clock          (clock         ),
    .reset          (reset         ),
    .partida        (transmitir    ),
    .dados_ascii    (s_medida_ascii),
    .saida_serial   (saida_serial  ), 
    .pronto         (s_fim_transmissao),
    .db_clock       (), 
    .db_tick        (),
    .db_partida     (),
    .db_saida_serial(),
    .db_estado      () 
);
    
endmodule