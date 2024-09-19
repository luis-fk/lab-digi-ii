module binary_to_ascii (
    input [6:0] binary_in,  
    output reg [6:0] ascii_out  
);

always @(*) begin
    ascii_out = 7'h30 + binary_in;
end

endmodule