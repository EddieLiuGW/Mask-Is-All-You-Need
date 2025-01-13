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
    signal Plain_DI  : in std_logic_vector(N - 1 downto 0);
    -- signal Aux_DI    : in std_logic_vector(R * N - 1 downto 0);
    signal Tape_DI   : in R_N_2_ARR;
    signal Tape_last_DI   : in std_logic_vector(R * N - 1 downto 0);
    -- signal Aux_DI   : in std_logic_vector(R * N - 1 downto 0);
    signal Aux_SI    : in std_logic;
    signal Sim_SI    : in std_logic;
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
  
  signal Data_aux_DN, Data_aux_DP : S_R_N_ARR;
  --signal Data_tmp_DN, Data_tmp_DP : std_logic_vector(N - 1 downto 0);
  -- signal Data_Round_sim_out, Data_Round_aux_out : std_logic_vector(N - 1 downto 0);
  signal Data_Round_aux_out : S_R_N_ARR;

  signal K0_sim_out, K0_aux_out : std_logic_vector(N - 1 downto 0);
  signal Key_in, Key_out1, Key_out2, Key_out3, Key_out4 : std_logic_vector(N - 1 downto 0); -- the mask of key for i > 0
  signal Input_DN, Input_DP : std_logic_vector(N - 1 downto 0); -- mk = K0^{-1} * k0
  signal Lambda_DN, Lambda_DP : S_R_N_ARR; --  key i is Ki * mk


  signal Aux_DN, Aux_DP : std_logic_vector(R * N - 1 downto 0);
  signal Lambda_sample_in : S_R_N_ARR;
  signal Tape0_in, Tape1_in, Tape2_in, Tape3_in : N_2_ARR;
  signal Tape0_last_in, Tape1_last_in, Tape2_last_in, Tape3_last_in : std_logic_vector(N - 1 downto 0);
  signal aux : S_R_N_ARR;
  --signal aux_in : std_logic_vector(N - 1 downto 0);
  signal msgs0_out, msgs1_out, msgs2_out, msgs3_out : N_ARR;
  signal Sim_sbox_out, Aux_sbox_out : std_logic_vector(N - 1 downto 0);
  signal Msgs_DN, Msgs_DP : R_N_ARR;
  -- signal Sbox_aux_in, Sbox_aux_out : std_logic_vector(N - 1 downto 0);
  signal Sbox_aux_in : S_R_N_ARR;
  
  signal lowmc_round_state_in : S_R_N_ARR;
  signal debug_flag : std_logic_vector(1 downto 0);
  

  component lowmc_matrix_k0_i
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  -- component lowmc_matrix_k0
  --   port(
  --     -- Input signals
  --     signal Data_DI   : in std_logic_vector(N - 1 downto 0);
  --     -- Output signals
  --     signal Data_DO : out std_logic_vector(N - 1 downto 0)
  --   );
  -- end component;

  component lowmc_matrix_k1
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component lowmc_matrix_k2
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component lowmc_matrix_k3
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component lowmc_matrix_k4
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component lowmc_matrix_li0
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component lowmc_matrix_li1
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component lowmc_matrix_li2
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component lowmc_matrix_li3
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
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
      signal Lowmc_State_DI: in std_logic_vector(N - 1 downto 0);
      signal Lambda_DI     : in std_logic_vector(N - 1 downto 0);
      -- Output signals
      signal Aux_DO        : out std_logic_vector(N - 1 downto 0);
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

  component lowmc_matrix_l
    port(
      -- Input signals
      signal Data_DI   : in std_logic_vector(N - 1 downto 0);
      signal Round_DI : in integer range 0 to R - 1;
      -- Output signals
      signal Data_DO : out std_logic_vector(N - 1 downto 0)
    );
  end component;

