/* --------------------------------------------------------------------
 * Arquivo   : circuito_pwm_tb.v
 *
 * testbench basico para o componente circuito_pwm
 *
 * ------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     26/09/2021  1.0     Edson Midorikawa  criacao do componente VHDL
 *     17/08/2024  2.0     Edson Midorikawa  componente em Verilog
 * ------------------------------------------------------------------------
 */
  
`timescale 1ns/1ns

module circuito_pwm_tb;

    // Declaração de sinais para conectar o componente a ser testado (DUT)
    reg       clock_in   = 1;
    reg       reset_in   = 0;
    reg [2:0] largura_in = 3'b00;
    wire      pwm_out;

    // Configuração do clock
    parameter clockPeriod = 20; // T=20ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Componente a ser testado (Device Under Test -- DUT)
    circuito_pwm #(         
        .conf_periodo (1000000),  
        .largura_000  (35000),  
        .largura_001  (45700),  
        .largura_010  (56450),  
        .largura_011  (67150),   
        .largura_100  (77850),  
        .largura_101  (88550),   
        .largura_110  (99300),   
        .largura_111  (110000)   
    ) dut (
        .clock   (clock_in  ),
        .reset   (reset_in  ),
        .largura (largura_in),
        .pwm     (pwm_out   )
    );

    // Geração dos sinais de entrada (estímulos)
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, circuito_pwm_tb);

        $display("Inicio da simulacao\n... Simulacao ate 800 us. Aguarde o final da simulacao...");

        // Teste 1. resetar circuito
        caso = 1;
        // gera pulso de reset
        @(negedge clock_in);
        reset_in = 1;
        #(clockPeriod);
        reset_in = 0;
        // espera
        #(10*clockPeriod);

        // Teste 2. posicao=000
        caso = 2;
        @(negedge clock_in);
        largura_in = 3'b000;
        #(1_000_100*clockPeriod);

        // Teste 3. posicao=001
        caso = 3;
        @(negedge clock_in);
        largura_in = 3'b001; 
        #(1_000_100*clockPeriod); 

        // Teste 4. posicao=010
        caso = 4;
        @(negedge clock_in);
        largura_in = 3'b010; 
        #(1_000_100*clockPeriod);

        // Teste 5. posicao=011
        caso = 5;
        @(negedge clock_in);
        largura_in = 3'b011; 
        #(1_000_100*clockPeriod);

        caso = 6;
        @(negedge clock_in);
        largura_in = 3'b100; 
        #(1_000_100*clockPeriod);

        caso = 7;
        @(negedge clock_in);
        largura_in = 3'b101; 
        #(1_000_100*clockPeriod);

        caso = 8;
        @(negedge clock_in);
        largura_in = 3'b110; 
        #(1_000_100*clockPeriod);

        caso = 9;
        @(negedge clock_in);
        largura_in = 3'b111; 
        #(1_000_100*clockPeriod);

        // final dos casos de teste da simulacao
        caso = 99;
        #100;
        $display("Fim da simulacao");
        $finish;
    end

endmodule