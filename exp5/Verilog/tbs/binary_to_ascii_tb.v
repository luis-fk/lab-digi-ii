module binary_to_ascii_tb;

  reg [7:0] binary_in;
  wire [7:0] ascii_out;

  binary_to_ascii uut (
    .binary_in(binary_in),
    .ascii_out(ascii_out)
  );

  integer errors = 0;

  task Check;
      input [15:0] expect;
      if (expect[15:8] != expect[7:0]) begin
          $display("Got %b \nexpected %b", expect[15:7], expect[7:0]);
          errors = errors + 1;
      end
  endtask

  initial begin
    $display("Teste com 0b para 30h");
    binary_in = 8'b0000_0000;
    #10; 
    Check({ascii_out, 8'h30});

    $display("Teste com 9b para 39h");
    binary_in = 8'b0000_1001;
    #10; 
    Check({ascii_out, 8'h39});

    $display("Teste com 5b para 35h");
    binary_in = 8'b0000_0101;
    #10; 
    Check({ascii_out, 8'h35});

    $display("Testes completos. Erros %d", errors);
    $finish;
  end

endmodule