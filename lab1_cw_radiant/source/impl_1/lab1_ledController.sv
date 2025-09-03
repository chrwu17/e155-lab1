// lab1_ledController.sv
// Christian Wu
// chrwu@g.hmc.edu
// 08/31/25

// This module takes in a 4-bit input 's', using the dip switches on the motherboard,
// and controls a 3-bit LED output led[2:0], which are the SMD LEDs on the motherboard.

module lab1_ledController (
    input logic [3:0] s,
    output logic [2:0] led
);

// LED Logic for led[0] and led[1]
    xor led0_logic(led[0], s[0], s[1]);
    and led1_logic(led[1], s[2], s[3]);

    // LED Logic for led[2] to blink at 2.4 Hz
    logic int_osc;
	logic led_state = 0;
	logic [24:0] counter = 0;
	
	// Internal high-speed oscillator
	HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
	// Simple clock divider
	always_ff @(posedge int_osc)
		begin
			counter <= counter + 1;
            if (counter == 10_000_000) begin // Adjust this value for 2.4 Hz
                led_state <= ~led_state;
                counter <= 0;
            end
		end
    //assign led[2] to blink state    
    assign led[2] = led_state;

endmodule