library work;
use work.lowmc_pkg.all;
library ieee;
use ieee.std_logic_1164.all;

entity lowmc_mpc_hybrid is
  port(
    -- Clock and Reset
    signal Clk_CI   : in std_logic;
    signal Rst_RI   : in std_logic;
    -- Input signals
    --signal Plain_DI  : in std_logic_vector(N - 1 downto 0);
    --signal MK_DI     : in std_logic_vector(N - 1 downto 0);  --mask xor key
    -- signal Aux_DI    : in std_logic_vector(R * N - 1 downto 0);
    signal Tape_DI   : in R_N_2_ARR;
    signal Tape_last_DI   : in std_logic_vector(R * N - 1 downto 0);
    -- signal Aux_DI   : in std_logic_vector(R * N - 1 downto 0);
    signal Aux_SI    : in std_logic;
    --signal Sim_SI    : in std_logic;
    signal Lowmc_State_DI : in std_logic_vector(R * N - 1 downto 0);
    -- Output signals
    signal Finish_SO : out std_logic;
    signal Input_out : out std_logic_vector(N - 1 downto 0);  --mask
    signal Aux_out   : out std_logic_vector(R * N - 1 downto 0);
    --signal Cipher_DO : out std_logic_vector(N - 1 downto 0);
    signal Msgs_DO   : out R_N_ARR
  );
end entity;

architecture behavorial of lowmc_mpc_hybrid is

  type states is (init, aux_round0, aux_round1);

  signal State_DN, State_DP : states;
  --signal Data_sim_DN, Data_sim_DP : std_logic_vector(N - 1 downto 0);
  signal Data_aux_DN, Data_aux_DP : std_logic_vector(N - 1 downto 0);
  --signal Data_tmp_DN, Data_tmp_DP : std_logic_vector(N - 1 downto 0);
  signal Data_Round_aux_out : std_logic_vector(N - 1 downto 0);

  signal K0_aux_out : std_logic_vector(N - 1 downto 0);
  signal Key_in, Key_out : std_logic_vector(N - 1 downto 0);
  signal Input_DN, Input_DP : std_logic_vector(N - 1 downto 0);
  signal Round_DN, Round_DP : integer range 0 to R - 1;
  signal Round_in : integer range 0 to R - 1;


  signal Aux_DN, Aux_DP : std_logic_vector(R * N - 1 downto 0);
  signal Key_0_aux_in : std_logic_vector(N - 1 downto 0);
  signal Tape_in : N_2_ARR;
  signal Tape_last_in : std_logic_vector(N - 1 downto 0);
  signal aux : std_logic_vector(N - 1 downto 0);
  signal aux_in : std_logic_vector(N - 1 downto 0);
  signal msgs_out : N_ARR;
  -- signal Sim_sbox_out, Aux_sbox_out : std_logic_vector(N - 1 downto 0);
  signal Msgs_DN, Msgs_DP : R_N_ARR;
  signal Sbox_aux_in, Sbox_aux_out : std_logic_vector(N - 1 downto 0);
  
  signal lowmc_round_state_in : std_logic_vector(N - 1 downto 0);
  -- signal debug_flag : std_logic_vector(1 downto 0);
  

  component lowmc_matrix_k0_i
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;


  component lowmc_matrix_k
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      signal Round_DI : in integer range 0 to R - 1;
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;



  component lowmc_matrix_li
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      signal Round_DI : in integer range 0 to R - 1;
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component lowmc_hybrid_mpc_sbox is
    port(
      -- Input signals
      signal State_out_DI  : in std_logic_vector(N - 1 downto 0);
      -- signal Aux_DI        : in std_logic_vector(N - 1 downto 0);
      signal Tape_DI       : in N_2_ARR;
      signal Tape_last_DI  : in std_logic_vector(N - 1 downto 0);
      --signal Round_DI      : in integer range 0 to R - 1;
      signal Lowmc_State_Round_DI: in std_logic_vector(N - 1 downto 0);
      -- Output signals
      signal Aux_DO        : out std_logic_vector(N - 1 downto 0);
      signal State_in_DO  : out std_logic_vector(N - 1 downto 0);
      signal Msgs_DO       : out N_ARR
    );
  end component;

