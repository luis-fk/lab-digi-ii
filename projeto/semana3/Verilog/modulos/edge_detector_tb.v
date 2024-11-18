`timescale 1ns/1ns

module edge_detector_tb;

// Testbench signals
reg clock;
reg reset;
reg sinal;
wire pulso;

// Instantiate the edge_detector module
edge_detector uut (
.clock(clock),
.reset(reset),
.sinal(sinal),
.pulso(pulso)
);

// Clock generation (50 MHz clock -> 20 ns period)
initial begin
clock = 1'b0;
forever #10 clock = ~clock; // Toggle clock every 10 ns
end

// Test stimulus
initial begin
// Initialize inputs
reset = 1'b1; // Hold reset active
sinal = 1'b0;

// Apply reset for 2 clock cycles
@(posedge clock); // Wait for a clock edge
#5 reset = 1'b0; // Release reset

// Test case 1: No transition in sinal
repeat(3) @(posedge clock); // Wait for 3 clock cycles

// Test case 2: Single rising edge on sinal
@(posedge clock); // Wait for a clock edge
#5 sinal = 1'b1; // Set sinal to high
@(posedge clock); // Wait for a clock edge
#5 sinal = 1'b0; // Set sinal back to low

// Test case 3: Multiple rising edges on sinal
@(posedge clock); // Wait for a clock edge
#5 sinal = 1'b1; // Set sinal to high
@(posedge clock); // Wait for a clock edge
#5 sinal = 1'b0; // Set sinal back to low
@(posedge clock); // Wait for a clock edge
#5 sinal = 1'b1; // Set sinal to high
@(posedge clock); // Wait for a clock edge
#5 sinal = 1'b0; // Set sinal back to low

// Test case 4: Assert reset during operation
@(posedge clock); // Wait for a clock edge
#5 reset = 1'b1; // Assert reset
@(posedge clock); // Wait for a clock edge
#5 reset = 1'b0; // Deassert reset

// Test case 5: No activity on sinal
repeat(5) @(posedge clock); // Wait for 5 clock cycles

// End simulation
$finish;
end

// Monitor signals
initial begin
    $dumpvars(5, edge_detector_tb);
    $dumpfile("wave.vcd");
$monitor("Time = %0t | Reset = %b | Sinal = %b | Pulso = %b",
$time, reset, sinal, pulso);
end

endmodule