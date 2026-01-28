----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2026 11:03:30
-- Design Name: 
-- Module Name: axi_master - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity axi_master is
    Port(ACLK       :   IN std_logic;
         ARST       :   IN std_logic;
         
         -- FROM TOP_MODULE
         M_WADDR    :   IN std_logic_vector(31 downto 0);
         M_RADDR    :   IN std_logic_vector(31 downto 0);
         
         M_WDATA    :   IN std_logic_vector(31 downto 0);
         
         M_RDATA    :   OUT std_logic_vector(31 downto 0);
--         VALID      :   OUT std_logic;
         
         -- INSIDE MASTER
         
         -- WRITE ADDRESS CHANNEL
         AWADDR     :   OUT std_logic_vector(31 downto 0);
         AWVALID    :   OUT std_logic;
         AWREADY    :   IN std_logic;
         
         -- WRITE DATA CHANNEL
         WDATA      :   OUT std_logic_vector(31 downto 0);
         wVALID     :   OUT std_logic;
         wREADY     :   IN std_logic;
         
         -- WRITE RESPONSE CHANNEL
         BRESP      :   IN std_logic_vector(1 downto 0);
         BVALID     :   IN std_logic;
         BREADY     :   OUT std_logic;
         
         -- READ ADDRESS CHANNEL
         ARADDR     :   OUT std_logic_vector(31 downto 0);
         ARVALID    :   OUT std_logic;
         ARREADY    :   IN std_logic;
         
         -- READ DATA CHANNEL
         RDATA      :   IN std_logic_vector(31 downto 0);
         RRESP      :   IN std_logic_vector(1 downto 0);
         RVALID     :   IN std_logic;
         RREADY     :   OUT std_logic);
         
end axi_master;

architecture Behavioral of axi_master is
    
--    SIGNAL RESP         :   std_logic_vector(1 downto 0)    :=  "ZZ";

    SIGNAL AWVALID_REG  :   std_logic                       :=  '0';
    SIGNAL WVALID_REG   :   std_logic                       :=  '0';
    SIGNAL ARVALID_REG  :   std_logic                       :=  '0';
    
    SIGNAL RREADY_REG   :   std_logic                       :=  '0';
    SIGNAL BREADY_REG   :   std_logic                       :=  '0';
    
    TYPE W_FSM IS (W_IDLE, W_ADDR, W_DATA, W_RESP);
    SIGNAL W_STATE : W_FSM := W_IDLE;
    
    TYPE R_FSM IS (R_IDLE, R_ADDR, R_DATA);
    SIGNAL R_STATE : R_FSM := R_IDLE;

begin
    
    ---- WRITE ----------------------------------------------------------------
    
    PROCESS (ACLK,ARST)
    BEGIN
        IF ARST = '0' THEN
            AWADDR  <=  (OTHERS => '0');
            WDATA   <=  (OTHERS => '0');
            AWVALID_REG <=  '0';
            WVALID_REG  <=  '0';
            BREADY_REG  <=  '0';
            
        ELSIF RISING_EDGE(ACLK) THEN
            
            CASE W_STATE IS
                WHEN W_IDLE =>
                    AWVALID_REG <=  '0';
                    WVALID_REG  <=  '0';
                    BREADY_REG  <=  '0';
                    W_STATE     <=  W_ADDR;
                    
                WHEN W_ADDR =>
                    
                    AWADDR      <=  M_WADDR;
                    AWVALID_REG <=  '1';
                    
                    IF AWREADY = '1' AND AWVALID_REG = '1' THEN
                        AWVALID_REG <=  '0';
--                        WVALID_REG  <=  '1';
                        W_STATE     <=  W_DATA;
                    END IF;
                    
                WHEN W_DATA =>
                    
                    WDATA       <=  M_WDATA;
                    WVALID_REG  <=  '1';
                    
                    IF WREADY = '1' AND WVALID_REG = '1' THEN
                        WVALID_REG  <=  '0';
                        BREADY_REG  <=  '1';
                        W_STATE     <=  W_RESP;
                    END IF;                    
                    
                WHEN W_RESP =>
                    
--                    BREADY_REG  <=  '1';
                    
                    IF BREADY_REG = '1' AND BVALID = '1' THEN
                        IF BRESP = "00" THEN
                            W_STATE     <=  W_IDLE;
                            BREADY_REG  <=  '0';
                        ELSE
                            BREADY_REG  <=  '1';
                            W_STATE     <=  W_RESP;
                        END IF;
                        
                    END IF;
                    
                WHEN OTHERS =>
                    
                    W_STATE <=  W_IDLE;
                
                END CASE;
            
        END IF;
        
        AWVALID <=  AWVALID_REG;
        WVALID  <=  WVALID_REG;
        BREADY  <=  BREADY_REG;
        
    END PROCESS;
    
    ---- READ ----------------------------------------------------------------
    
    PROCESS (ACLK,ARST)
    BEGIN
        IF ARST = '0' THEN
            ARADDR  <=  (OTHERS => '0');
            ARVALID <=  '0';
            RREADY  <=  '0';
            M_RDATA <=  (OTHERS => '0');
            R_STATE <=  R_IDLE;
            
        ELSIF RISING_EDGE(ACLK) THEN
            
            CASE R_STATE IS
                WHEN R_IDLE =>
                    
                    ARVALID_REG <=  '0';
                    RREADY_REG  <=  '0';
                    R_STATE     <=  R_ADDR;
                    
                WHEN R_ADDR =>
                
                    ARADDR      <=  M_RADDR;
                    ARVALID_REG <=  '1';
                    
                    IF ARVALID_REG =  '1' AND ARREADY = '1' THEN
                        ARVALID_REG <=  '0';
                        RREADY_REG  <=  '1';
                        R_STATE     <=  R_DATA;
                    END IF;
                    
                WHEN R_DATA =>
                    
--                    RREADY_REG  <=  '1';
                    
                    IF RREADY_REG = '1' AND RVALID = '1' THEN
                        IF RRESP = "00" THEN
                            M_RDATA     <=  RDATA;
                            RREADY_REG  <=  '0';
                            R_STATE     <=  R_IDLE;
                        ELSE
                            M_RDATA     <=  (OTHERS => '0');
                            RREADY_REG  <=  '1';
                            R_STATE     <=  R_DATA;
                        END IF;
                    END IF;
                    
                WHEN OTHERS =>
                    
                    R_STATE <=  R_IDLE;
                
                END CASE;
            
        END IF;
        
        RREADY  <=  RREADY_REG;
        ARVALID  <=  ARVALID_REG;
        
    END PROCESS;

end Behavioral;
