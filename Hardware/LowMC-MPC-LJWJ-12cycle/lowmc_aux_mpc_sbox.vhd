library work;
use work.lowmc_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
entity lowmc_aux_mpc_sbox is
  port(
    -- Input signals
    signal State_out_DI  : in std_logic_vector(N - 1 downto 0);
    signal Tape_DI       : in N_2_ARR;
    signal Tape_last_DI  : in std_logic_vector(N - 1 downto 0);
    -- Output signals
    signal Aux_DO        : out std_logic_vector(N - 1 downto 0)
  );
end entity;

architecture behavorial of lowmc_aux_mpc_sbox is
  signal aux_out : std_logic_vector(N - 1 downto 0);
  signal fresh_output_mask_in : std_logic_vector(N - 1 downto 0);

  signal and_helper : std_logic_vector(N - 1 downto 0);
  component aux_mpc_and is
    port(
      -- Input signals
      signal fresh_output_mask : in std_logic;
      signal and_helper : std_logic;
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
      -- Output signals
      signal aux : out std_logic
    );
  end component;
begin

  SBOX_GEN : for i in 0 to S - 1 generate
    and_helper(3 * i + 0) <= Tape_DI(P - 2 - (0))(3 * i + 0) xor Tape_DI(P - 2 - (1))(3 * i + 0) xor Tape_DI(P - 2 - (2))(3 * i + 0) xor Tape_DI(P - 2 - (3))(3 * i + 0) xor Tape_DI(P - 2 - (4))(3 * i + 0) xor Tape_DI(P - 2 - (5))(3 * i + 0) xor Tape_DI(P - 2 - (6))(3 * i + 0) xor Tape_DI(P - 2 - (7))(3 * i + 0) xor Tape_DI(P - 2 - (8))(3 * i + 0) xor Tape_DI(P - 2 - (9))(3 * i + 0) xor Tape_DI(P - 2 - (10))(3 * i + 0) xor Tape_DI(P - 2 - (11))(3 * i + 0) xor Tape_DI(P - 2 - (12))(3 * i + 0) xor Tape_DI(P - 2 - (13))(3 * i + 0) xor Tape_DI(P - 2 - (14))(3 * i + 0);
    and_helper(3 * i + 1) <= Tape_DI(P - 2 - (0))(3 * i + 1) xor Tape_DI(P - 2 - (1))(3 * i + 1) xor Tape_DI(P - 2 - (2))(3 * i + 1) xor Tape_DI(P - 2 - (3))(3 * i + 1) xor Tape_DI(P - 2 - (4))(3 * i + 1) xor Tape_DI(P - 2 - (5))(3 * i + 1) xor Tape_DI(P - 2 - (6))(3 * i + 1) xor Tape_DI(P - 2 - (7))(3 * i + 1) xor Tape_DI(P - 2 - (8))(3 * i + 1) xor Tape_DI(P - 2 - (9))(3 * i + 1) xor Tape_DI(P - 2 - (10))(3 * i + 1) xor Tape_DI(P - 2 - (11))(3 * i + 1) xor Tape_DI(P - 2 - (12))(3 * i + 1) xor Tape_DI(P - 2 - (13))(3 * i + 1) xor Tape_DI(P - 2 - (14))(3 * i + 1);
    and_helper(3 * i + 2) <= Tape_DI(P - 2 - (0))(3 * i + 2) xor Tape_DI(P - 2 - (1))(3 * i + 2) xor Tape_DI(P - 2 - (2))(3 * i + 2) xor Tape_DI(P - 2 - (3))(3 * i + 2) xor Tape_DI(P - 2 - (4))(3 * i + 2) xor Tape_DI(P - 2 - (5))(3 * i + 2) xor Tape_DI(P - 2 - (6))(3 * i + 2) xor Tape_DI(P - 2 - (7))(3 * i + 2) xor Tape_DI(P - 2 - (8))(3 * i + 2) xor Tape_DI(P - 2 - (9))(3 * i + 2) xor Tape_DI(P - 2 - (10))(3 * i + 2) xor Tape_DI(P - 2 - (11))(3 * i + 2) xor Tape_DI(P - 2 - (12))(3 * i + 2) xor Tape_DI(P - 2 - (13))(3 * i + 2) xor Tape_DI(P - 2 - (14))(3 * i + 2);
    -- ab
    fresh_output_mask_in(3 * i + 2) <= State_out_DI(3 * i + 2) xor Tape_DI(0)(N + 3 * i + 2) xor Tape_DI(1)(N + 3 * i + 2) xor Tape_DI(2)(N + 3 * i + 2) xor Tape_DI(3)(N + 3 * i + 2) xor Tape_DI(4)(N + 3 * i + 2) xor Tape_DI(5)(N + 3 * i + 2) xor Tape_DI(6)(N + 3 * i + 2) xor Tape_DI(7)(N + 3 * i + 2) xor Tape_DI(8)(N + 3 * i + 2) xor Tape_DI(9)(N + 3 * i + 2) xor Tape_DI(10)(N + 3 * i + 2) xor Tape_DI(11)(N + 3 * i + 2) xor Tape_DI(12)(N + 3 * i + 2) xor Tape_DI(13)(N + 3 * i + 2) xor Tape_DI(14)(N + 3 * i + 2) xor Tape_last_DI(3 * i + 2) xor Tape_DI(0)(N + 3 * i + 1) xor Tape_DI(1)(N + 3 * i + 1) xor Tape_DI(2)(N + 3 * i + 1) xor Tape_DI(3)(N + 3 * i + 1) xor Tape_DI(4)(N + 3 * i + 1) xor Tape_DI(5)(N + 3 * i + 1) xor Tape_DI(6)(N + 3 * i + 1) xor Tape_DI(7)(N + 3 * i + 1) xor Tape_DI(8)(N + 3 * i + 1) xor Tape_DI(9)(N + 3 * i + 1) xor Tape_DI(10)(N + 3 * i + 1) xor Tape_DI(11)(N + 3 * i + 1) xor Tape_DI(12)(N + 3 * i + 1) xor Tape_DI(13)(N + 3 * i + 1) xor Tape_DI(14)(N + 3 * i + 1) xor Tape_last_DI(3 * i + 1) xor Tape_DI(0)(N + 3 * i + 0) xor Tape_DI(1)(N + 3 * i + 0) xor Tape_DI(2)(N + 3 * i + 0) xor Tape_DI(3)(N + 3 * i + 0) xor Tape_DI(4)(N + 3 * i + 0) xor Tape_DI(5)(N + 3 * i + 0) xor Tape_DI(6)(N + 3 * i + 0) xor Tape_DI(7)(N + 3 * i + 0) xor Tape_DI(8)(N + 3 * i + 0) xor Tape_DI(9)(N + 3 * i + 0) xor Tape_DI(10)(N + 3 * i + 0) xor Tape_DI(11)(N + 3 * i + 0) xor Tape_DI(12)(N + 3 * i + 0) xor Tape_DI(13)(N + 3 * i + 0) xor Tape_DI(14)(N + 3 * i + 0) xor Tape_last_DI(3 * i + 0);
    -- bc
    fresh_output_mask_in(3 * i + 1) <= State_out_DI(3 * i + 0) xor Tape_DI(0)(N + 3 * i + 0) xor Tape_DI(1)(N + 3 * i + 0) xor Tape_DI(2)(N + 3 * i + 0) xor Tape_DI(3)(N + 3 * i + 0) xor Tape_DI(4)(N + 3 * i + 0) xor Tape_DI(5)(N + 3 * i + 0) xor Tape_DI(6)(N + 3 * i + 0) xor Tape_DI(7)(N + 3 * i + 0) xor Tape_DI(8)(N + 3 * i + 0) xor Tape_DI(9)(N + 3 * i + 0) xor Tape_DI(10)(N + 3 * i + 0) xor Tape_DI(11)(N + 3 * i + 0) xor Tape_DI(12)(N + 3 * i + 0) xor Tape_DI(13)(N + 3 * i + 0) xor Tape_DI(14)(N + 3 * i + 0) xor Tape_last_DI(3 * i + 0);
    -- ca
    fresh_output_mask_in(3 * i + 0) <= State_out_DI(3 * i + 1) xor Tape_DI(0)(N + 3 * i + 1) xor Tape_DI(1)(N + 3 * i + 1) xor Tape_DI(2)(N + 3 * i + 1) xor Tape_DI(3)(N + 3 * i + 1) xor Tape_DI(4)(N + 3 * i + 1) xor Tape_DI(5)(N + 3 * i + 1) xor Tape_DI(6)(N + 3 * i + 1) xor Tape_DI(7)(N + 3 * i + 1) xor Tape_DI(8)(N + 3 * i + 1) xor Tape_DI(9)(N + 3 * i + 1) xor Tape_DI(10)(N + 3 * i + 1) xor Tape_DI(11)(N + 3 * i + 1) xor Tape_DI(12)(N + 3 * i + 1) xor Tape_DI(13)(N + 3 * i + 1) xor Tape_DI(14)(N + 3 * i + 1) xor Tape_last_DI(3 * i + 1) xor Tape_DI(0)(N + 3 * i + 0) xor Tape_DI(1)(N + 3 * i + 0) xor Tape_DI(2)(N + 3 * i + 0) xor Tape_DI(3)(N + 3 * i + 0) xor Tape_DI(4)(N + 3 * i + 0) xor Tape_DI(5)(N + 3 * i + 0) xor Tape_DI(6)(N + 3 * i + 0) xor Tape_DI(7)(N + 3 * i + 0) xor Tape_DI(8)(N + 3 * i + 0) xor Tape_DI(9)(N + 3 * i + 0) xor Tape_DI(10)(N + 3 * i + 0) xor Tape_DI(11)(N + 3 * i + 0) xor Tape_DI(12)(N + 3 * i + 0) xor Tape_DI(13)(N + 3 * i + 0) xor Tape_DI(14)(N + 3 * i + 0) xor Tape_last_DI(3 * i + 0);
    AB : aux_mpc_and
    port map(
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
      and_helper => and_helper(3 * i + 2),
      aux => aux_out(3 * i + 2)
    );
    BC : aux_mpc_and
    port map(
      fresh_output_mask => fresh_output_mask_in(3 * i + 1),
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
      and_helper => and_helper(3 * i + 1),
      aux => aux_out(3 * i + 1)
    );
    CA : aux_mpc_and
    port map(
      fresh_output_mask => fresh_output_mask_in(3 * i + 0),
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
      and_helper => and_helper(3 * i + 0),
      aux => aux_out(3 * i + 0)
    );

    Aux_DO(3 * i + 0) <= aux_out(3 * i + 0);
    Aux_DO(3 * i + 1) <= aux_out(3 * i + 1);
    Aux_DO(3 * i + 2) <= aux_out(3 * i + 2);
  end generate;

end behavorial;
