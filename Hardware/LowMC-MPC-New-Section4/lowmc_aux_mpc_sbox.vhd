library work;
use work.lowmc_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
entity lowmc_hybrid_mpc_sbox is
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
end entity;

architecture behavorial of lowmc_hybrid_mpc_sbox is
  signal aux_out : std_logic_vector(N - 1 downto 0);
  signal fresh_output_mask_in : std_logic_vector(N - 1 downto 0);

  -- signal and_helper : std_logic_vector(N - 1 downto 0);
  signal msgs_out : N_ARR;
  signal lambda_a_array, lambda_b_array, lambda_c_array : std_logic_vector(S - 1 downto 0);
  
  component hybrid_mpc_and is
    port(
      -- Input signals
      
      signal fresh_output_mask : in std_logic;
      -- signal and_helper : std_logic;
      signal a : in std_logic;
      signal lambda_a : in std_logic;
      signal a_i_0 : in std_logic;
      signal a_i_1 : in std_logic;
      signal a_i_2 : in std_logic;
      signal a_i_3 : in std_logic;
      signal a_i_4 : in std_logic;
      signal a_i_5 : in std_logic;
      signal a_i_6 : in std_logic;
      signal a_i_7 : in std_logic;
      signal a_i_8 : in std_logic;
      signal a_i_9 : in std_logic;
      signal a_i_10 : in std_logic;
      signal a_i_11 : in std_logic;
      signal a_i_12 : in std_logic;
      signal a_i_13 : in std_logic;
      signal a_i_14 : in std_logic;
      signal a_i_15 : in std_logic;
      signal b : in std_logic;
      signal lambda_b : in std_logic;
      signal b_i_0 : in std_logic;
      signal b_i_1 : in std_logic;
      signal b_i_2 : in std_logic;
      signal b_i_3 : in std_logic;
      signal b_i_4 : in std_logic;
      signal b_i_5 : in std_logic;
      signal b_i_6 : in std_logic;
      signal b_i_7 : in std_logic;
      signal b_i_8 : in std_logic;
      signal b_i_9 : in std_logic;
      signal b_i_10 : in std_logic;
      signal b_i_11 : in std_logic;
      signal b_i_12 : in std_logic;
      signal b_i_13 : in std_logic;
      signal b_i_14 : in std_logic;
      signal b_i_15 : in std_logic;
      signal and_helper_0 : in std_logic;
      signal and_helper_1 : in std_logic;
      signal and_helper_2 : in std_logic;
      signal and_helper_3 : in std_logic;
      signal and_helper_4 : in std_logic;
      signal and_helper_5 : in std_logic;
      signal and_helper_6 : in std_logic;
      signal and_helper_7 : in std_logic;
      signal and_helper_8 : in std_logic;
      signal and_helper_9 : in std_logic;
      signal and_helper_10 : in std_logic;
      signal and_helper_11 : in std_logic;
      signal and_helper_12 : in std_logic;
      signal and_helper_13 : in std_logic;
      signal and_helper_14 : in std_logic;
      -- signal and_helper_15 : in std_logic;
      signal msgs_0 : out std_logic;
      signal msgs_1 : out std_logic;
      signal msgs_2 : out std_logic;
      signal msgs_3 : out std_logic;
      signal msgs_4 : out std_logic;
      signal msgs_5 : out std_logic;
      signal msgs_6 : out std_logic;
      signal msgs_7 : out std_logic;
      signal msgs_8 : out std_logic;
      signal msgs_9 : out std_logic;
      signal msgs_10 : out std_logic;
      signal msgs_11 : out std_logic;
      signal msgs_12 : out std_logic;
      signal msgs_13 : out std_logic;
      signal msgs_14 : out std_logic;
      signal msgs_15 : out std_logic;
      -- Output signals
      signal aux : out std_logic
    );
  end component;
