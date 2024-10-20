 module circuitoFd (
    input wire clock,
    input wire reset,
    input wire dadoSerial,
    output wire [7:0] comando
);

wire [23:0] dadosRegistrados;
wire [7:0] pesoMaximo;
wire [7:0] pesoMinimo;
wire [7:0] pesoMedido;

uart_rx UART (
    .i_Clock(clock),
    .i_Rx_Serial(0),
    .o_Rx_DV(0),
    .o_Rx_Byte(0)
);

registrador_n #( .N(24) ) REGISTER (
    .clock(clock),
    .clear(0),
    .enable(0),
    .D(0),
    .Q(dadosRegistrados)
);

assign pesoMinimo = dadosRegistrados[23:16];
assign pesoMaximo = dadosRegistrados[15:8];
assign pesoMedido = dadosRegistrados[7:0];

assign peso

endmodule