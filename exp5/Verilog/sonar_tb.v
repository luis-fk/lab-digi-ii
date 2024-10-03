`timescale 1ns/100ps

module sensor_tb;

    // Declaração de sinais
    reg         clock_in = 0;
    reg         reset_in = 0;
    reg         ligar_in = 0;
    reg         echo_in  = 0;
    reg         display_mode_in = 0;
 
    wire        trigger_out;
    wire [6:0]  hex0_out;
    wire [6:0]  hex1_out;
    wire [6:0]  hex2_out;
    wire [6:0]  hex3_out;
    wire [6:0]  hex4_out;
    wire [6:0]  hex5_out;
    wire        db_trigger_out;
    wire        db_fim_transmissao_out;
    wire        db_fim_posicao_out;

    wire s_pmw_out;
    wire s_saida_serial_out;
    wire s_fim_posicao_out;

    // Componente a ser testado (Device Under Test -- DUT)
    sonar UUT (
        .clock       (clock_in),
        .reset       (reset_in),
        .ligar       (ligar_in),
        .echo        (echo_in ),
        .display_mode(display_mode_in),
        //saidas
        .trigger     (trigger_out),
        .pwm         (s_pmw_out),
        .saida_serial(s_saida_serial_out),
        .fim_posicao (s_fim_posicao_out),
        //hex
        .hex0        (hex0_out),
        .hex1        (hex1_out),
        .hex2        (hex2_out),
        .hex3        (hex3_out),
        .hex4        (hex4_out),
        .hex5        (hex5_out),
        //dbs
        .db_fim_transmissao(db_fim_transmissao_out),
        .db_fim_posicao    (db_fim_posicao_out),
        .db_saida_serial   (db_saida_serial_out)
    );

    // Configurações do clock
    parameter clockPeriod = 20; // clock de 50MHz
    // Gerador de clock
    always #(clockPeriod/2) clock_in = ~clock_in;

    // Array de casos de teste (estrutura equivalente em Verilog)
    reg [31:0] casos_teste [0:10]; // Usando 32 bits para acomodar o tempo
    integer caso;

    // Largura do pulso
    reg [31:0] larguraPulso; // Usando 32 bits para acomodar tempos maiores

    // Geração dos sinais de entrada (estímulos)
    initial begin
        // $display("Inicio das simulacoes");
        $dumpfile("wave.vcd");
        $dumpvars(5, sensor_tb);
        
        // Inicialização do array de casos de teste (mantendo os mesmos valores)
        // Inicialização do array de casos de teste
        casos_teste[0] = 5899;    // 5899us (100,29cm) truncar para 100cm
        casos_teste[1] = 4399;    // 4399us (74,79cm) arredondar para 75cm
        casos_teste[2] = 1200;   // 10000us (170,01cm) arredondar para 170cm
        casos_teste[3] = 2000;   // 10000us (170,01cm) arredondar para 170cm
        casos_teste[4] = 1000;   // 10000us (170,01cm) arredondar para 170cm
        casos_teste[5] = 500;   // 10000us (170,01cm) arredondar para 170cm
        casos_teste[6] = 1500;   // 10000us (170,01cm) arredondar para 170cm
        casos_teste[7] = 700;   // 10000us (170,01cm) arredondar para 170cm
        casos_teste[8] = 800;   // 10000us (170,01cm) arredondar para 170cm
        casos_teste[9] = 900;   // 10000us (170,01cm) arredondar para 170cm
        casos_teste[10] = 1100;   // 10000us (170,01cm) arredondar para 170cm


        // Valores iniciais
        ligar_in = 0;
        echo_in  = 0;

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
        for (caso = 0; caso < 11; caso = caso + 1) begin
            // 1) Determina a largura do pulso echo e o valor da medida
            $display("Caso de teste %0d: %0dus", caso, casos_teste[caso]);
            larguraPulso = casos_teste[caso]*1000; // 1us=1000

            // 2) Envia pulso medir
            @(negedge clock_in);
            ligar_in = 1;
            #(5*clockPeriod);
            ligar_in = 0;

            // 3) Espera por 20us (tempo entre trigger e echo)
            #(20_000); // 20 us

            // 4) Gera pulso de echo
            echo_in = 1;
            #(larguraPulso);
            echo_in = 0;

            // 5) Espera final da medida
            #(200_000_000)
            $display("Fim do caso %0d", caso);

            // 6) Espera entre casos de teste
            #(1000); // 1 us
        end

        // Fim da simulação
        $display("Fim das simulacoes");
        caso = 99; 
        $finish;
    end

endmodule