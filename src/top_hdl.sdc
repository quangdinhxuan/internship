//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.9.03 (64-bit) 
//Created Time: 2024-06-09 23:40:14
//create_clock -name tck -period 37.037 -waveform {0 18.518} [get_ports {tck_pad_i}]
create_clock -name gclk -period 37.037 -waveform {0 18.518} [get_ports {gclk}]