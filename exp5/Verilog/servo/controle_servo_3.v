module controle_servo_3 (
    input        clock,
    input        reset,
    input  [2:0] posicao,
	output       controle,
	output       db_reset,
	output       db_controle,
    output [2:0] db_posicao
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
