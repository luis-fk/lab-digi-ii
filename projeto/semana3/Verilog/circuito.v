module circuito (
    input wire        clock,
    input wire        reset,
    input wire        entrada_serial,
);


    circuito_fd FD (
        .clock(clock),
        .reset(reset),
        .entrada_serial(entrada_serial),
    );

    circuito_uc UC (
        .clock(clock),
        .reset(reset),
    );

endmodule