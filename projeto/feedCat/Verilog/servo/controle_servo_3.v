module controle_servo_3 (
    input        clock,
    input        reset,
    input  [2:0] posicao,
	output       controle,
	output       db_reset,
	output       db_controle,
    output [2:0] db_posicao
);

	wire [2:0] s_posicao;
	wire s_controle;
	wire s_reset;

	circuito_pwm pwm (
		.clock(clock),
		.reset(s_reset),
		.largura(s_posicao),
		.pwm(s_controle)
	);

	assign s_posicao = posicao;


	assign controle = s_controle;
	assign s_reset = reset;

	assign db_reset = s_reset;
	assign db_controle = controle;
	assign db_posicao = posicao;

endmodule