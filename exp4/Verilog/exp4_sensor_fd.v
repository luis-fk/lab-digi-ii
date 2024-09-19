/* --------------------------------------------------------------------------
 *  Arquivo   : exp3_sensor.v
 * --------------------------------------------------------------------------
 *  Descricao : circuito de teste do componente interface_hcsr04.v
 *              inclui componentes para dispositivos externos
 *              detector de borda e codificadores de displays de 7 segmentos
 *
 *              usar para sintetizar projeto no Intel Quartus Prime
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */
 
module exp4_sensor_fd (
    input wire         clock,
    input wire         reset,
    input wire         medir,
    input wire         echo,
    output wire        trigger,
    output wire [11:0] medida,
    output wire        pronto,
    output wire [3:0]  estado

);

interface_hcsr04 INT (
    .clock    (clock  ),
    .reset    (reset  ),
    .medir    (medir  ),
    .echo     (echo   ),
    .trigger  (trigger),
    .medida   (medida ),
    .pronto   (pronto ),
    .db_estado(estado )
);

tx_serial_7O1 serial (
    clock           ,
    reset           ,
    partida         , // entradas
    dados_ascii     ,
    saida_serial    , // saidas
    pronto          ,
    db_clock        , // saidas de depuracao
    db_tick         ,
    db_partida      ,
    db_saida_serial ,
    db_estado 
);
    
endmodule