// lab1_cw.sv
// Christian Wu
// chrwu@g.hmc.edu
// 08/31/25

// This module takes in a 4-bit input 's', using the dip switches on the motherboard,  
// and controls a 3-bit LED output led[2:0], which are the SMD LEDs on the motherboard, 
// and a 7-segment display output seg[6:0].
module lab1_cw (
    input logic [3:0] s,
    output logic [2:0] led,
    output logic [6:0] seg
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

    // 7-Segment Display Logic
    always_comb begin
        case (s)
            4'h0: seg = 7'b1000000; // 0
            4'h1: seg = 7'b1111001; // 1
            4'h2: seg = 7'b0100100; // 2
            4'h3: seg = 7'b0110000; // 3
            4'h4: seg = 7'b0011001; // 4
            4'h5: seg = 7'b0010010; // 5
            4'h6: seg = 7'b0000010; // 6
            4'h7: seg = 7'b1111000; // 7
            4'h8: seg = 7'b0000000; // 8
            4'h9: seg = 7'b0010000; // 9
            4'hA: seg = 7'b0001000; // A
            4'hB: seg = 7'b0000011; // b
            4'hC: seg = 7'b1000110; // C
            4'hD: seg = 7'b0100001; // d
            4'hE: seg = 7'b0000110; // E
            4'hF: seg = 7'b0001110; // F
            default: seg = 7'b1111111; // Off
        endcase
    end

endmodule