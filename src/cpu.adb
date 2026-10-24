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

   --  Execute a BR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_BR(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_BR;

   --  Execute an ADD instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_ADD(Operands : Operands_Bits) return Boolean is
   begin
      --  --  What register the ADD value must me stored
      --  dr : Register_Index := Register_Index (Shift_Right (Unsigned_16 (Operands), 8));
      null;
   end Execute_ADD;

   --  Execute an LD instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LD(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_LD;

   --  Execute an ST instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_ST(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_ST;

   --  Execute an JSR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_JSR(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_JSR;

   --  Execute an AND instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_AND(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_AND;

   --  Execute an LDR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LDR(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_LDR;

   --  Execute an STR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_STR(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_STR;

   --  Execute an RTI instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_RTI(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_RTI;

   --  Execute a NOT instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_NOT(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_NOT;

   --  Execute a LDI instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LDI(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_LDI;

   --  Execute an STI instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_STI(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_STI;

   --  Execute a JMP instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_JMP(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_JMP;

   --  Execute an LEA instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LEA(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_LEA;

   --  Execute a TRAP instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_TRAP(Operands : Operands_Bits) return Boolean is
   begin
      null;
   end Execute_TRAP;

   --  Decode and execute an instruction
   --  Always increment PC by one
   procedure Execute (Instruction : Unsigned_16) is
      --  Get the operation code
      --  Execute a right shift to get the first four bits
      Operation : Operation_Code := Operation_Code (Shift_Right (Instruction, 12));

      --  Get the operands
      --  Use a mask to only get the 12 first bits
      Operands : Operands_Bits := Operands_Bits (Instruction and 16#0FFF#);
   begin
      -- Increment PC by one
      Registers.PC := Registers.PC + 1;

      --  Halt if the operation is illegal
      if Operation = 2#1101# then
         Print_Error ("Unused operation detected.\nHalting.");
         Halt;
      end if;

      case Operation is
         --  BR
         when Instructions'Enum_Rep (BR_INSTRUCTION) =>
            null;
         --  ADD
         when Instructions'Enum_Rep (ADD_INSTRUCTION) =>
            null;
         --  LD
         when Instructions'Enum_Rep (LD_INSTRUCTION) =>
            null;
         --  ST
         when Instructions'Enum_Rep (ST_INSTRUCTION) =>
            null;
         --  JSR
         when Instructions'Enum_Rep (JSR_INSTRUCTION) =>
            null;
         --  AND
         when Instructions'Enum_Rep (AND_INSTRUCTION) =>
            null;
         --  LDR
         when Instructions'Enum_Rep (LDR_INSTRUCTION) =>
            null;
         --  STR
         when Instructions'Enum_Rep (STR_INSTRUCTION) =>
            null;
         --  RTI
         when Instructions'Enum_Rep (RTI_INSTRUCTION) =>
            null;
         --  NOT
         when Instructions'Enum_Rep (NOT_INSTRUCTION) =>
            null;
         --  LDI
         when Instructions'Enum_Rep (LDI_INSTRUCTION) =>
            null;
         --  STI
         when Instructions'Enum_Rep (STI_INSTRUCTION) =>
            null;
         --  JMP
         when Instructions'Enum_Rep (JMP_INSTRUCTION) =>
            null;
         --  LEA
         when Instructions'Enum_Rep (LEA_INSTRUCTION) =>
            null;
         --  TRAP
         when Instructions'Enum_Rep (TRAP_INSTRUCTION) =>
            null;
         --  Default
         when others =>
            null;
      end case;

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