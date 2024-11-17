module circuito (
    input wire        clock,
    input wire        reset,
    input wire        abrir,
    input wire        entrada_serial,
    input wire        select_ucs,
    //saidas
    output wire       pwm,
    output wire       abrir_db,
    output wire       db_pertence_ao_intervalo,
    // displays
    output wire [6:0] hex0_out,
    output wire [6:0] hex1_out,
    output wire [6:0] hex2_out,
    output wire [6:0] hex3_out,
    output wire [6:0] hex4_out,
    output wire [6:0] hex5_out
);

    wire abrirComporta;
    wire inicioPosicao;
    wire fimPosicao;
    wire fimContadorIntervalo;
    wire contaIntervalo;
    wire contaUpdown;
    wire zeraUpdown;
    wire zeraIntervalo;
    wire comando;
    wire fimRecepcao;
    wire enableReg;
    wire perteceAoIntervalo;
    wire abrirComportaUc;

    wire [2:0] muxPosicaoOut;

    wire [3:0] uc_comporta;
    wire [3:0] uc_controle;

    wire [47:0] valor_reg;

    wire [3:0] hex0_in;
    wire [3:0] hex1_in;
    wire [3:0] hex2_in;
    wire [3:0] hex3_in;
    wire [3:0] hex4_in;
    wire [3:0] hex5_in;

    wire [3:0] pesoMax0;
    wire [3:0] pesoMax1;
    wire [3:0] pesoMin0;
    wire [3:0] pesoMin1;
    wire [3:0] pesoAtual0;
    wire [3:0] pesoAtual1;

    assign pesoMax1 = valor_reg[43:40];
    assign pesoMax0 = valor_reg[35:32];
    assign pesoMin1 = valor_reg[27:24];
    assign pesoMin0 = valor_reg[19:16];
    assign pesoAtual1 = valor_reg[11:8];
    assign pesoAtual0 = valor_reg[3:0];

    assign hex5_in = select_ucs ? 4'b0 : pesoMax1;
    assign hex4_in = select_ucs ? 4'b0 : pesoMax0;

    assign hex3_in = select_ucs ? 4'b0 : pesoMin1;
    assign hex2_in = select_ucs ? {1'b0, muxPosicaoOut} : pesoMin0;

    assign hex1_in = select_ucs ? uc_controle : pesoAtual1;
    assign hex0_in = select_ucs ? uc_comporta  : pesoAtual0;

    circuito_fd FD (
        .clock                  (clock                  ),
        .reset                  (reset                  ),
        .entrada_serial         (entrada_serial         ),
        .zeraUpdown             (zeraUpdown             ),
        .contaUpdown            (contaUpdown            ),
        .contaIntervalo         (contaIntervalo         ),
        .enableReg              (enableReg              ),
        .zeraIntervalo          (zeraIntervalo          ),
        .perteceAoIntervalo     (perteceAoIntervalo     ),
        .pesoMaxIgualZero       (pesoMaxIgualZero       ),
        .comando                (comando                ),
        .pwm                    (pwm                    ),
        .fimContadorIntervalo   (fimContadorIntervalo   ),
        .inicioPosicao          (inicioPosicao          ),
        .fimPosicao             (fimPosicao             ),
        .fimRecepcao            (fimRecepcao            ),
        .muxPosicaoOut          (muxPosicaoOut          ),
        .valor_reg              (valor_reg              )
    );

    assign abrir_db = abrir;

    assign abrirComporta = perteceAoIntervalo | abrirComportaUc;
    
    assign db_pertence_ao_intervalo = perteceAoIntervalo | abrirComportaUc;

    circuito_uc UC (
        .clock              (clock              ),
        .reset              (reset              ),
        .fimRecepcao        (fimRecepcao        ),
        .comando            (comando            ),
        .abrir              (abrirComportaUc    ),
        .enableReg          (enableReg          ),
        .dbEstado           (uc_controle        )
    );
    
    comporta_uc UC_comporta (
        .clock                  (clock                  ),
        .reset                  (reset                  ),
        .abrirComporta          (abrir | abrirComporta  ),
        .inicioPosicao          (inicioPosicao          ),
        .fimPosicao             (fimPosicao             ),
        .fimContadorIntervalo   (fimContadorIntervalo   ),
        .pesoMaxIgualZero       (pesoMaxIgualZero       ),
        .comando                (comando                ),
        .contaIntervalo         (contaIntervalo         ),
        .contaUpdown            (contaUpdown            ),
        .zeraIntervalo          (zeraIntervalo          ),
        .zeraUpdown             (zeraUpdown             ),
        .dbEstado               (uc_comporta            )
    );

    hexa7seg hex0 (
        .hexa(hex0_in),
        .display(hex0_out)
    );

    hexa7seg hex1 (
        .hexa(hex1_in),
        .display(hex1_out)
    );

    hexa7seg hex2 (
        .hexa(hex2_in),
        .display(hex2_out)
    );

    hexa7seg hex3 (
        .hexa(hex3_in),
        .display(hex3_out)
    );

    hexa7seg hex4 (
        .hexa(hex4_in),
        .display(hex4_out)
    );

    hexa7seg hex5 (
        .hexa(hex5_in),
        .display(hex5_out)
    );

endmodule