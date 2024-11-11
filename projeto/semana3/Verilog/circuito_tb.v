`timescale 1ns/1ns

module circuito_tb;

    // Declaração de sinais
    reg         clock_in = 0;
    reg         reset_in = 0; 
    reg [7:0]   dado_serial;
    reg comecar_transmissao = 0;

    wire        entrada_serial_in;
    wire pwm_out;

    wire transmissao_feita_out;

    // Componente a ser testado (Device Under Test -- DUT)

    circuito uut (
    .clock(clock_in),
    .reset(reset_in),
    .entrada_serial(entrada_serial_in),
    .pwm(pwm_out)
);

    tx_serial_8N1_nandland #(.CLKS_PER_BIT(434)) tx_serial_8N1_nandland 
    (
        .i_Clock(clock_in),
        .i_Tx_DV(comecar_transmissao),
        .i_Tx_Byte(dado_serial), 
        .o_Tx_Active(),
        .o_Tx_Serial(entrada_serial_in),
        .o_Tx_Done(transmissao_feita_out)
    );

    // Configurações do clock
    parameter clockPeriod = 20; // clock de 50MHz
    // Gerador de clock
    always #(clockPeriod/2) clock_in = ~clock_in;

    // Array de casos de teste (estrutura equivalente em Verilog)
    reg [7:0] casos_teste [0:10]; // Usando 32 bits para acomodar o tempo
    integer caso;

    // Geração dos sinais de entrada (estímulos)
    initial begin
        // $display("Inicio das simulacoes");
        $dumpfile("wave.vcd");
        $dumpvars(5, circuito_tb);
        
        // Inicialização do array de casos de teste (mantendo os mesmos valores)
        // Inicialização do array de casos de teste
        // peso min = 10
        //peso max = 20

        // peso atual = 15

        casos_teste[0] = 8'h30; // comando
        casos_teste[1] = 8'h31; // 1
        casos_teste[2] = 8'h30; // 0
        casos_teste[3] = 8'h32; // 2
        casos_teste[4] = 8'h30; // 0
        casos_teste[5] = 8'h31; // 1
        casos_teste[6] = 8'h35; // 5
        casos_teste[7] = 8;
        casos_teste[8] = 9;

        // Valores iniciais

        // Reset
        caso = 0; 
        #(2*clockPeriod);
        reset_in = 1;
        #(200);
        reset_in = 0;
        @(negedge clock_in);

        // Espera de 1us
        #(1000); // 1 us

        // Loop pelos casos de teste
        for (caso = 0; caso < 7; caso = caso + 1) begin
            // 1) Determina a largura do pulso echo e o valor da medida
            $display("Caso de teste %0d: %0dus", caso, casos_teste[caso]);

            // 2) Envia o dado serialmente

            dado_serial = casos_teste[caso];
            comecar_transmissao = 1;
            #(clockPeriod);
            comecar_transmissao = 0;

            // espera até a transmissão ser concluida
            wait (transmissao_feita_out == 1'b1);

            $display("Fim do caso %0d", caso);

            // 6) Espera entre casos de teste
            #(1000); // 1 us
        end

        #(10000000*clockPeriod); // 1 us

        // Fim da simulação
        $display("Fim das simulacoes");
        caso = 99; 
        $finish;
    end

endmodule