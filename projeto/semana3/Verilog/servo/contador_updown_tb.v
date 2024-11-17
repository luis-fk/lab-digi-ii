`timescale 1ns/1ns

module contador_updown_tb;

    reg clock;
    reg zeraUpdown;
    reg contaUpdown;
    wire [2:0] valorContadorUpdown;


    contador_updown #( .M(14), .N(3) ) UPDOWN (
        .clock      (clock              ),
        .zera_as    (1'b0               ),
        .zera_s     (zeraUpdown         ),
        .conta      (contaUpdown        ),
        //out
        .value      (valorContadorUpdown),
        .fim        (                   ),
        .meio       (                   )
    );

    always #5 clock = ~clock;

    initial begin
        $dumpvars(5, contador_updown_tb);
        $dumpfile("wave.vcd");

        clock = 0;
        zeraUpdown = 0;
        contaUpdown = 0;
        #10 zeraUpdown = 1;
        #10 zeraUpdown = 0;
        #10 contaUpdown = 1;
        #200 
        $finish;
    end

endmodule