with Cpu; use Cpu;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   Memory : Cpu.Memory_Array;
begin
   --  Example program to test ADD instructions

   --  ADD with R0 the immediate value 1 => store in R1
   --  0001 001 000 1 0 0001
   Memory (0) := 2#0001001000100001#;

   --  ADD with R1 the immediate value 4 => store in R1
   --  0001 001 001 1 0 0100
   Memory (1) := 2#0001001001100100#;

   --  ADD with R1 the immediate value -1 => store in R0
   --  0001 000 001 1 0 1111
   Memory (2) := 2#0001000001111111#;

   --  ADD with R0 the immediate value -4 => store in R0
   --  0001 000 000 1 1 1101
   Memory (3) := 2#0001000000111100#;

   --  Halt
   Memory (4) := 2#1111000000000000#;

   Load_Memory (Memory);
   --  Start;
end Main;