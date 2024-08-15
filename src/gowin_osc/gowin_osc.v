//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.9.03 (64-bit)
//Part Number: GW1NSR-LV4CQN48PC7/I6
//Device: GW1NSR-4C
//Created Time: Wed May 29 17:22:48 2024

module Gowin_OSC (oscout, oscen);

output oscout;
input oscen;

OSCZ osc_inst (
    .OSCOUT(oscout),
    .OSCEN(oscen)
);

defparam osc_inst.FREQ_DIV = 2;
defparam osc_inst.S_RATE = "FAST";

endmodule //Gowin_OSC
