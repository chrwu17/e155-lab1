// lab1_ledController_testbench.sv
// Christian Wu
// chrwu@g.hmc.edu
// 08/31/25

// This is a testbench to test my lab 1 lab controller module (lab1_ledController.sv).
// It tests the LED logic based on different 4-bit inputs.

`timescale 1ns/1ns
`default_nettype none
`define N_TV 16

module lab1_ledController_testbench();

logic clk;
logic reset;

logic [3:0] s;
logic [2:0] led;
logic [1:0] led_expected;
logic [31:0] vectornum, errors;
logic [5:0] testvectors[10000:0]; // s[3:0]_led[1:0]

// Instantiate the device under test (DUT)
lab1_ledController dut (.s(s), .led(led));

// generate clock
always begin
    clk = 1; #5; clk = 0; #5;
end

// Load test vectors, and pulse reset
initial begin
    $readmemb("lab1_ledController_testvectors.tv", testvectors, 0, `N_TV-1);
    vectornum = 0; errors = 0;
    reset = 1; #27; reset = 0;
end

// Apply test vectors at rising edge of clock
always @(posedge clk) begin
    #1; {s, led_expected} = testvectors[vectornum];
end
initial
begin
    // Create dumpfile for signals
    $dumpfile("lab1_ledController_testbench.vcd");
    $dumpvars(0, lab1_ledController_testbench);
end

// Check results on falling edge of clock
always @(negedge clk) begin
    if (~reset) begin
        if (led[1:0] != led_expected) begin
            $display("Error at vector %0d: s=%b, led=%b (expected %b)", 
                     vectornum, s, led[1:0], led_expected);
            errors = errors + 1;
        end
        vectornum = vectornum + 1;
        if (vectornum >= `N_TV) begin
            $display("%0d tests completed with %0d errors", vectornum, errors);
            $stop;
        end
    end
end
endmodule