begin

  key0_i : lowmc_matrix_k0_i
  port map(
    Data_DI => Lambda_sample_in(0),
    Data_DO => K0_aux_out
  );

  rdk1 : lowmc_matrix_k1
  port map(
    Data_DI => Key_in,
    Data_DO => Key_out1
  );

  rdk2 : lowmc_matrix_k2
  port map(
    Data_DI => Key_in,
    Data_DO => Key_out2
  );

  rdk3 : lowmc_matrix_k3
  port map(
    Data_DI => Key_in,
    Data_DO => Key_out3
  );

  rdk4 : lowmc_matrix_k4
  port map(
    Data_DI => Key_in,
    Data_DO => Key_out4
  );

  Li0 : lowmc_matrix_li0
  port map(
    Data_DI => Data_aux_DP(0),
    Data_DO => Data_Round_aux_out(0)
  );

  Li1 : lowmc_matrix_li1
  port map(
    Data_DI => Data_aux_DP(1),
    Data_DO => Data_Round_aux_out(1)
  );

  Li2 : lowmc_matrix_li2
  port map(
    Data_DI => Data_aux_DP(2),
    Data_DO => Data_Round_aux_out(2)
  );

  Li3 : lowmc_matrix_li3
  port map(
    Data_DI => Data_aux_DP(3),
    Data_DO => Data_Round_aux_out(3)
  );

  
  HYBRID_MPC_SBOX0 : lowmc_hybrid_mpc_sbox
  port map (
    State_out_DI => Sbox_aux_in(0),
    -- Aux_DI => aux_in,
    Tape_DI => Tape0_in,
    Tape_last_DI => Tape0_last_in,
    Lowmc_State_DI => lowmc_round_state_in(0),
    Lambda_DI => Lambda_DP(0),
    Aux_DO => aux(0),
    Msgs_DO => Msgs0_out
  );

  HYBRID_MPC_SBOX1 : lowmc_hybrid_mpc_sbox
  port map (
    State_out_DI => Sbox_aux_in(1),
    Tape_DI => Tape1_in,
    Tape_last_DI => Tape1_last_in,
    Lowmc_State_DI => lowmc_round_state_in(1),
    Lambda_DI => Lambda_DP(1),
    Aux_DO => aux(1),
    Msgs_DO => Msgs1_out
  );

  HYBRID_MPC_SBOX2 : lowmc_hybrid_mpc_sbox
  port map (
    State_out_DI => Sbox_aux_in(2),
    Tape_DI => Tape2_in,
    Tape_last_DI => Tape2_last_in,
    Lowmc_State_DI => lowmc_round_state_in(2),
    Lambda_DI => Lambda_DP(2),
    Aux_DO => aux(2),
    Msgs_DO => Msgs2_out
  );

  HYBRID_MPC_SBOX3 : lowmc_hybrid_mpc_sbox
  port map (
    State_out_DI => Sbox_aux_in(3),
    Tape_DI => Tape3_in,
    Tape_last_DI => Tape3_last_in,
    Lowmc_State_DI => lowmc_round_state_in(3),
    Lambda_DI => Lambda_DP(3),
    Aux_DO => aux(3),
    Msgs_DO => Msgs3_out
  );
  


  -- SIM_MPC_SBOX : lowmc_sim_mpc_sbox
  -- port map (
  --   State_in_DI => Data_sim_DP,
  --   Aux_DI => aux_in,
  --   Tape_DI => Tape_in,
  --   Tape_last_DI => Tape_last_in,
  --   State_out_DO => Sim_sbox_out,
  --   Msgs_DO => Msgs_out
  -- );

  -- L : lowmc_matrix_l
  -- port map(
  --   Data_DI => Sim_sbox_out,
  --   Round_DI => Round_in,
  --   Data_DO => Data_Round_sim_out
  -- );

  
  -- output logic
  process (Input_DP, State_DP, Aux_SI, Sim_SI, Plain_DI, Lowmc_State_DI, Data_aux_DP, Tape_last_DI, Tape_DI, aux, Msgs0_out, Msgs1_out, Msgs2_out, Msgs3_out, Aux_DP, Msgs_DP, Data_Round_aux_out, Key_out1, Key_out2, Key_out3, Key_out4, K0_aux_out, Lambda_DP)
    variable tmp : S_R_N_ARR;
  begin
    -- default
    -- Data_sim_DN <= Data_sim_DP;
    Data_aux_DN <= Data_aux_DP;
    Aux_DN <= Aux_DP;
    Msgs_DN <= Msgs_DP;
    Lambda_DN <= Lambda_DP;
    Input_DN <= Input_DP;
    --Data_tmp_DN <= Data_tmp_DP;
    
    lowmc_round_state_in <= (others => (others => '0'));
    
    Finish_SO <= '0';
    --Round_in <= 0;
    Key_in <= (others => '0');

    Tape0_in <= (others => (others => '0'));
    Tape1_in <= (others => (others => '0'));
    Tape2_in <= (others => (others => '0'));
    Tape3_in <= (others => (others => '0'));
    Sbox_aux_in <= (others => (others => '0'));
    Tape0_last_in <= (others => '0');
    Tape1_last_in <= (others => '0');
    Tape2_last_in <= (others => '0');
    Tape3_last_in <= (others => '0');
    --aux_in <= (others => '0');
    
    tmp := (others => (others => '0'));
    for i in 0 to P - 2 loop
      tmp(0) := tmp(0) xor Tape_DI(i)(2 * R * N - 1 downto 2 * R * N - N);
      tmp(1) := tmp(1) xor Tape_DI(i)(2 * (R - 1) * N - 1 downto 2 * (R - 1) * N - N);
      tmp(2) := tmp(2) xor Tape_DI(i)(2 * (R - 2) * N - 1 downto 2 * (R - 2) * N - N);
      tmp(3) := tmp(3) xor Tape_DI(i)(2 * (R - 3) * N - 1 downto 2 * (R - 3) * N - N);
    end loop;
    Lambda_sample_in(0) <= tmp(0) xor Tape_last_DI(R * N - 1 downto R * N - N); -- the mask of k0, i.e., lambda of k0
    Lambda_sample_in(1) <= tmp(1) xor Tape_last_DI((R - 1) * N - 1 downto (R - 1) * N - N);
    Lambda_sample_in(2) <= tmp(2) xor Tape_last_DI((R - 2) * N - 1 downto (R - 2) * N - N);
    Lambda_sample_in(3) <= tmp(3) xor Tape_last_DI((R - 3) * N - 1 downto (R - 3) * N - N);

    for i in 0 to (P - 1) loop
      Msgs_DO(i) <= Msgs_DP(i);
    end loop;    
    --Cipher_DO <= Data_sim_DP;
    Aux_out <= Aux_DP;
    Input_out <= Input_DP; -- mk
    
    -- output
    case State_DP is
      when init =>
        if Aux_SI = '1' then
          Input_DN <= K0_aux_out;   --matrix_mul(key, key0, KMatrixInv(0, params), params); // key = key0 x KMatrix[0]^(-1)
          Aux_DN <= (others => '0');
          Lambda_DN(0) <= Lambda_sample_in(0);
          Lambda_DN(1) <= Lambda_sample_in(1);
          Lambda_DN(2) <= Lambda_sample_in(2);
          Lambda_DN(3) <= Lambda_sample_in(3);
          Data_aux_DN <= (others => (others => '0'));
          Msgs_DN <= (others =>(others => '0'));
        end if;
        Finish_SO <= '1';
        --Cipher_DO <= Data_sim_DP;
      when aux_round0 =>
        Key_in <= Input_DP;
        Data_aux_DN(3) <= Key_out4;
        Data_aux_DN(2) <= Key_out3 xor Lambda_DP(3);
        Data_aux_DN(1) <= Key_out2 xor Lambda_DP(2);
        Data_aux_DN(0) <= Key_out1 xor Lambda_DP(1);
      when aux_round1 =>
        lowmc_round_state_in(0) <= Lowmc_State_DI(R * N - 1 downto (R - 1) * N);
        lowmc_round_state_in(1) <= Lowmc_State_DI((R - 1) * N - 1 downto (R - 2) * N);
        lowmc_round_state_in(2) <= Lowmc_State_DI((R - 2) * N - 1 downto (R - 3) * N);
        lowmc_round_state_in(3) <= Lowmc_State_DI((R - 3) * N - 1 downto 0);
        Sbox_aux_in <= Data_Round_aux_out;
        
        for i in 0 to (P - 2) loop
          Msgs_DN(i)(R * N - (0) * N - 1 downto R * N - (0 + 1) * N) <= Msgs0_out(i);
        end loop;
        for i in 0 to (S - 1) loop
          Msgs_DN(P - 1)(R * N - (0 + 1) * N + 3 * i + 0) <= Msgs0_out(P - 1)(3 * i + 0) xor aux(0)(3 * i + 0);
          Msgs_DN(P - 1)(R * N - (0 + 1) * N + 3 * i + 1) <= Msgs0_out(P - 1)(3 * i + 1) xor aux(0)(3 * i + 1);
          Msgs_DN(P - 1)(R * N - (0 + 1) * N + 3 * i + 2) <= Msgs0_out(P - 1)(3 * i + 2) xor aux(0)(3 * i + 2);
        end loop;
        for i in 0 to (P - 2) loop
          Tape0_in(i) <= Tape_DI(i)(2 * R * N - 2 * (0) * N - 1 downto 2 * R * N - 2 * (0 + 1) * N);
        end loop;
        Tape0_last_in <= Tape_last_DI(R * N - (0) * N - 1 downto R * N - (0 + 1) * N);
        
        for i in 0 to (P - 2) loop
          Msgs_DN(i)(R * N - (1) * N - 1 downto R * N - (1 + 1) * N) <= Msgs1_out(i);
        end loop;
        for i in 0 to (S - 1) loop
          Msgs_DN(P - 1)(R * N - (1 + 1) * N + 3 * i + 0) <= Msgs1_out(P - 1)(3 * i + 0) xor aux(1)(3 * i + 0);
          Msgs_DN(P - 1)(R * N - (1 + 1) * N + 3 * i + 1) <= Msgs1_out(P - 1)(3 * i + 1) xor aux(1)(3 * i + 1);
          Msgs_DN(P - 1)(R * N - (1 + 1) * N + 3 * i + 2) <= Msgs1_out(P - 1)(3 * i + 2) xor aux(1)(3 * i + 2);
        end loop;
        for i in 0 to (P - 2) loop
          Tape1_in(i) <= Tape_DI(i)(2 * R * N - 2 * (1) * N - 1 downto 2 * R * N - 2 * (1 + 1) * N);
        end loop;
        Tape1_last_in <= Tape_last_DI(R * N - (1) * N - 1 downto R * N - (1 + 1) * N);
        
        for i in 0 to (P - 2) loop
          Msgs_DN(i)(R * N - (2) * N - 1 downto R * N - (2 + 1) * N) <= Msgs2_out(i);
        end loop;
        for i in 0 to (S - 1) loop
          Msgs_DN(P - 1)(R * N - (2 + 1) * N + 3 * i + 0) <= Msgs2_out(P - 1)(3 * i + 0) xor aux(2)(3 * i + 0);
          Msgs_DN(P - 1)(R * N - (2 + 1) * N + 3 * i + 1) <= Msgs2_out(P - 1)(3 * i + 1) xor aux(2)(3 * i + 1);
          Msgs_DN(P - 1)(R * N - (2 + 1) * N + 3 * i + 2) <= Msgs2_out(P - 1)(3 * i + 2) xor aux(2)(3 * i + 2);
        end loop;
        for i in 0 to (P - 2) loop
          Tape2_in(i) <= Tape_DI(i)(2 * R * N - 2 * (2) * N - 1 downto 2 * R * N - 2 * (2 + 1) * N);
        end loop;
        Tape2_last_in <= Tape_last_DI(R * N - (2) * N - 1 downto R * N - (2 + 1) * N);
        
        for i in 0 to (P - 2) loop
          Msgs_DN(i)(R * N - (3) * N - 1 downto R * N - (3 + 1) * N) <= Msgs3_out(i);
        end loop;
        for i in 0 to (S - 1) loop
          Msgs_DN(P - 1)(R * N - (3 + 1) * N + 3 * i + 0) <= Msgs3_out(P - 1)(3 * i + 0) xor aux(3)(3 * i + 0);
          Msgs_DN(P - 1)(R * N - (3 + 1) * N + 3 * i + 1) <= Msgs3_out(P - 1)(3 * i + 1) xor aux(3)(3 * i + 1);
          Msgs_DN(P - 1)(R * N - (3 + 1) * N + 3 * i + 2) <= Msgs3_out(P - 1)(3 * i + 2) xor aux(3)(3 * i + 2);
        end loop;
        for i in 0 to (P - 2) loop
          Tape3_in(i) <= Tape_DI(i)(2 * R * N - 2 * (3) * N - 1 downto 2 * R * N - 2 * (3 + 1) * N);
        end loop;
        Tape3_last_in <= Tape_last_DI(R * N - (3) * N - 1 downto R * N - (3 + 1) * N);

        Aux_DN(R * N - (0) * N - 1 downto R * N - (0 + 1) * N) <= aux(0);
        Aux_DN(R * N - (1) * N - 1 downto R * N - (1 + 1) * N) <= aux(1);
        Aux_DN(R * N - (2) * N - 1 downto R * N - (2 + 1) * N) <= aux(2);
        Aux_DN(R * N - (3) * N - 1 downto R * N - (3 + 1) * N) <= aux(3);
        --Data_sim_DN <= Data_Round_sim_out xor RCMATRIX(Round_DP) xor Key_out;
    end case;
  end process;

  -- next state logic
  process (State_DP, Aux_SI, Sim_SI, Lowmc_State_DI)
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
        State_DN <= init;
    end case;
  end process;

  -- the registers
  process (Clk_CI, Rst_RI)
  begin  -- process register_p
    if Clk_CI'event and Clk_CI = '1' then
      if Rst_RI = '1' then               -- synchronous reset (active high)
        -- Data_sim_DP <= (others => '0');
        Data_aux_DP <= (others => (others => '0'));
        Lambda_DP <= (others => (others => '0'));
        Aux_DP <= (others => '0');
        Msgs_DP <= (others => (others => '0'));
        State_DP   <= init;
        Input_DP <= (others => '0');
      else
        State_DP   <= State_DN;
        -- Data_sim_DP <= Data_sim_DN;
        Data_aux_DP <= Data_aux_DN;
        Lambda_DP <= Lambda_DN;
        Aux_DP    <= Aux_DN;
        Msgs_DP    <= Msgs_DN;
        Input_DP <= Input_DN;
      end if;
    end if;
  end process;

end behavorial;
