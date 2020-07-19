--
--  File Name:         FifoFillPkg_slv.vhd
--  Design Unit Name:  FifoFillPkg_slv
--  Revision:          STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis          email:  jim@synthworks.com
--
--
--  Description:
--    Fill and check data in burst fifos 
--    Defines type ScoreBoardPType
--    Defines methods for putting values the scoreboard
--
--  Developed for:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        11898 SW 128th Ave.  Tigard, Or  97223
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version      Description
--    05/2020   2020.05     Initial revision
--
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2020 by SynthWorks Design Inc.  
--  
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--  
--      https://www.apache.org/licenses/LICENSE-2.0
--  
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.
--  


use std.textio.all ;

library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;
  use ieee.numeric_std_unsigned.all ;
  
library osvvm ; 
  context osvvm.OsvvmContext ;   
  use osvvm.ScoreboardPkg_slv.all ;

--!! This should be generic package.   

package FifoFillPkg_slv is
  ------------------------------------------------------------
  procedure PushBurst (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Bytes     : in    integer_vector ;
    constant DataWidth : in    integer := 8
  ) ;

  ------------------------------------------------------------
  procedure PushBurstIncrement (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) ;
  
  ------------------------------------------------------------
  procedure PushBurstRandom (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) ;
  
  ------------------------------------------------------------
  procedure PopBurst (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    variable Bytes     : out   integer_vector ;
    constant DataWidth : in    integer := 8
  ) ;

  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Bytes     : in    integer_vector ;
    constant DataWidth : in    integer := 8
  ) ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) ;
  
  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) ;

end FifoFillPkg_slv ;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package body FifoFillPkg_slv is

  ------------------------------------------------------------
  procedure PushBurst (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Bytes     : in    integer_vector ;
    constant DataWidth : in    integer := 8
  ) is
  begin
    for i in Bytes'range loop 
      if Bytes(i) < 0 then 
        Fifo.Push((DataWidth downto 1 => 'U')) ;
      else 
        Fifo.Push(to_slv(Bytes(i), DataWidth)) ;
      end if ;
    end loop ;
  end procedure PushBurst ;

  ------------------------------------------------------------
  procedure PushBurstIncrement (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) is
  begin
    for i in Start to ByteCount+Start-1 loop 
      Fifo.Push(to_slv(i mod (2**DataWidth), DataWidth)) ;
    end loop ;
  end procedure PushBurstIncrement ;
  
  ------------------------------------------------------------
  procedure PushBurstRandom (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) is
    variable RV : RandomPType ; 
    variable Junk : integer ; 
    constant MOD_VAL : integer := 2**DataWidth  ; 
  begin
    -- Initialize seed and toss first random value  
    RV.InitSeed(Start) ;
    Junk := RV.RandInt(0, MOD_VAL-1) ;
    
    Fifo.Push(to_slv(Start mod MOD_VAL, DataWidth)) ;
    
    for i in 2 to ByteCount loop 
      Fifo.Push(RV.RandSlv(0, MOD_VAL-1, DataWidth)) ;
    end loop ;
  end procedure PushBurstRandom ;
  
  ------------------------------------------------------------
  procedure PopBurst (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    variable Bytes     : out   integer_vector ;
    constant DataWidth : in    integer := 8
  ) is
  begin
    for i in Bytes'range loop 
      if Bytes(i) < 0 then 
        Fifo.Push((DataWidth downto 1 => 'U')) ;
      else 
        Fifo.Push(to_slv(Bytes(i), DataWidth)) ;
      end if ;
    end loop ;
  end procedure PopBurst ;

  ------------------------------------------------------------
  procedure CheckBurst (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Bytes     : in    integer_vector ;
    constant DataWidth : in    integer := 8
  ) is
  begin
    for i in Bytes'range loop 
      if Bytes(i) < 0 then 
        Fifo.Check((DataWidth downto 1 => 'U')) ;
      else 
        Fifo.Check(to_slv(Bytes(i), DataWidth)) ;
      end if ;
    end loop ;
  end procedure CheckBurst ;

  ------------------------------------------------------------
  procedure CheckBurstIncrement (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) is
  begin
    for i in Start to ByteCount+Start-1 loop 
      Fifo.Check(to_slv(i mod (2**DataWidth), DataWidth)) ;
    end loop ;
  end procedure CheckBurstIncrement ;
  
  ------------------------------------------------------------
  procedure CheckBurstRandom (
  ------------------------------------------------------------
    variable Fifo      : inout ScoreboardPType ;
    constant Start     : in    integer ;
    constant ByteCount : in    integer ;
    constant DataWidth : in    integer := 8
  ) is
    variable RV : RandomPType ; 
    variable Junk : integer; 
    constant MOD_VAL : integer := 2**DataWidth  ; 
  begin
    -- Initialize seed and toss first random value 
    RV.InitSeed(Start) ;
    Junk := RV.RandInt(0, MOD_VAL-1) ;
    
    Fifo.Check(to_slv(Start mod MOD_VAL, DataWidth)) ;
    
    for i in 2 to ByteCount loop 
      Fifo.Check(RV.RandSlv(0, MOD_VAL-1, DataWidth)) ;
    end loop ;
  end procedure CheckBurstRandom ;
    
end FifoFillPkg_slv ;