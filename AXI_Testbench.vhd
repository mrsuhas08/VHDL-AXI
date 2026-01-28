----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2026 17:32:56
-- Design Name: 
-- Module Name: axi_testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity axi_testbench is
--  Port ( );
end axi_testbench;

architecture Behavioral of axi_testbench is
    SIGNAL ACLK       :   std_logic                     :=  '0';
    SIGNAL ARST       :   std_logic                     :=  '0';
    
--    SIGNAL START    :   std_logic   :=  '0';
        
    SIGNAL M_WADDR    :   std_logic_vector(31 downto 0) :=  (OTHERS => '0');
    SIGNAL M_RADDR    :   std_logic_vector(31 downto 0) :=  (OTHERS => '0');
     
    SIGNAL M_WDATA    :   std_logic_vector(31 downto 0) :=  (OTHERS => '0');
    SIGNAL M_RDATA    :   std_logic_vector(31 downto 0);
    
begin

    AXI_TOP :   ENTITY  WORK.AXI_TOPMODULE
        PORT MAP(ACLK   =>  ACLK,
                 ARST   =>  ARST,
--                 START  =>  START,
                 M_WADDR=>  M_WADDR,
                 M_RADDR=>  M_RADDR,
                 M_WDATA=>  M_WDATA,
                 M_RDATA=>  M_RDATA
                 );
    
    process is
    begin
        wait for 5 ns;
        aclk    <=  NOT aclk;
    end process;
    
    process is
    begin
        arst    <=  '0';
        wait for 30 ns;
        arst    <=  '1';
        WAIT FOR 5 NS;
--        START   <=  '1';
        m_waddr <=  x"0000_0001";
        m_wdata <=  x"0000_00FF";
        wait for 70 NS;
        m_waddr <=  x"0000_0002";
        m_wdata <=  x"0000_00EE";
        wait for 60 NS;
        m_waddr <=  x"0000_0003";
        m_wdata <=  x"0000_00DD";
        m_raddr <=  x"0000_0001";
        WAIT FOR 60 NS;
        m_waddr <=  x"0000_0004";
        m_wdata <=  x"0000_00CC";
        m_raddr <=  x"0000_0002";
        WAIT FOR 60 NS;
        m_Raddr <=  x"0000_0003";
        WAIT FOR 60 NS;
        m_RADDR <=  x"0000_0004";
        WAIT FOR 80 NS;
        finish;
    end process;
    
end Behavioral;
