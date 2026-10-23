with Interfaces; use Interfaces;
with System;
--  with Ada.Text_IO; use Ada.Text_IO;

with Cpu; use Cpu;
with Print_Utility; use Print_Utility;

package body Cpu is
   --  Memory (need to be loaded before calling 'Execute')
   Memory : Memory_Array := (others => 0);

   --  Registers of the CPU
   Registers : Registers_Record;

   --  Load instructions in memory from C array
   procedure Load_Memory (Memory : Memory_Access) is
   begin
      null;
   end Load_Memory;

   --  Execute instructions stored in memory
   procedure Execute is
   begin
      null;
   end Execute;

begin
   Registers.R0 := 13;
   Registers.R1 := 16#FFFF#;
   Registers.R2 := 16#FFFE#;
   Registers.R3 := 16#2#;
   Registers.PC := 2#1#;

   --  Remplir la memoire
   Memory (0) := 2#0101_0101_0101_0101#;
   Memory (1) := 2#1111_0000_0000_0001#;
   Memory (2) := 2#1010_1010_1010_1010#;

   --  Print_Registers (Registers, DECIMAL);
   --  Print_Registers (Registers, HEXADECIMAL);

end Cpu;