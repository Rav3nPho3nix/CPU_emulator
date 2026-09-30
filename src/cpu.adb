with Interfaces; use Interfaces;
with Ada.Text_IO; use Ada.Text_IO;

with Core; use Core;
with Print_Utility; use Print_Utility;

procedure Cpu is
   Memory : Memory_Array := (others => 0);
   Registers : Registers_Record;
begin
   Memory (0) := 2#0101_0101_0101_0101#;
   Registers.R0 := 13;
   Registers.R1 := 16#FFFF#;
   Registers.PC := 2#1#;

   for m of Memory loop
      Put_Line (m'Image);
   end loop;
end Cpu;
