module circuito (
    input wire        clock,
    input wire        reset,
    input wire        entrada_serial,

    output wire       pesoMaxIgualZero,
    output wire       pwm
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
        .fimRecepcao            (fimRecepcao            )
    );

    assign abrirComporta = perteceAoIntervalo | abrirComportaUc;


    circuito_uc UC (
        .clock              (clock              ),
        .reset              (reset              ),
        .fimRecepcao        (fimRecepcao        ),
        .comando            (comando            ),
        .pesoMaxIgualZero   (pesoMaxIgualZero   ),
        .abrir              (abrirComportaUc    ),
        .enableReg          (enableReg          ),
        .dbEstado           (                   )
    );

    comporta_uc UC_comporta (
        .clock                  (clock                  ),
        .reset                  (reset                  ),
        .abrirComporta          (abrirComporta          ),
        .inicioPosicao          (inicioPosicao          ),
        .fimPosicao             (fimPosicao             ),
        .fimContadorIntervalo   (fimContadorIntervalo   ),
        .contaIntervalo         (contaIntervalo         ),
        .contaUpdown            (contaUpdown            ),
        .zeraIntervalo          (zeraIntervalo          ),
        .zeraUpdown             (zeraUpdown             ),
        .dbEstado               (                       )
    );
    

endmodule