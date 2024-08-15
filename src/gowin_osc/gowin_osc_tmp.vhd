--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--Tool Version: V1.9.9.03 (64-bit)
--Part Number: GW1NSR-LV4CQN48PC7/I6
--Device: GW1NSR-4C
--Created Time: Thu Jun 27 16:10:05 2024

--Change the instance name and port connections to the signal names
----------Copy here to design--------

component Gowin_OSC
    port (
        oscout: out std_logic;
        oscen: in std_logic
    );
end component;

your_instance_name: Gowin_OSC
    port map (
        oscout => oscout,
        oscen => oscen
    );

----------Copy end-------------------
