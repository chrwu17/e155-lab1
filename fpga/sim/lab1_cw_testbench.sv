// lab1_cw_testbench.sv
// Christian Wu
// chrwu@g.hmc.edu
// 08/31/25

// This is a testbench to test my lab 1 code (lab1_cw.sv).
// It tests the LED logic and 7-segment display logic based on different 4-bit inputs.

`timescale 1ns/1ns
`default_nettype none
`define N_TV 16

module lab1_cw_testbench();

logic clk;
logic reset;

logic [3:0] s;
logic [2:0] led;
logic [1:0] led_expected;
logic [6:0] seg, seg_expected;
logic [31:0] vectornum, errors;
logic [12:0] testvectors[10000:0]; // s[3:0]_led[1:0]_seg[6:0]

// Instantiate the device under test (DUT)
lab1_cw dut (.s(s), .led(led), .seg(seg));

// generate clock
always begin
    clk = 1; #5; clk = 0; #5;
end

// Load test vectors, and pulse reset
initial begin
    $readmemb("lab1_cw_testvectors.tv", testvectors, 0, `N_TV-1);
    vectornum = 0; errors = 0;
    reset = 1; #27; reset = 0;
end

// Apply test vectors at rising edge of clock
always @(posedge clk) begin
    #1; {s, led_expected, seg_expected} = testvectors[vectornum];
end
initial
begin
    // Create dumpfile for signals
    $dumpfile("lab1_cw_testbench.vcd");
    $dumpvars(0, lab1_cw_testbench);
end

// Check results on falling edge of clock
always @(negedge clk) begin
    if (~reset) begin
        if (led[1:0] != led_expected || seg != seg_expected) begin
            $display("Error at vector %0d: s=%b, led=%b (expected %b), seg=%b (expected %b)", 
                     vectornum, s, led[1:0], led_expected, seg, seg_expected);
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

