--------------------------------------------------------------------------------
----                                                                        ----
---- This file is part of the yaVGA project                                 ----
---- http://www.opencores.org/?do=project&who=yavga                         ----
----                                                                        ----
---- Description                                                            ----
---- Implementation of yaVGA IP core                                        ----
----                                                                        ----
---- To Do:                                                                 ----
----                                                                        ----
----                                                                        ----
---- Author(s):                                                             ----
---- Sandro Amato, sdroamt@netscape.net                                     ----
----                                                                        ----
--------------------------------------------------------------------------------
----                                                                        ----
---- Copyright (c) 2009, Sandro Amato                                       ----
---- All rights reserved.                                                   ----
----                                                                        ----
---- Redistribution  and  use in  source  and binary forms, with or without ----
---- modification,  are  permitted  provided that  the following conditions ----
---- are met:                                                               ----
----                                                                        ----
----     * Redistributions  of  source  code  must  retain the above        ----
----       copyright   notice,  this  list  of  conditions  and  the        ----
----       following disclaimer.                                            ----
----     * Redistributions  in  binary form must reproduce the above        ----
----       copyright   notice,  this  list  of  conditions  and  the        ----
----       following  disclaimer in  the documentation and/or  other        ----
----       materials provided with the distribution.                        ----
----     * Neither  the  name  of  SANDRO AMATO nor the names of its        ----
----       contributors may be used to  endorse or  promote products        ----
----       derived from this software without specific prior written        ----
----       permission.                                                      ----
----                                                                        ----
---- THIS SOFTWARE IS PROVIDED  BY THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS ----
---- "AS IS"  AND  ANY EXPRESS OR  IMPLIED  WARRANTIES, INCLUDING,  BUT NOT ----
---- LIMITED  TO, THE  IMPLIED  WARRANTIES  OF MERCHANTABILITY  AND FITNESS ----
---- FOR  A PARTICULAR  PURPOSE  ARE  DISCLAIMED. IN  NO  EVENT  SHALL  THE ----
---- COPYRIGHT  OWNER  OR CONTRIBUTORS  BE LIABLE FOR ANY DIRECT, INDIRECT, ----
---- INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, ----
---- BUT  NOT LIMITED  TO,  PROCUREMENT OF  SUBSTITUTE  GOODS  OR SERVICES; ----
---- LOSS  OF  USE,  DATA,  OR PROFITS;  OR  BUSINESS INTERRUPTION) HOWEVER ----
---- CAUSED  AND  ON  ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT, STRICT ----
---- LIABILITY,  OR  TORT  (INCLUDING  NEGLIGENCE  OR OTHERWISE) ARISING IN ----
---- ANY  WAY OUT  OF THE  USE  OF  THIS  SOFTWARE,  EVEN IF ADVISED OF THE ----
---- POSSIBILITY OF SUCH DAMAGE.                                            ----
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

use work.yavga_pkg.all;

-- Uncomment the following lines to use the declarations that are
-- provided for instantiating Xilinx primitive components.
library UNISIM;
use UNISIM.VComponents.all;

entity chars_RAM is
  port (
    i_clock_rw : in  std_logic;         -- Write Clock
    i_EN_rw    : in  std_logic;         -- Write RAM Enable Input
    i_WE_rw    : in  std_logic_vector(c_CHR_WE_BUS_W - 1 downto 0);  -- Write Enable Input
    i_ADDR_rw  : in  std_logic_vector(10 downto 0);  -- Write 11-bit Address Input
    i_DI_rw    : in  std_logic_vector(31 downto 0);  -- Write 32-bit Data Input
    o_DI_rw    : out std_logic_vector(31 downto 0);  -- Write 32-bit Data Input

    i_SSR : in std_logic;               -- Synchronous Set/Reset Input

    i_clock_r : in  std_logic;          -- Read Clock
    i_EN_r    : in  std_logic;
    i_ADDR_r  : in  std_logic_vector(12 downto 0);  -- Read 13-bit Address Input
    o_DO_r    : out std_logic_vector(7 downto 0)    -- Read 8-bit Data Output
    );
