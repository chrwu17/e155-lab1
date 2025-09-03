// SystemVerilog LED Blinker for Lattice UP5K FPGA
// Uses internal 48MHz oscillator to blink LED at 2Hz
// Takes advantage of SystemVerilog features like logic, always_ff, etc.

module led_blinker_up5k (
    output logic led
);

    // Internal oscillator clock signal
    logic clk_48mhz;
    
    // Counter for frequency division
    // Need to divide 48MHz by 12M to get 4Hz toggle (2Hz blink)
    // 12M = 12_000_000 requires 24 bits (2^24 = 16,777,216)
    localparam int COUNTER_MAX = 12_000_000 - 1;
    logic [23:0] counter;
    
    // LED output register
    logic led_reg;
    
    // Instantiate the internal high-frequency oscillator
    // SB_HFOSC is the Lattice UP5K primitive for the internal oscillator
    SB_HFOSC #(
        .CLKHF_DIV("0b00")  // 48MHz (divide by 1)
    ) hfosc_inst (
        .CLKHFPU(1'b1),     // Power up the oscillator
        .CLKHFEN(1'b1),     // Enable the oscillator
        .CLKHF(clk_48mhz)   // 48MHz clock output
    );
    
    // Counter logic using SystemVerilog always_ff
    always_ff @(posedge clk_48mhz) begin
        if (counter >= COUNTER_MAX) begin
            counter <= '0;
            led_reg <= ~led_reg;  // Toggle LED every 0.25 seconds
        end else begin
            counter <= counter + 1'b1;
        end
    end
    
    // Assign LED output
    assign led = led_reg;

endmodule