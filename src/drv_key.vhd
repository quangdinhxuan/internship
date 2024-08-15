library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity drv_key is
    generic (
        FILTER_TIME : integer := 2700000;
        KEY_PRESS   : std_logic := '0'
    );
    Port (
        clk         : in  std_logic;
        rst_n       : in  std_logic;
        key         : in  std_logic;
        flag_press  : out std_logic;
        flag_release: out std_logic
    );
end drv_key;

architecture Behavioral of drv_key is

    constant KEY_RELEASE : std_logic := not KEY_PRESS;
    constant S0_IDLE     : integer := 0;
    constant S1_KEY_PRESS: integer := 1;
    constant S2_KEY_RELEASE: integer := 2;

    signal cnt_press   : integer := 0;
    signal cnt_release : integer := 0;
    signal key_sreg    : std_logic_vector(4 downto 0) := (others => KEY_RELEASE);
    signal fsm         : integer := S0_IDLE;
    signal en          : std_logic := '0';

    signal key_is_press   : std_logic;
    signal key_is_release : std_logic;
    signal key_is_shake   : std_logic;

begin

    key_is_press   <= '1' when (key_sreg(4 downto 1) = (others => KEY_PRESS)) else '0';
    key_is_release <= '1' when (key_sreg(4 downto 1) = (others => KEY_RELEASE)) else '0';
    key_is_shake   <= '1' when not (key_is_press = '1' or key_is_release = '1') else '0';

    flag_press   <= '1' when (fsm = S1_KEY_PRESS) else '0';
    flag_release <= '1' when (fsm = S2_KEY_RELEASE) else '0';

    -- Key edge capture shift register
    process (clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                key_sreg <= (others => KEY_RELEASE);
            else
                key_sreg <= key_sreg(3 downto 0) & key;
            end if;
        end if;
    end process;

    -- FSM process
    process (clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                fsm <= S0_IDLE;
                cnt_press <= 0;
                cnt_release <= 0;
                en <= '0';
            else
                case fsm is
                    when S0_IDLE =>
                        if key_is_shake = '1' then
                            cnt_press <= 0;
                            cnt_release <= 0;
                            en <= '1';
                        elsif key_is_press = '1' and en = '1' then
                            if cnt_press < FILTER_TIME then
                                cnt_press <= cnt_press + 1;
                            else
                                cnt_press <= 0;
                                fsm <= S1_KEY_PRESS;
                            end if;
                        elsif key_is_release = '1' and en = '1' then
                            if cnt_release < FILTER_TIME then
                                cnt_release <= cnt_release + 1;
                            else
                                cnt_release <= 0;
                                fsm <= S2_KEY_RELEASE;
                            end if;
                        else
                            fsm <= S0_IDLE;
                            cnt_press <= 0;
                            cnt_release <= 0;
                            en <= '0';
                        end if;
                    when S1_KEY_PRESS =>
                        fsm <= S0_IDLE;
                        en <= '0';
                    when S2_KEY_RELEASE =>
                        fsm <= S0_IDLE;
                        en <= '0';
                    when others =>
                        fsm <= S0_IDLE;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