--  component lowmc_sim_mpc_sbox is
--    port(
--      -- Input signals
--      signal State_in_DI   : in std_logic_vector(N - 1 downto 0);
--      signal Aux_DI        : in std_logic_vector(N - 1 downto 0);
--      signal Tape_DI       : in N_2_ARR;
--      signal Tape_last_DI  : in std_logic_vector(N - 1 downto 0);
--      -- Output signals
--      signal State_out_DO  : out std_logic_vector(N - 1 downto 0);
--      signal Msgs_DO       : out N_ARR
--    );
--  end component;

begin

  key0_i : lowmc_matrix_k0_i
  port map(
    Data_DI => Key_0_aux_in,
    Data_DO => K0_aux_out
  );

  rdk : lowmc_matrix_k
  port map(
    Data_DI => Key_in,
    Round_DI => Round_DP,
    Data_DO => Key_out
  );


  Li : lowmc_matrix_li
  port map(
    Data_DI => Data_aux_DP,
    Round_DI => Round_in,
    Data_DO => Data_Round_aux_out
  );
  
  HYBRID_MPC_SBOX : lowmc_hybrid_mpc_sbox
  port map (
    State_out_DI => Sbox_aux_in,
    -- Aux_DI => aux_in,
    Tape_DI => Tape_in,
    Tape_last_DI => Tape_last_in,
    --Round_DI => Round_DP,
    Lowmc_State_Round_DI => lowmc_round_state_in,
    Aux_DO => aux,
    State_in_DO => Sbox_aux_out,
    Msgs_DO => Msgs_out
  );



  
  -- output logic
  process (lowmc_round_state_in, Tape_in, Tape_last_in, Sbox_aux_in, Round_in, State_DP, Aux_SI, Lowmc_State_DI, Round_DP, Data_aux_DP, Tape_last_DI, Tape_DI, aux, Sbox_aux_out, Msgs_out, Aux_DP, Msgs_DP, Data_Round_aux_out, Key_out, K0_aux_out, Input_DP)
    variable tmp0 : std_logic_vector(N - 1 downto 0);
    variable tmp1 : std_logic_vector(N - 1 downto 0);
  begin
    -- default
    Round_DN <= Round_DP;
    -- Data_sim_DN <= Data_sim_DP;
    Data_aux_DN <= Data_aux_DP;
    Aux_DN <= Aux_DP;
    Msgs_DN <= Msgs_DP;
    Input_DN <= Input_DP;
    --Data_tmp_DN <= Data_tmp_DP;
    
    lowmc_round_state_in <= (others => '0');
    
    Finish_SO <= '0';
    Round_in <= 0;
    Key_in <= (others => '0');

    Tape_in <= (others => (others => '0'));
    Sbox_aux_in <= (others => '0');
    Tape_last_in <= (others => '0');
    aux_in <= (others => '0');
    
    tmp0 := (others => '0');
    for i in 0 to P - 2 loop
      tmp0 := tmp0 xor Tape_DI(i)(2 * R * N - 1 downto 2 * R * N - N);
    end loop;
    Key_0_aux_in <= tmp0 xor Tape_last_DI(R * N - 1 downto R * N - N); --  tapesToParityBits(key0, params->stateSizeBits, tapes);

    for i in 0 to (P - 1) loop
      Msgs_DO(i) <= Msgs_DP(i);
    end loop;    
    --Cipher_DO <= Data_sim_DP;
    Aux_out <= Aux_DP;
    Input_out <= Input_DP;
    
    -- output
    case State_DP is
      when init =>
        if Aux_SI = '1' then
          Round_DN <= R - 1;
          Input_DN <= K0_aux_out;   --matrix_mul(key, key0, KMatrixInv(0, params), params); // key = key0 x KMatrix[0]^(-1)
          Aux_DN <= (others => '0');
          Data_aux_DN <= (others => '0');
        end if;
        Finish_SO <= '1';
        --Cipher_DO <= Data_sim_DP;
      when aux_round0 =>
        Key_in <= Input_DP;    --matrix_mul(roundKey, key, KMatrix(r, params), params);    // roundKey = key * KMatrix(r)
        Data_aux_DN <= Data_aux_DP xor Key_out;  --xor_array(x, x, roundKey, params->stateSizeWords);
      when aux_round1 =>
        if Round_DP > 0 then
          Round_DN <= Round_DP - 1;
        end if;
        Round_in <= Round_DP;
        lowmc_round_state_in <= Lowmc_State_DI((R  - Round_in) * N - 1 downto (R - Round_in - 1) * N);
        Sbox_aux_in <= Data_Round_aux_out;  --matrix_mul(y, x, LMatrixInv(r-1, params), params); 
        Data_aux_DN <= Sbox_aux_out;
        
        for i in 0 to (P - 2) loop
          Msgs_DN(i)(R * N - (Round_DP) * N - 1 downto R * N - (Round_DP + 1) * N) <= Msgs_out(i);
        end loop;
        for i in 0 to (S - 1) loop
          Msgs_DN(P - 1)(R * N - (Round_DP + 1) * N + 3 * i + 0) <= Msgs_out(P - 1)(3 * i + 0) xor aux(3 * i + 0);
          Msgs_DN(P - 1)(R * N - (Round_DP + 1) * N + 3 * i + 1) <= Msgs_out(P - 1)(3 * i + 1) xor aux(3 * i + 1);
          Msgs_DN(P - 1)(R * N - (Round_DP + 1) * N + 3 * i + 2) <= Msgs_out(P - 1)(3 * i + 2) xor aux(3 * i + 2);
        end loop;
        for i in 0 to (P - 2) loop
          Tape_in(i) <= Tape_DI(i)(2 * R * N - 2 * (Round_DP) * N - 1 downto 2 * R * N - 2 * (Round_DP + 1) * N);
        end loop;
        Tape_last_in <= Tape_last_DI(R * N - (Round_DP) * N - 1 downto R * N - (Round_DP + 1) * N);
        Aux_DN(R * N - (Round_DP) * N - 1 downto R * N - (Round_DP + 1) * N) <= aux;
        -- Data_sim_DN <= Data_Round_sim_out xor RCMATRIX(Round_DP) xor Key_out;
    end case;
  end process;

  -- next state logic
  process (State_DP, Aux_SI, Round_DP, Lowmc_State_DI)
  begin
    --default
    State_DN <= State_DP;
    case State_DP is
      when init =>
        if Aux_SI = '1' then
          State_DN <= aux_round0;
        end if;
      when aux_round0 =>
        State_DN <= aux_round1;
      when aux_round1 =>
        if Round_DP = 0 then
          State_DN <= init;
        else
          State_DN <= aux_round0;
        end if;
    end case;
  end process;

  -- the registers
  process (Clk_CI, Rst_RI)
  begin  -- process register_p
    if Clk_CI'event and Clk_CI = '1' then
      if Rst_RI = '1' then               -- synchronous reset (active high)
        Round_DP   <= 0;
        --Data_sim_DP <= (others => '0');
        Data_aux_DP <= (others => '0');
        Input_DP <= (others => '0');
        Aux_DP <= (others => '0');
        Msgs_DP <= (others => (others => '0'));
        State_DP   <= init;
      else
        Round_DP   <= Round_DN;
        State_DP   <= State_DN;
        --Data_sim_DP <= Data_sim_DN;
        Data_aux_DP <= Data_aux_DN;
        Input_DP <= Input_DN;
        Aux_DP    <= Aux_DN;
        Msgs_DP    <= Msgs_DN;
      end if;
    end if;
  end process;

end behavorial;
