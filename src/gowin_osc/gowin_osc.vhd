--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: IP file
--Tool Version: V1.9.9.03 (64-bit)
--Part Number: GW1NSR-LV4CQN48PC7/I6
--Device: GW1NSR-4C
--Created Time: Thu Jun 27 16:10:05 2024

library IEEE;
use IEEE.std_logic_1164.all;

entity Gowin_OSC is
    port (
        oscout: out std_logic;
        oscen: in std_logic
    );
end Gowin_OSC;

architecture Behavioral of Gowin_OSC is

    --component declaration
    component OSCZ
        generic (
            S_RATE: in STRING := "SLOW";
            FREQ_DIV: in integer := 100
        );
        port (
            OSCOUT: out std_logic;
            OSCEN: in std_logic
        );
    end component;

begin
    osc_inst: OSCZ
        generic map (
            S_RATE => "FAST",
            FREQ_DIV => 100
        )
        port map (
            OSCOUT => oscout,
            OSCEN => oscen
        );

end Behavioral; --Gowin_OSC
