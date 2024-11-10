module comparador_n #(parameter N=24)
    (
    input [N-1:0] A,
    input [N-1:0] B,
    output wire aMenorB,
    output wire aIgualB,
    output wire amaiorB
    );

    assign aMenorB = (A > B) ? 1'b1 : 1'b0;
    assign aIgualB = (A <= B) ? 1'b1 : 1'b0;
    assign amaiorB = (A > B) ? 1'b1 : 1'b0;

endmodule