begin
--2 * R * N - 2 * (Round_DP) * N - 1
  SBOX_GEN : for i in 0 to S - 1 generate
    -- and_helper(3 * i + 0) <= Tape_DI(P - 2 - (0))(3 * i + 0) xor Tape_DI(P - 2 - (1))(3 * i + 0) xor Tape_DI(P - 2 - (2))(3 * i + 0) xor Tape_DI(P - 2 - (3))(3 * i + 0) xor Tape_DI(P - 2 - (4))(3 * i + 0) xor Tape_DI(P - 2 - (5))(3 * i + 0) xor Tape_DI(P - 2 - (6))(3 * i + 0) xor Tape_DI(P - 2 - (7))(3 * i + 0) xor Tape_DI(P - 2 - (8))(3 * i + 0) xor Tape_DI(P - 2 - (9))(3 * i + 0) xor Tape_DI(P - 2 - (10))(3 * i + 0) xor Tape_DI(P - 2 - (11))(3 * i + 0) xor Tape_DI(P - 2 - (12))(3 * i + 0) xor Tape_DI(P - 2 - (13))(3 * i + 0) xor Tape_DI(P - 2 - (14))(3 * i + 0);
    -- and_helper(3 * i + 1) <= Tape_DI(P - 2 - (0))(3 * i + 1) xor Tape_DI(P - 2 - (1))(3 * i + 1) xor Tape_DI(P - 2 - (2))(3 * i + 1) xor Tape_DI(P - 2 - (3))(3 * i + 1) xor Tape_DI(P - 2 - (4))(3 * i + 1) xor Tape_DI(P - 2 - (5))(3 * i + 1) xor Tape_DI(P - 2 - (6))(3 * i + 1) xor Tape_DI(P - 2 - (7))(3 * i + 1) xor Tape_DI(P - 2 - (8))(3 * i + 1) xor Tape_DI(P - 2 - (9))(3 * i + 1) xor Tape_DI(P - 2 - (10))(3 * i + 1) xor Tape_DI(P - 2 - (11))(3 * i + 1) xor Tape_DI(P - 2 - (12))(3 * i + 1) xor Tape_DI(P - 2 - (13))(3 * i + 1) xor Tape_DI(P - 2 - (14))(3 * i + 1);
    -- and_helper(3 * i + 2) <= Tape_DI(P - 2 - (0))(3 * i + 2) xor Tape_DI(P - 2 - (1))(3 * i + 2) xor Tape_DI(P - 2 - (2))(3 * i + 2) xor Tape_DI(P - 2 - (3))(3 * i + 2) xor Tape_DI(P - 2 - (4))(3 * i + 2) xor Tape_DI(P - 2 - (5))(3 * i + 2) xor Tape_DI(P - 2 - (6))(3 * i + 2) xor Tape_DI(P - 2 - (7))(3 * i + 2) xor Tape_DI(P - 2 - (8))(3 * i + 2) xor Tape_DI(P - 2 - (9))(3 * i + 2) xor Tape_DI(P - 2 - (10))(3 * i + 2) xor Tape_DI(P - 2 - (11))(3 * i + 2) xor Tape_DI(P - 2 - (12))(3 * i + 2) xor Tape_DI(P - 2 - (13))(3 * i + 2) xor Tape_DI(P - 2 - (14))(3 * i + 2);
    lambda_a_array(i) <= Tape_DI(0)(N + 3 * i + 0) xor Tape_DI(1)(N + 3 * i + 0) xor Tape_DI(2)(N + 3 * i + 0) xor Tape_DI(3)(N + 3 * i + 0) xor Tape_DI(4)(N + 3 * i + 0) xor Tape_DI(5)(N + 3 * i + 0) xor Tape_DI(6)(N + 3 * i + 0) xor Tape_DI(7)(N + 3 * i + 0) xor Tape_DI(8)(N + 3 * i + 0) xor Tape_DI(9)(N + 3 * i + 0) xor Tape_DI(10)(N + 3 * i + 0) xor Tape_DI(11)(N + 3 * i + 0) xor Tape_DI(12)(N + 3 * i + 0) xor Tape_DI(13)(N + 3 * i + 0) xor Tape_DI(14)(N + 3 * i + 0) xor Tape_last_DI(3 * i + 0);
    lambda_b_array(i) <= Tape_DI(0)(N + 3 * i + 1) xor Tape_DI(1)(N + 3 * i + 1) xor Tape_DI(2)(N + 3 * i + 1) xor Tape_DI(3)(N + 3 * i + 1) xor Tape_DI(4)(N + 3 * i + 1) xor Tape_DI(5)(N + 3 * i + 1) xor Tape_DI(6)(N + 3 * i + 1) xor Tape_DI(7)(N + 3 * i + 1) xor Tape_DI(8)(N + 3 * i + 1) xor Tape_DI(9)(N + 3 * i + 1) xor Tape_DI(10)(N + 3 * i + 1) xor Tape_DI(11)(N + 3 * i + 1) xor Tape_DI(12)(N + 3 * i + 1) xor Tape_DI(13)(N + 3 * i + 1) xor Tape_DI(14)(N + 3 * i + 1) xor Tape_last_DI(3 * i + 1);
    lambda_c_array(i) <= Tape_DI(0)(N + 3 * i + 2) xor Tape_DI(1)(N + 3 * i + 2) xor Tape_DI(2)(N + 3 * i + 2) xor Tape_DI(3)(N + 3 * i + 2) xor Tape_DI(4)(N + 3 * i + 2) xor Tape_DI(5)(N + 3 * i + 2) xor Tape_DI(6)(N + 3 * i + 2) xor Tape_DI(7)(N + 3 * i + 2) xor Tape_DI(8)(N + 3 * i + 2) xor Tape_DI(9)(N + 3 * i + 2) xor Tape_DI(10)(N + 3 * i + 2) xor Tape_DI(11)(N + 3 * i + 2) xor Tape_DI(12)(N + 3 * i + 2) xor Tape_DI(13)(N + 3 * i + 2) xor Tape_DI(14)(N + 3 * i + 2) xor Tape_last_DI(3 * i + 2);
    -- ab fresh_output_mask_ab = f ^ a ^ b ^ c;
    fresh_output_mask_in(3 * i + 2) <= State_out_DI(3 * i + 2) xor lambda_a_array(i) xor lambda_b_array(i) xor lambda_c_array(i);
    -- bc fresh_output_mask_bc = d ^ a;
    fresh_output_mask_in(3 * i + 1) <= State_out_DI(3 * i + 0) xor lambda_a_array(i);
    -- ca fresh_output_mask_ca = e ^ a ^ b;
    fresh_output_mask_in(3 * i + 0) <= State_out_DI(3 * i + 1) xor lambda_a_array(i) xor lambda_b_array(i);
    AB : hybrid_mpc_and
    port map(
      a => Lowmc_State_Round_DI(3 * i + 0),
      lambda_a => lambda_a_array(i),
      fresh_output_mask => fresh_output_mask_in(3 * i + 2),
      a_i_0 => Tape_DI(0)(N + 3 * i + 0),
      a_i_1 => Tape_DI(1)(N + 3 * i + 0),
      a_i_2 => Tape_DI(2)(N + 3 * i + 0),
      a_i_3 => Tape_DI(3)(N + 3 * i + 0),
      a_i_4 => Tape_DI(4)(N + 3 * i + 0),
      a_i_5 => Tape_DI(5)(N + 3 * i + 0),
      a_i_6 => Tape_DI(6)(N + 3 * i + 0),
      a_i_7 => Tape_DI(7)(N + 3 * i + 0),
      a_i_8 => Tape_DI(8)(N + 3 * i + 0),
      a_i_9 => Tape_DI(9)(N + 3 * i + 0),
      a_i_10 => Tape_DI(10)(N + 3 * i + 0),
      a_i_11 => Tape_DI(11)(N + 3 * i + 0),
      a_i_12 => Tape_DI(12)(N + 3 * i + 0),
      a_i_13 => Tape_DI(13)(N + 3 * i + 0),
      a_i_14 => Tape_DI(14)(N + 3 * i + 0),
      a_i_15 => Tape_last_DI(3 * i + 0),
      b => Lowmc_State_Round_DI(3 * i + 1),
      lambda_b => lambda_b_array(i),
      b_i_0 => Tape_DI(0)(N + 3 * i + 1),
      b_i_1 => Tape_DI(1)(N + 3 * i + 1),
      b_i_2 => Tape_DI(2)(N + 3 * i + 1),
      b_i_3 => Tape_DI(3)(N + 3 * i + 1),
      b_i_4 => Tape_DI(4)(N + 3 * i + 1),
      b_i_5 => Tape_DI(5)(N + 3 * i + 1),
      b_i_6 => Tape_DI(6)(N + 3 * i + 1),
      b_i_7 => Tape_DI(7)(N + 3 * i + 1),
      b_i_8 => Tape_DI(8)(N + 3 * i + 1),
      b_i_9 => Tape_DI(9)(N + 3 * i + 1),
      b_i_10 => Tape_DI(10)(N + 3 * i + 1),
      b_i_11 => Tape_DI(11)(N + 3 * i + 1),
      b_i_12 => Tape_DI(12)(N + 3 * i + 1),
      b_i_13 => Tape_DI(13)(N + 3 * i + 1),
      b_i_14 => Tape_DI(14)(N + 3 * i + 1),
      b_i_15 => Tape_last_DI(3 * i + 1),
      and_helper_0 => Tape_DI(0)(3 * i + 2),
      and_helper_1 => Tape_DI(1)(3 * i + 2),
      and_helper_2 => Tape_DI(2)(3 * i + 2),
      and_helper_3 => Tape_DI(3)(3 * i + 2),
      and_helper_4 => Tape_DI(4)(3 * i + 2),
      and_helper_5 => Tape_DI(5)(3 * i + 2),
      and_helper_6 => Tape_DI(6)(3 * i + 2),
      and_helper_7 => Tape_DI(7)(3 * i + 2),
      and_helper_8 => Tape_DI(8)(3 * i + 2),
      and_helper_9 => Tape_DI(9)(3 * i + 2),
      and_helper_10 => Tape_DI(10)(3 * i + 2),
      and_helper_11 => Tape_DI(11)(3 * i + 2),
      and_helper_12 => Tape_DI(12)(3 * i + 2),
      and_helper_13 => Tape_DI(13)(3 * i + 2),
      and_helper_14 => Tape_DI(14)(3 * i + 2),
      -- and_helper_15 => Aux_DI(3 * i + 2),
      msgs_0 => msgs_out(0)(3 * i + 2),
      msgs_1 => msgs_out(1)(3 * i + 2),
      msgs_2 => msgs_out(2)(3 * i + 2),
      msgs_3 => msgs_out(3)(3 * i + 2),
      msgs_4 => msgs_out(4)(3 * i + 2),
      msgs_5 => msgs_out(5)(3 * i + 2),
      msgs_6 => msgs_out(6)(3 * i + 2),
      msgs_7 => msgs_out(7)(3 * i + 2),
      msgs_8 => msgs_out(8)(3 * i + 2),
      msgs_9 => msgs_out(9)(3 * i + 2),
      msgs_10 => msgs_out(10)(3 * i + 2),
      msgs_11 => msgs_out(11)(3 * i + 2),
      msgs_12 => msgs_out(12)(3 * i + 2),
      msgs_13 => msgs_out(13)(3 * i + 2),
      msgs_14 => msgs_out(14)(3 * i + 2),
      msgs_15 => msgs_out(15)(3 * i + 2),
      --and_helper => and_helper(3 * i + 2),
      aux => aux_out(3 * i + 2)
    );
    BC : hybrid_mpc_and
    port map(
      a => Lowmc_State_Round_DI(3 * i + 1),
      fresh_output_mask => fresh_output_mask_in(3 * i + 1),
      lambda_a => lambda_b_array(i),
      a_i_0 => Tape_DI(0)(N + 3 * i + 1),
      a_i_1 => Tape_DI(1)(N + 3 * i + 1),
      a_i_2 => Tape_DI(2)(N + 3 * i + 1),
      a_i_3 => Tape_DI(3)(N + 3 * i + 1),
      a_i_4 => Tape_DI(4)(N + 3 * i + 1),
      a_i_5 => Tape_DI(5)(N + 3 * i + 1),
      a_i_6 => Tape_DI(6)(N + 3 * i + 1),
      a_i_7 => Tape_DI(7)(N + 3 * i + 1),
      a_i_8 => Tape_DI(8)(N + 3 * i + 1),
      a_i_9 => Tape_DI(9)(N + 3 * i + 1),
      a_i_10 => Tape_DI(10)(N + 3 * i + 1),
      a_i_11 => Tape_DI(11)(N + 3 * i + 1),
      a_i_12 => Tape_DI(12)(N + 3 * i + 1),
      a_i_13 => Tape_DI(13)(N + 3 * i + 1),
      a_i_14 => Tape_DI(14)(N + 3 * i + 1),
      a_i_15 => Tape_last_DI(3 * i + 1),
      b => Lowmc_State_Round_DI(3 * i + 2),
      lambda_b => lambda_c_array(i),
      b_i_0 => Tape_DI(0)(N + 3 * i + 2),
      b_i_1 => Tape_DI(1)(N + 3 * i + 2),
      b_i_2 => Tape_DI(2)(N + 3 * i + 2),
      b_i_3 => Tape_DI(3)(N + 3 * i + 2),
      b_i_4 => Tape_DI(4)(N + 3 * i + 2),
      b_i_5 => Tape_DI(5)(N + 3 * i + 2),
      b_i_6 => Tape_DI(6)(N + 3 * i + 2),
      b_i_7 => Tape_DI(7)(N + 3 * i + 2),
      b_i_8 => Tape_DI(8)(N + 3 * i + 2),
      b_i_9 => Tape_DI(9)(N + 3 * i + 2),
      b_i_10 => Tape_DI(10)(N + 3 * i + 2),
      b_i_11 => Tape_DI(11)(N + 3 * i + 2),
      b_i_12 => Tape_DI(12)(N + 3 * i + 2),
      b_i_13 => Tape_DI(13)(N + 3 * i + 2),
      b_i_14 => Tape_DI(14)(N + 3 * i + 2),
      b_i_15 => Tape_last_DI(3 * i + 2),
      and_helper_0 => Tape_DI(0)(3 * i + 1),
      and_helper_1 => Tape_DI(1)(3 * i + 1),
      and_helper_2 => Tape_DI(2)(3 * i + 1),
      and_helper_3 => Tape_DI(3)(3 * i + 1),
      and_helper_4 => Tape_DI(4)(3 * i + 1),
      and_helper_5 => Tape_DI(5)(3 * i + 1),
      and_helper_6 => Tape_DI(6)(3 * i + 1),
      and_helper_7 => Tape_DI(7)(3 * i + 1),
      and_helper_8 => Tape_DI(8)(3 * i + 1),
      and_helper_9 => Tape_DI(9)(3 * i + 1),
      and_helper_10 => Tape_DI(10)(3 * i + 1),
      and_helper_11 => Tape_DI(11)(3 * i + 1),
      and_helper_12 => Tape_DI(12)(3 * i + 1),
      and_helper_13 => Tape_DI(13)(3 * i + 1),
      and_helper_14 => Tape_DI(14)(3 * i + 1),
      -- and_helper_15 => Aux_DI(3 * i + 1),
      msgs_0 => msgs_out(0)(3 * i + 1),
      msgs_1 => msgs_out(1)(3 * i + 1),
      msgs_2 => msgs_out(2)(3 * i + 1),
      msgs_3 => msgs_out(3)(3 * i + 1),
      msgs_4 => msgs_out(4)(3 * i + 1),
      msgs_5 => msgs_out(5)(3 * i + 1),
      msgs_6 => msgs_out(6)(3 * i + 1),
      msgs_7 => msgs_out(7)(3 * i + 1),
      msgs_8 => msgs_out(8)(3 * i + 1),
      msgs_9 => msgs_out(9)(3 * i + 1),
      msgs_10 => msgs_out(10)(3 * i + 1),
      msgs_11 => msgs_out(11)(3 * i + 1),
      msgs_12 => msgs_out(12)(3 * i + 1),
      msgs_13 => msgs_out(13)(3 * i + 1),
      msgs_14 => msgs_out(14)(3 * i + 1),
      msgs_15 => msgs_out(15)(3 * i + 1),
      --and_helper => and_helper(3 * i + 1),
      aux => aux_out(3 * i + 1)
    );
    CA : hybrid_mpc_and
    port map(
      a => Lowmc_State_Round_DI(3 * i + 2),
      fresh_output_mask => fresh_output_mask_in(3 * i + 0),
      lambda_a => lambda_c_array(i),
      a_i_0 => Tape_DI(0)(N + 3 * i + 2),
      a_i_1 => Tape_DI(1)(N + 3 * i + 2),
      a_i_2 => Tape_DI(2)(N + 3 * i + 2),
      a_i_3 => Tape_DI(3)(N + 3 * i + 2),
      a_i_4 => Tape_DI(4)(N + 3 * i + 2),
      a_i_5 => Tape_DI(5)(N + 3 * i + 2),
      a_i_6 => Tape_DI(6)(N + 3 * i + 2),
      a_i_7 => Tape_DI(7)(N + 3 * i + 2),
      a_i_8 => Tape_DI(8)(N + 3 * i + 2),
      a_i_9 => Tape_DI(9)(N + 3 * i + 2),
      a_i_10 => Tape_DI(10)(N + 3 * i + 2),
      a_i_11 => Tape_DI(11)(N + 3 * i + 2),
      a_i_12 => Tape_DI(12)(N + 3 * i + 2),
      a_i_13 => Tape_DI(13)(N + 3 * i + 2),
      a_i_14 => Tape_DI(14)(N + 3 * i + 2),
      b => Lowmc_State_Round_DI(3 * i + 0),
      lambda_b => lambda_a_array(i),
      a_i_15 => Tape_last_DI(3 * i + 2),
      b_i_0 => Tape_DI(0)(N + 3 * i + 0),
      b_i_1 => Tape_DI(1)(N + 3 * i + 0),
      b_i_2 => Tape_DI(2)(N + 3 * i + 0),
      b_i_3 => Tape_DI(3)(N + 3 * i + 0),
      b_i_4 => Tape_DI(4)(N + 3 * i + 0),
      b_i_5 => Tape_DI(5)(N + 3 * i + 0),
      b_i_6 => Tape_DI(6)(N + 3 * i + 0),
      b_i_7 => Tape_DI(7)(N + 3 * i + 0),
      b_i_8 => Tape_DI(8)(N + 3 * i + 0),
      b_i_9 => Tape_DI(9)(N + 3 * i + 0),
      b_i_10 => Tape_DI(10)(N + 3 * i + 0),
      b_i_11 => Tape_DI(11)(N + 3 * i + 0),
      b_i_12 => Tape_DI(12)(N + 3 * i + 0),
      b_i_13 => Tape_DI(13)(N + 3 * i + 0),
      b_i_14 => Tape_DI(14)(N + 3 * i + 0),
      b_i_15 => Tape_last_DI(3 * i + 0),
      and_helper_0 => Tape_DI(0)(3 * i + 0),
      and_helper_1 => Tape_DI(1)(3 * i + 0),
      and_helper_2 => Tape_DI(2)(3 * i + 0),
      and_helper_3 => Tape_DI(3)(3 * i + 0),
      and_helper_4 => Tape_DI(4)(3 * i + 0),
      and_helper_5 => Tape_DI(5)(3 * i + 0),
      and_helper_6 => Tape_DI(6)(3 * i + 0),
      and_helper_7 => Tape_DI(7)(3 * i + 0),
      and_helper_8 => Tape_DI(8)(3 * i + 0),
      and_helper_9 => Tape_DI(9)(3 * i + 0),
      and_helper_10 => Tape_DI(10)(3 * i + 0),
      and_helper_11 => Tape_DI(11)(3 * i + 0),
      and_helper_12 => Tape_DI(12)(3 * i + 0),
      and_helper_13 => Tape_DI(13)(3 * i + 0),
      and_helper_14 => Tape_DI(14)(3 * i + 0),
      -- and_helper_15 => Aux_DI(3 * i + 0),
      msgs_0 => msgs_out(0)(3 * i + 0),
      msgs_1 => msgs_out(1)(3 * i + 0),
      msgs_2 => msgs_out(2)(3 * i + 0),
      msgs_3 => msgs_out(3)(3 * i + 0),
      msgs_4 => msgs_out(4)(3 * i + 0),
      msgs_5 => msgs_out(5)(3 * i + 0),
      msgs_6 => msgs_out(6)(3 * i + 0),
      msgs_7 => msgs_out(7)(3 * i + 0),
      msgs_8 => msgs_out(8)(3 * i + 0),
      msgs_9 => msgs_out(9)(3 * i + 0),
      msgs_10 => msgs_out(10)(3 * i + 0),
      msgs_11 => msgs_out(11)(3 * i + 0),
      msgs_12 => msgs_out(12)(3 * i + 0),
      msgs_13 => msgs_out(13)(3 * i + 0),
      msgs_14 => msgs_out(14)(3 * i + 0),
      msgs_15 => msgs_out(15)(3 * i + 0),
      --and_helper => and_helper(3 * i + 0),
      aux => aux_out(3 * i + 0)
    );

    Aux_DO(3 * i + 0) <= aux_out(3 * i + 0);
    Aux_DO(3 * i + 1) <= aux_out(3 * i + 1);
    Aux_DO(3 * i + 2) <= aux_out(3 * i + 2);
    Msgs : for j in 0 to (P - 1) generate
      Msgs_DO(j)(3 * i + 0) <= msgs_out(j)(3 * i + 0);
      Msgs_DO(j)(3 * i + 1) <= msgs_out(j)(3 * i + 1);
      Msgs_DO(j)(3 * i + 2) <= msgs_out(j)(3 * i + 2);
    end generate;
--      Msgs_DO(P - 1)(3 * i + 0) <= msgs_out(P - 1)(3 * i + 0) xor aux_out(3 * i + 0);
--      Msgs_DO(P - 1)(3 * i + 1) <= msgs_out(P - 1)(3 * i + 1) xor aux_out(3 * i + 1);
--      Msgs_DO(P - 1)(3 * i + 2) <= msgs_out(P - 1)(3 * i + 2) xor aux_out(3 * i + 2);
      State_in_DO(3 * i + 0) <= lambda_a_array(i);
      State_in_DO(3 * i + 1) <= lambda_b_array(i);
      State_in_DO(3 * i + 2) <= lambda_c_array(i);
    end generate;

end behavorial;
