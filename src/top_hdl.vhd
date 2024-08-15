library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_hdl is
    Port (
        gclk       : in  STD_LOGIC;  -- 27MHz
        gresetn    : in  STD_LOGIC;
        key        : in  STD_LOGIC;
        led        : out STD_LOGIC
    );
end top_hdl;

architecture Behavioral of top_hdl is

    -- Constants
    constant KEY_PRESS   : STD_LOGIC := '0'; 
    constant KEY_RELEASE : STD_LOGIC := not KEY_PRESS;
    constant LED_ON      : STD_LOGIC := '1';
    constant LED_OFF     : STD_LOGIC := not LED_ON;

    -- Signals
    signal flag_press   : STD_LOGIC;
    signal flag_release : STD_LOGIC;
    signal led_reg      : STD_LOGIC := LED_ON; -- Internal register to hold the LED state

    -- Clock for Gowin_OSC instance
    signal clk_osc : STD_LOGIC;

begin

    -- Instance of drv_key
    drv_key_inst: entity work.drv_key
        generic map (
            FILTER_TIME => 2700000 * 5,  -- 50ms
            KEY_PRESS   => KEY_PRESS
        )
        port map (
            clk         => gclk,
            rst_n       => gresetn,
            key         => key,
            flag_press  => flag_press,
            flag_release => flag_release
        );

    -- Process for LED control
    process (gclk)
    begin
        if rising_edge(gclk) then
            if gresetn = '0' then
                led_reg <= LED_ON;
            elsif flag_press = '1' then
                led_reg <= not led_reg;
            end if;
        end if;
    end process;

    -- Assign internal LED register to output
    led <= led_reg;

    -- Instance of Gowin_OSC
    Gowin_OSC_inst: entity work.Gowin_OSC
        port map (
            oscout => clk_osc,
            oscen  => '1'
        );

end Behavioral;
