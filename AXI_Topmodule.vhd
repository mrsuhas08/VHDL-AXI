----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2026 11:03:30
-- Design Name: 
-- Module Name: axi_topmodule - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity axi_topmodule is
    Port(ACLK       :   IN std_logic;
         ARST       :   IN std_logic;
         
         -- FROM TOP_MODULE
--         START      :   IN std_logic;
         M_WADDR    :   IN std_logic_vector(31 downto 0);
         M_RADDR    :   IN std_logic_vector(31 downto 0);
         
         M_WDATA    :   IN std_logic_vector(31 downto 0);
         
         M_RDATA    :   OUT std_logic_vector(31 downto 0)
         );
end axi_topmodule;

architecture Behavioral of axi_topmodule is

    COMPONENT axi_master is
    Port(ACLK       :   IN std_logic;
         ARST       :   IN std_logic;
         
         -- FROM TOP_MODULE
--         START      :   IN std_logic;
         M_WADDR    :   IN std_logic_vector(31 downto 0);
         M_RADDR    :   IN std_logic_vector(31 downto 0);
         
         M_WDATA    :   IN std_logic_vector(31 downto 0);
         
         M_RDATA    :   OUT std_logic_vector(31 downto 0);
         
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
    END COMPONENT;
    
    COMPONENT axi_slave is
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
    END COMPONENT;
    
    SIGNAL AWADDR     :   std_logic_vector(31 downto 0) :=  (OTHERS =>  '0');
    SIGNAL AWVALID    :   std_logic                     :=  '0';
    SIGNAL AWREADY    :   std_logic                     :=  '0';
     
    SIGNAL WDATA      :   std_logic_vector(31 downto 0) :=  (OTHERS =>  '0');
    SIGNAL wVALID     :   std_logic                     :=  '0';
    SIGNAL wREADY     :   std_logic                     :=  '0';
     
    SIGNAL BRESP      :   std_logic_vector(1 downto 0)  :=  (OTHERS =>  '0');
    SIGNAL BVALID     :   std_logic                     :=  '0';
    SIGNAL BREADY     :   std_logic                     :=  '0';
     
    SIGNAL ARADDR     :   std_logic_vector(31 downto 0) :=  (OTHERS =>  '0');
    SIGNAL ARVALID    :   std_logic                     :=  '0';
    SIGNAL ARREADY    :   std_logic                     :=  '0';
     
    SIGNAL RDATA      :   std_logic_vector(31 downto 0) :=  (OTHERS =>  '0');
    SIGNAL RRESP      :   std_logic_vector(1 downto 0)  :=  (OTHERS =>  '0');
    SIGNAL RVALID     :   std_logic                     :=  '0';
    SIGNAL RREADY     :   std_logic                     :=  '0';
    
begin
    
    AXI_M   :   AXI_MASTER
        PORT MAP(ACLK   =>  ACLK,  
                ARST    =>  ARST,   
                
--                START   =>  START,
                
                M_WADDR =>  M_WADDR,
                M_RADDR	=>	M_RADDR,
                M_WDATA	=>	M_WDATA,
                M_RDATA	=>	M_RDATA,
                -- WRITE ADDRESS
                AWADDR  =>  AWADDR ,
                AWVALID =>  AWVALID,
                AWREADY =>  AWREADY,
                -- WRITE DATA
                WDATA   =>  WDATA  ,
                wVALID  =>  wVALID ,
                wREADY  =>  wREADY ,
                -- WRITE RESPONSE
                BRESP   =>  BRESP  ,
                BVALID  =>  BVALID ,
                BREADY  =>  BREADY ,
                -- READ ADDRESS
                ARADDR  =>  ARADDR ,
                ARVALID =>  ARVALID,
                ARREADY =>  ARREADY,
                -- READ DATA
                RDATA   =>  RDATA  ,
                RRESP   =>  RRESP  ,
                RVALID  =>  RVALID ,
                RREADY  =>  RREADY 
                );
    
    AXI_S   :   AXI_SLAVE
        PORT MAP(ACLK   =>  ACLK,
                ARST    =>  ARST,
                       
                -- WRITE ADDRESS
                AWADDR  =>  AWADDR,
                AWVALID =>  AWVALID,
                AWREADY =>  AWREADY,
                
                -- WRITE DATA
                WDATA   =>  WDATA,
                wVALID  =>  wVALID,
                wREADY  =>  wREADY,
                
                -- WRITE RESPONSE
                BRESP   =>  BRESP,
                BVALID  =>  BVALID,
                BREADY  =>  BREADY,
                
                -- READ ADDR
                ARADDR  =>  ARADDR,
                ARVALID =>  ARVALID,
                ARREADY =>  ARREADY,
                
                -- READ DATA
                RDATA   =>  RDATA,
                RRESP   =>  RRESP,
                RVALID  =>  RVALID,
                RREADY  =>  RREADY
                );

end Behavioral;
