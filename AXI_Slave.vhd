----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2026 11:03:30
-- Design Name: 
-- Module Name: axi_slave - Behavioral
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

entity axi_slave is
    Port(ACLK       :   IN std_logic;
         ARST       :   IN std_logic;
                  
         -- WRITE ADDRESS CHANNEL
         AWADDR     :   IN std_logic_vector(31 downto 0);
         AWVALID    :   IN std_logic;
         AWREADY    :   OUT std_logic;
         
         -- WRITE DATA CHANNEL
         WDATA      :   IN std_logic_vector(31 downto 0);
         wVALID     :   IN std_logic;
         wREADY     :   OUT std_logic;
         
         -- WRITE RESPONSE CHANNEL
         BRESP      :   OUT std_logic_vector(1 downto 0);
         BVALID     :   OUT std_logic;
         BREADY     :   IN std_logic;
         
         -- READ ADDRESS CHANNEL
         ARADDR     :   IN std_logic_vector(31 downto 0);
         ARVALID    :   IN std_logic;
         ARREADY    :   OUT std_logic;
         
         -- READ DATA CHANNEL
         RDATA      :   OUT std_logic_vector(31 downto 0);
         RRESP      :   OUT std_logic_vector(1 downto 0);
         RVALID     :   OUT std_logic;
         RREADY     :   IN std_logic);
end axi_slave;

architecture Behavioral of axi_slave is
    
    CONSTANT DEPTH      :   INTEGER                         :=  1024;
--    CONSTANT RESP       :   std_logic_vector(1 downto 0)    :=  "00";
    
    SIGNAL AWREADY_REG  :   std_logic                       :=  '0';
    SIGNAL WREADY_REG   :   std_logic                       :=  '0';
    SIGNAL ARREADY_REG  :   std_logic                       :=  '0';

    SIGNAL BVALID_REG   :   std_logic                       :=  '0';
    SIGNAL RVALID_REG   :   std_logic                       :=  '0';
          
    TYPE STORE IS ARRAY (0 TO DEPTH - 1) OF std_logic_vector(31 downto 0);
    SIGNAL MEM          :   STORE                           :=  (OTHERS => (OTHERS => '0'));
    SIGNAL AWREG_ADDR   :   std_logic_vector(31 downto 0)   :=  (OTHERS => '0');
    SIGNAL ARREG_ADDR   :   std_logic_vector(31 downto 0)   :=  (OTHERS => '0');
    
    TYPE W_FSM IS (W_IDLE,
                   W_ADDR,
                   W_WRITE,
                   W_RESPONSE);
             
    SIGNAL W_STATE      :   W_FSM                           :=  W_IDLE;
    
    TYPE R_FSM IS (R_IDLE,
                   R_ADDR,
                   R_READ);
             
    SIGNAL R_STATE      :   R_FSM                           :=  R_IDLE;
        
begin

    ----- WRITE -----------------------------------------------------
    
    PROCESS (ACLK,ARST)
    BEGIN
        IF ARST = '0' THEN
            AWREG_ADDR  <=  (OTHERS => '0');
            BRESP       <=  "00";
            AWREADY_REG <=  '0';
            WREADY_REG  <=  '0';
            BVALID_REG  <=  '0';
            W_STATE     <=  W_IDLE;
            
        ELSIF RISING_EDGE (ACLK) THEN
        
            CASE W_STATE IS
            
                WHEN W_IDLE =>
                
                    AWREADY_REG <=  '1';
                    WREADY_REG  <=  '0';
                    BVALID_REG  <=  '0';
                    BRESP       <=  "00";
                    W_STATE     <=  W_ADDR;
                
                WHEN W_ADDR =>
                
--                    AWREADY_REG <=  '1';
                    
                    IF AWVALID = '1' AND AWREADY_REG = '1' THEN
                        AWREG_ADDR  <=  AWADDR;
                        AWREADY_REG <=  '0';
                        WREADY_REG  <=  '1';
                        W_STATE     <=  W_WRITE;
                    END IF;
                
                WHEN W_WRITE =>
                
--                    WREADY_REG  <=  '1';
                    
                    IF WVALID = '1' AND WREADY_REG = '1' THEN
                        MEM(TO_INTEGER(UNSIGNED(AWREG_ADDR)))   <=  WDATA;
                        WREADY_REG  <=  '0';
--                        BVALID_REG  <=  '1';
                        W_STATE     <=  W_RESPONSE;
                    END IF;
                
                WHEN W_RESPONSE =>
                
                    BVALID_REG  <=  '1';
                    BRESP       <=  "00";
                    
                    IF BVALID_REG = '1' AND BREADY = '1' THEN
--                        BRESP       <=  "00";
                        BVALID_REG  <=  '0';
                        W_STATE     <=  W_IDLE;
                    END IF;
                
                WHEN OTHERS =>
                
                    W_STATE <=  W_IDLE;
            
            END CASE;
            
        END IF;
        
        WREADY  <=  WREADY_REG;
        AWREADY <=  AWREADY_REG;
        BVALID  <=  BVALID_REG;
        
    END PROCESS;
    
    ---- READ ---------------------------------------------------------
    
    PROCESS (ACLK,ARST)
    BEGIN
        IF ARST = '0' THEN
            RDATA       <=  (OTHERS => '0');
            ARREG_ADDR  <=  (OTHERS => '0');
            RRESP       <=  "00";
            ARREADY_REG <=  '0';
            RVALID_REG  <=  '0';
            R_STATE     <=  R_IDLE;
            
        ELSIF RISING_EDGE (ACLK) THEN
        
            CASE R_STATE IS
                
                WHEN R_IDLE =>
                
                    ARREADY_REG <=  '1';
                    RVALID_REG  <=  '0';
                    RRESP       <=  "00";
                    R_STATE     <=  R_ADDR;
            
                WHEN R_ADDR =>
                
--                    ARREADY_REG <=  '1';
                    
                    IF ARVALID = '1' AND ARREADY_REG = '1' THEN
                        ARREG_ADDR  <=  ARADDR;
                        ARREADY_REG <=  '0';
                        R_STATE     <=  R_READ;
                    END IF;
                
                WHEN R_READ =>
                    
                    RDATA       <=  MEM(TO_INTEGER(UNSIGNED(ARREG_ADDR)));
                    RVALID_REG  <=  '1';
                    RRESP       <=  "00";
                    
                    IF RVALID_REG = '1' AND RREADY = '1' THEN
--                        RRESP       <=  "00";
                        RVALID_REG  <=  '0';
                        R_STATE     <=  R_IDLE;
                    END IF;                
                
                WHEN OTHERS =>
                
                    R_STATE <=  R_IDLE;
            
            END CASE;
            
        END IF;
        
        RVALID  <=  RVALID_REG;
        ARREADY <=  ARREADY_REG;
        
    END PROCESS;
    
end Behavioral;

