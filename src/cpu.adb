with Interfaces; use Interfaces;
with System;

with Cpu; use Cpu;
with Print_Utility; use Print_Utility;

package body Cpu is
   --  Memory (need to be loaded before calling 'Execute')
   Memory : Memory_Array := (others => 0);

   --  Registers of the CPU
   Registers : Registers_Record;

   --  Boolean value to check if the memory have been loaded
   Memory_Is_Loaded : Boolean := False;

   --  Boolean value to check if the cpu has halted
   Has_Halted : Boolean := False;

   --  Decode and execute an instruction
   --  Always increment PC by one
   procedure Execute (Instruction : Unsigned_16) is
      --  Get the operation code
      --  Execute a right shift to get the first four bits
      Operation : Operation_Code := Operation_Code (Shift_Right (Instruction, 12));

      --  Get the remaining instruction content
      --  Use a mask to only get the 12 first bits
      Remaining : Instruction_Remaining := Instruction_Remaining (Instruction and 16#0FFF#);
   begin
      -- Increment PC by one
      Registers.PC := Registers.PC + 1;

      --  Halt if the operation is illegal
      if Operation = 2#1101# then
         Print_Error ("Unused operation detected.\nHalting.");
         Halt;
      end if;

      Print_Instruction (Instruction);
   end Execute;

   --  Load the memory from C array
   procedure Load_Memory (Memory_Source : Memory_Access) is
   begin
      Memory := Memory_Source.all;
      --  Set the flag as true
      Memory_Is_Loaded := True;
   end Load_Memory;

   --  Execute instructions stored in memory
   procedure Start is
   begin
      --  Check if the memory is loaded
      --  If not, put an error and exit the function
      if not Memory_Is_Loaded then
         Print_Error ("The memory need to be loaded before starting the CPU.");
         return;
      end if;

      while (not Has_Halted) and (Registers.PC < 2**16) loop
         Execute (Memory (Registers.PC));
      end loop;

      --  Print_Registers (Registers, DECIMAL);
      --  Print_Registers (Registers, HEXADECIMAL);
   end Start;

   -- Halt the CPU
   procedure Halt is
   begin
      Has_Halted := True;
   end Halt;

begin
   null;
end Cpu;