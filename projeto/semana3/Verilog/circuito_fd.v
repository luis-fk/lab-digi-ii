module circuito_fd (
    input wire        clock,
    input wire        reset,
    input wire        entrada_serial,
    
    input wire        zeraUpdown,
    input wire        contaUpdown,
    input wire        contaIntervalo,
    input wire        zeraIntervalo,
    input wire        enableReg,

    //saidas
    output wire       perteceAoIntervalo,
    output wire       pesoMaxIgualZero,
    output wire       comando,
    output wire       pwm,
    output wire       fimContadorIntervalo,
    output wire       inicioPosicao,
    output wire       fimPosicao,
    output wire       fimRecepcao,


    output wire [47:0] valor_reg
);
    
    wire [7:0] dado;
    wire [55:0] reg_out;
    wire [7:0] valor;

    wire [15:0] pesoMin;
    wire [15:0] pesoMax;
    wire [15:0] pesoAtual;

    wire pesoAtualMenorPesoMax;
    wire pesoAtualIgualPesoMaxComparador1;

    wire pesoAtualMmaiorPesoMin;
    wire pesoAtualIgualPesoMaxComparador2;

    assign valor_reg = reg_out[47:0] ;

    rx_serial_8N1_nandland #(.CLKS_PER_BIT(434)) rx_serial_8N1_nandland 
    (
        .i_Clock(clock),
        .i_Rx_Serial(entrada_serial),
        .o_Rx_DV(fimRecepcao),
        .o_Rx_Byte(dado)
    );

    // Modulo ASCII2BinarioComando
    assign valor = dado - 8'h30;

    // Se der errado colocar um edge detector aqui na saida comando
    assign comando = (dado == 8'h23) ? 1'b1 : 1'b0; 


    //reg_out = {comando (8 bits), peso_min (16 bits), peso_max (16 bits), peso_atual (16 bits)}
    registrador_n #( .N(56) ) registrador_n 
    (
        .clock(clock),
        .clear(reset),
        .enable(enableReg),
        .D({reg_out[47:0], valor}), // data
        .Q(reg_out)
    );

    assign pesoMax = reg_out[55:40];
    assign pesoMin = reg_out[39:24];
    assign pesoAtual = reg_out[23:8];

    comparador_n #( .N(16) ) comparador_n1 
    (
        .A             (pesoMax), 
        .B             (pesoAtual),
        .aMenorB       (),
        .aIgualB       (pesoAtualIgualPesoMaxComparador1),
        .amaiorB       (pesoAtualMenorPesoMax)
    );

    comparador_n #( .N(16) ) comparador_n2
    (
        .A(pesoMin), 
        .B(pesoAtual),
        .aMenorB(pesoAtualMmaiorPesoMin),
        .aIgualB(pesoAtualIgualPesoMaxComparador2),
        .amaiorB()
    );

    assign perteceAoIntervalo = (pesoAtualMenorPesoMax | pesoAtualIgualPesoMaxComparador1) & (pesoAtualMmaiorPesoMin | pesoAtualIgualPesoMaxComparador2);

    comparador_n #( .N(16) ) comparador_n3
    (
        .A(pesoMax), 
        .B(16'b0),
        .aMenorB(),
        .aIgualB(pesoMaxIgualZero),
        .amaiorB()
    );

    wire [2:0] valorContadorUpdown;
    wire [2:0] muxPosicaoOut;

    assign inicioPosicao = (muxPosicaoOut == 3'b000) ? 1'b1 : 1'b0;
    assign fimPosicao    = (muxPosicaoOut == 3'b111) ? 1'b1 : 1'b0;    

    contador_updown #( .M(14), .N(3) ) UPDOWN (
        .clock      (clock              ),
        .zera_as    (1'b0               ),
        .zera_s     (zeraUpdown         ),
        .conta      (contaUpdown        ),
        //out
        .value      (valorContadorUpdown),
        .fim        (                   ),
        .meio       (                   )
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
        .SEL    (valorContadorUpdown),
        .MUX_OUT(muxPosicaoOut)
    );

    contador_m #( .M(5_000_000), .N(28) ) CONT_INTERVALO (
        .clock  (clock              ),
        .zera_as(                   ),
        .zera_s (zeraIntervalo      ),
        .conta  (contaIntervalo     ), 
        .Q      (                   ),
        .fim    (fimContadorIntervalo),
        .meio   (                   )
    );

    controle_servo_3 SERVO (
        .clock      (clock            ),
        .reset      (reset            ),
        .posicao    (muxPosicaoOut    ),
        .controle   (pwm              ),
        .db_reset   (                 ),
        .db_controle(                 ),
        .db_posicao (                 )
    );


endmodule