 module exp4_sensor_fd (
    input wire         clock,
    input wire         reset,
    input wire         medir,
    input wire         echo,
    input wire         transmitir,
    input wire         conta,
    input wire         conta32,
    input wire         reset_contador32,
    output wire        trigger,
    output wire        fim_contador,
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
wire        s_fim_contador;
wire [11:0] s_medida;
wire [6:0]  s_medida_ascii;
wire [1:0]  s_valor_contador;
wire [6:0]  s_mux_out;

assign fim_contador = s_fim_contador;
assign fim_transmissao = s_fim_transmissao;
assign medida = s_medida;
assign fim_medicao = s_fim_medicao;

interface_hcsr04 INT (
    .clock    (clock        ),
    .reset    (reset        ),
    .medir    (medir        ),
    .echo     (echo         ),
    .trigger  (trigger      ),
    .medida   (s_medida     ),
    .pronto   (s_fim_medicao),
    .db_estado( db_estado   )
);

contador_m #( .M(4), .N(2) ) CONT (
    .clock  (clock           ),
    .zera_as(),
    .zera_s (reset           ),
    .conta  (conta           ),
    .Q      (s_valor_contador),
    .fim    (s_fim_contador  ),
    .meio   ()
);

contador_m #( .M(100_000_000), .N(32) ) CONT32 (
    .clock  (clock           ),
    .zera_as(),
    .zera_s (reset_contador32),
    .conta  (conta32),
    .Q      (),
    .fim    (fim_contador_32),
    .meio   ()
);

mux_4x1_n #( .BITS(7) ) MUX (
    .D3     (7'b111_0011     ),
    .D2     ({ 3'b000, s_medida[3:0] }),
    .D1     ({ 3'b000, s_medida[7:4] }),
    .D0     ({ 3'b000, s_medida[11:8]}),
    .SEL    (s_valor_contador),
    .MUX_OUT(s_mux_out       )
);

binary_to_ascii BIN2ASC (
    .binary_in(s_mux_out     ),
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