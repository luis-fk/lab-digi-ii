module circuito (
    input wire        clock,
    input wire        reset,
    input wire        dadoSerial,
    output wire       TODO
);

    circuitoFd fluxoDeDados (
        .clock(clock),
        .reset(reset),
        .dadoSerial(dadoSerial),
    );

    circuitoUc unidadeDeControle (
        .clock(clock),
        .reset(reset),
        .comando(),
        .zera(),
        .abrir(),
        .enableReg()
    );

    // Displays para medida (4 dígitos BCD)
    hexa7seg H0 (
        .hexa   (), 
        .display()
    );


endmodule