end chars_RAM;

architecture rtl of chars_RAM is
  signal s0_DO_r : std_logic_vector(7 downto 0);
  signal s1_DO_r : std_logic_vector(7 downto 0);
  signal s2_DO_r : std_logic_vector(7 downto 0);
  signal s3_DO_r : std_logic_vector(7 downto 0);

begin

  u0_chars_ram : RAMB16_S9_S9
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",   --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      INIT_A       => B"000000000",  --  Value of output RAM registers at startup
      SRVAL_A      => B"000000000",     --  Ouput value upon SSR assertion
      WRITE_MODE_B => "WRITE_FIRST",   --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      INIT_B       => B"000000000",  --  Value of output RAM registers at startup
      SRVAL_B      => B"000000000",     --  Ouput value upon SSR assertion
      --
      INIT_00      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_01      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_02      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_03      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_05      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_07      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_09      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F      => X"0000000000000000000000000000000000000000000000000000000000000000"
      )
    port map(
      -- read
      DIA   => (others => '0'),         -- 2-bit Data Input
      DIPA  => (others => '0'),
      ENA   => i_EN_r,                  -- RAM Enable Input
      WEA   => '0',                     -- Write Enable Input
      SSRA  => i_SSR,                   -- Synchronous Set/Reset Input
      CLKA  => i_clock_r,               -- Clock
      ADDRA => i_ADDR_r(12 downto 2),   -- 11-bit Address Input
      DOA   => s0_DO_r,                 -- 8-bit Data Output
      DOPA  => open,

      -- read/write
      DIB   => i_DI_rw(7 downto 0),     -- 8-bit Data Input
      DIPB  => (others => '0'),
      ENB   => i_EN_rw,                 -- RAM Enable Input
      WEB   => i_WE_rw(0),              -- Write Enable Input
      SSRB  => i_SSR,                   -- Synchronous Set/Reset Input
      CLKB  => i_clock_rw,              -- Clock
      ADDRB => i_ADDR_rw,               -- 11-bit Address Input
      DOB   => o_DI_rw(7 downto 0),     -- 8-bit Data Input
      DOPB  => open
      );

  u1_chars_ram : RAMB16_S9_S9
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",   --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      INIT_A       => B"000000000",  --  Value of output RAM registers at startup
      SRVAL_A      => B"000000000",     --  Ouput value upon SSR assertion
      WRITE_MODE_B => "WRITE_FIRST",   --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      INIT_B       => B"000000000",  --  Value of output RAM registers at startup
      SRVAL_B      => B"000000000",     --  Ouput value upon SSR assertion
      --
      INIT_00      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_01      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_02      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_03      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_05      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_07      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_09      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F      => X"0000000000000000000000000000000000000000000000000000000000000000"
      )
    port map(
      -- read
      DIA   => (others => '0'),         -- 2-bit Data Input
      DIPA  => (others => '0'),
      ENA   => i_EN_r,                  -- RAM Enable Input
      WEA   => '0',                     -- Write Enable Input
      SSRA  => i_SSR,                   -- Synchronous Set/Reset Input
      CLKA  => i_clock_r,               -- Clock
      ADDRA => i_ADDR_r(12 downto 2),   -- 11-bit Address Input
      DOA   => s1_DO_r,                 -- 8-bit Data Output
      DOPA  => open,

      -- read/write
      DIB   => i_DI_rw(15 downto 8),    -- 8-bit Data Input
      DIPB  => (others => '0'),
      ENB   => i_EN_rw,                 -- RAM Enable Input
      WEB   => i_WE_rw(1),              -- Write Enable Input
      SSRB  => i_SSR,                   -- Synchronous Set/Reset Input
      CLKB  => i_clock_rw,              -- Clock
      ADDRB => i_ADDR_rw,               -- 11-bit Address Input
      DOB   => o_DI_rw(15 downto 8),    -- 8-bit Data Input
      DOPB  => open
      );

  u2_chars_ram : RAMB16_S9_S9
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",   --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      INIT_A       => B"000000000",  --  Value of output RAM registers at startup
      SRVAL_A      => B"000000000",     --  Ouput value upon SSR assertion
      WRITE_MODE_B => "WRITE_FIRST",   --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      INIT_B       => B"000000000",  --  Value of output RAM registers at startup
      SRVAL_B      => B"000000000",     --  Ouput value upon SSR assertion
      --
      INIT_00      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_01      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_02      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_03      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_05      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_07      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_09      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F      => X"0000000000000000000000000000000000000000000000000000000000000000"
      )
    port map(
      -- read
      DIA   => (others => '0'),         -- 2-bit Data Input
      DIPA  => (others => '0'),
      ENA   => i_EN_r,                  -- RAM Enable Input
      WEA   => '0',                     -- Write Enable Input
      SSRA  => i_SSR,                   -- Synchronous Set/Reset Input
      CLKA  => i_clock_r,               -- Clock
      ADDRA => i_ADDR_r(12 downto 2),   -- 11-bit Address Input
      DOA   => s2_DO_r,                 -- 8-bit Data Output
      DOPA  => open,

      -- read/write
      DIB   => i_DI_rw(23 downto 16),   -- 8-bit Data Input
      DIPB  => (others => '0'),
      ENB   => i_EN_rw,                 -- RAM Enable Input
      WEB   => i_WE_rw(2),              -- Write Enable Input
      SSRB  => i_SSR,                   -- Synchronous Set/Reset Input
      CLKB  => i_clock_rw,              -- Clock
      ADDRB => i_ADDR_rw,               -- 11-bit Address Input
      DOB   => o_DI_rw(23 downto 16),   -- 8-bit Data Input
      DOPB  => open
      );

  u3_chars_ram : RAMB16_S9_S9
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",   --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      INIT_A       => B"000000000",  --  Value of output RAM registers at startup
      SRVAL_A      => B"000000000",     --  Ouput value upon SSR assertion
      WRITE_MODE_B => "WRITE_FIRST",   --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      INIT_B       => B"000000000",  --  Value of output RAM registers at startup
      SRVAL_B      => B"000000000",     --  Ouput value upon SSR assertion
      --
      INIT_00      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_01      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_02      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_03      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_05      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_07      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_09      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E      => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F      => X"0000000000000000000000000000000000000000000000000000000000000000"
      )
    port map(
      -- read
      DIA   => (others => '0'),         -- 2-bit Data Input
      DIPA  => (others => '0'),
      ENA   => i_EN_r,                  -- RAM Enable Input
      WEA   => '0',                     -- Write Enable Input
      SSRA  => i_SSR,                   -- Synchronous Set/Reset Input
      CLKA  => i_clock_r,               -- Clock
      ADDRA => i_ADDR_r(12 downto 2),   -- 11-bit Address Input
      DOA   => s3_DO_r,                 -- 8-bit Data Output
      DOPA  => open,

      -- read/write
      DIB   => i_DI_rw(31 downto 24),   -- 8-bit Data Input
      DIPB  => (others => '0'),
      ENB   => i_EN_rw,                 -- RAM Enable Input
      WEB   => i_WE_rw(3),              -- Write Enable Input
      SSRB  => i_SSR,                   -- Synchronous Set/Reset Input
      CLKB  => i_clock_rw,              -- Clock
      ADDRB => i_ADDR_rw,               -- 11-bit Address Input
      DOB   => o_DI_rw(31 downto 24),   -- 8-bit Data Input
      DOPB  => open
      );

  o_DO_r <= s0_DO_r when i_ADDR_r(1 downto 0) = "11" else
            s1_DO_r when i_ADDR_r(1 downto 0) = "10" else
            s2_DO_r when i_ADDR_r(1 downto 0) = "01" else
            s3_DO_r when i_ADDR_r(1 downto 0) = "00" else
            (others => 'X');

end rtl;
