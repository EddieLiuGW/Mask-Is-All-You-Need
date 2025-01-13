library work;
use work.lowmc_pkg.all;

library ieee;
use ieee.std_logic_1164.all;

entity hybrid_mpc_and is
  port(
    -- Input signals
      signal fresh_output_mask : in std_logic;
      -- signal and_helper : in std_logic;
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
end entity;

architecture behavorial of hybrid_mpc_and is
signal hat_a, hat_b, and_helper : std_logic;
begin

  hat_a <= a xor lambda_a;
  hat_b <= b xor lambda_b;

  and_helper <= and_helper_0 xor and_helper_1 xor and_helper_2 xor and_helper_3 xor and_helper_4 xor and_helper_5 xor and_helper_6 xor and_helper_7 xor and_helper_8 xor and_helper_9 xor and_helper_10 xor and_helper_11 xor and_helper_12 xor and_helper_13 xor and_helper_14;

  aux <= (lambda_a and lambda_b) xor and_helper xor fresh_output_mask;
  msgs_0 <= (hat_a and b_i_0) xor (hat_b and a_i_0) xor and_helper_0;  --s_shares = (extend(a) & mask_b) ^ (extend(b) & mask_a) ^ and_helper;;
  msgs_1 <= (hat_a and b_i_1) xor (hat_b and a_i_1) xor and_helper_1;
  msgs_2 <= (hat_a and b_i_2) xor (hat_b and a_i_2) xor and_helper_2;
  msgs_3 <= (hat_a and b_i_3) xor (hat_b and a_i_3) xor and_helper_3;
  msgs_4 <= (hat_a and b_i_4) xor (hat_b and a_i_4) xor and_helper_4;
  msgs_5 <= (hat_a and b_i_5) xor (hat_b and a_i_5) xor and_helper_5;
  msgs_6 <= (hat_a and b_i_6) xor (hat_b and a_i_6) xor and_helper_6;
  msgs_7 <= (hat_a and b_i_7) xor (hat_b and a_i_7) xor and_helper_7;
  msgs_8 <= (hat_a and b_i_8) xor (hat_b and a_i_8) xor and_helper_8;
  msgs_9 <= (hat_a and b_i_9) xor (hat_b and a_i_9) xor and_helper_9;
  msgs_10 <= (hat_a and b_i_10) xor (hat_b and a_i_10) xor and_helper_10;
  msgs_11 <= (hat_a and b_i_11) xor (hat_b and a_i_11) xor and_helper_11;
  msgs_12 <= (hat_a and b_i_12) xor (hat_b and a_i_12) xor and_helper_12;
  msgs_13 <= (hat_a and b_i_13) xor (hat_b and a_i_13) xor and_helper_13;
  msgs_14 <= (hat_a and b_i_14) xor (hat_b and a_i_14) xor and_helper_14;
  msgs_15 <= (hat_a and b_i_15) xor (hat_b and a_i_15);
end behavorial;