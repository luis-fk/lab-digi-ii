module modulo_controle (
    input        clock,
    input        reset,
    input  [1:0] posicao,
	output       controle,
    output       db_controle
);

	circuito_pwm pwm (
		.clock(clock),
		.reset(reset),
		.largura(posicao),
		.pwm(controle)
	);
	
	wire wire_controle;
	assign wire_controle = controle;
	assign db_controle = wire_controle;


endmodule
