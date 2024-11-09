module ascii_to_binary (
    input [7:0] asciiIn,  
    output [3:0] binaryOut  
);

    assign binaryOut = asciiIn - 7'h30;

endmodule