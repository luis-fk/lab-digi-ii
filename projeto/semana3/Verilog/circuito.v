module circuito (
    input wire        clock,
    input wire        reset,
    input wire        entrada_serial,
    output wire [6:0] hexa
);
    wire [7:0] dado;
    wire [7:0] valor;

    wire enable_reg;
	 wire [7:0] reg_out;

    // 8N1 - bounds = 115200
    rx_serial_8N1_nandland #(.CLKS_PER_BIT(434)) rx_serial_8N1_nandland 
    (
        .i_Clock(clock),
        .i_Rx_Serial(entrada_serial),
        .o_Rx_DV(enable_reg),
        .o_Rx_Byte(dado)
    );

    registrador_n #( .N(8) ) registrador_n 
    (
        .clock(clock),
        .clear(reset),
        .enable(enable_reg),
        .D(dado), // in
        .Q(reg_out)  // out
    );

    assign valor = reg_out - 7'h30;

    hexa7seg hexa7seg
    (
        .hexa(valor[3:0]),
        .display(hexa)
    );

endmodule