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
    // call led controller module
    lab1_ledController led_ctrl (.s(s), .led(led));
    // call seven segment display module
    lab1_sevenSegmentDisplay seg_ctrl (.s(s), .seg(seg));

endmodule