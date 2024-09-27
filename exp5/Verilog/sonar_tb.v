`timescale 1ns/1ns

module exp4_sensor_tb;

    // Declaração de sinais
    reg         clock_in = 0;
    reg         reset_in = 0;
    reg         medir_in = 0;
    reg         echo_in  = 0;
    wire [11:0] medida_out;  
    wire        trigger_out;
    wire [6:0]  hex0_out;
    wire [6:0]  hex1_out;
    wire [6:0]  hex2_out;
    wire        pronto_out;
    wire [6:0]  db_estado_out;
    wire        db_medir_out;
    wire        db_echo_out;
    wire        db_trigger_out;

    // Componente a ser testado (Device Under Test -- DUT)
    exp4_sensor dut (
        .clock      (clock_in      ),
        .reset      (reset_in      ),
        .medir      (medir_in      ),
        .echo       (echo_in       ),
        .medida     (medida_out    ), // Conectar o sinal de entrada
        .trigger    (trigger_out   ),
        .hex0       (hex0_out      ),
        .hex1       (hex1_out      ),
        .hex2       (hex2_out      ),
        .pronto     (pronto_out    ),
        .db_medir   (db_medir_out  ),
        .db_echo    (db_echo_out   ),
        .db_trigger (db_trigger_out),
        .db_estado  (db_estado_out )
    );

    // Configurações do clock
    parameter clockPeriod = 20; // clock de 50MHz
    // Gerador de clock
    always #(clockPeriod/2) clock_in = ~clock_in;

    // Array de casos de teste (estrutura equivalente em Verilog)
    reg [31:0] casos_teste [0:7]; // Usando 32 bits para acomodar o tempo
    integer caso;

    // Largura do pulso
    reg [31:0] larguraPulso; // Usando 32 bits para acomodar tempos maiores

    // Geração dos sinais de entrada (estímulos)
    initial begin
        // $display("Inicio das simulacoes");
        $dumpfile("wave.vcd");
        $dumpvars(5, exp4_sensor_tb);
        
        // Inicialização do array de casos de teste (mantendo os mesmos valores)
        // Inicialização do array de casos de teste
        casos_teste[0] = 5899;    // 5899us (100,29cm) truncar para 100cm
        casos_teste[1] = 4399;    // 4399us (74,79cm) arredondar para 75cm
        casos_teste[2] = 10000;   // 10000us (170,01cm) arredondar para 170cm

        // Valores iniciais
        medir_in = 0;
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
        for (caso = 0; caso < 2; caso = caso + 1) begin
            // 1) Determina a largura do pulso echo e o valor da medida
            $display("Caso de teste %0d: %0dus", caso, casos_teste[caso]);
            larguraPulso = casos_teste[caso]*1000; // 1us=1000

            // 2) Envia pulso medir
            @(negedge clock_in);
            medir_in = 1;
            #(5*clockPeriod);
            medir_in = 0;

            // 3) Espera por 20us (tempo entre trigger e echo)
            #(20_000); // 20 us

            // 4) Gera pulso de echo
            echo_in = 1;
            #(larguraPulso);
            echo_in = 0;

            // 5) Espera final da medida
            wait (pronto_out == 1'b1);
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