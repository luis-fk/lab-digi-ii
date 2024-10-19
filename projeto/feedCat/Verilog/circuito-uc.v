module circuitoUc (
    input wire clock,
    input wire reset,
    input wire comando,
    output wire zera,
    output wire abrir,
    output wire enableReg,
);

    // Estados
    reg [2:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial       = 3'b000; //0
    parameter esperaDado    = 3'b001; //1
    parameter mudarPosicao  = 3'b010; //2
    parameter armazenarDado = 3'b011; //3

    // Estado
    always @(posedge clock, posedge reset) begin
        if (reset) 
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial             : Eprox = esperaDado;
            esperaDado          : Eprox = comando ? mudarPosicao : armazenarDado;
            mudarPosicao        : Eprox = esperaDado;
            armazenarDado       : Eprox = esperaDado;
            default             : Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        zera      = (Eatual == inicial )      ? 1'b1 : 1'b0;
        abrir     = (Eatual == mudarPosicao)  ? 1'b1 : 1'b0;
        enableReg = (Eatual == armazenarDado) ? 1'b1 : 1'b0;
        
        case (Eatual)
                inicial:       db_estado = 3'b000;
                esperaDado:    db_estado = 3'b001;
                mudarPosicao:  db_estado = 3'b010;
                armazenarDado: db_estado = 3'b011;
                default:       db_estado = 3'b000;
        endcase
    end

endmodule