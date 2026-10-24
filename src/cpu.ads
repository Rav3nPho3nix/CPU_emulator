with Interfaces; use Interfaces;
with System;

package Cpu is
   
   --  Instructions
   type Instructions is (
      BR_INSTRUCTION,
      ADD_INSTRUCTION,
      LD_INSTRUCTION,
      ST_INSTRUCTION,
      JSR_INSTRUCTION,
      AND_INSTRUCTION,
      LDR_INSTRUCTION,
      STR_INSTRUCTION,
      RTI_INSTRUCTION,
      NOT_INSTRUCTION,
      LDI_INSTRUCTION,
      STI_INSTRUCTION,
      JMP_INSTRUCTION,
      LEA_INSTRUCTION,
      TRAP_INSTRUCTION
   );

   --  Instructions binary values
   for Instructions use (
      BR_INSTRUCTION => 2#0000#,
      ADD_INSTRUCTION => 2#0001#,
      LD_INSTRUCTION => 2#0010#,
      ST_INSTRUCTION => 2#0011#,
      JSR_INSTRUCTION => 2#0100#,
      AND_INSTRUCTION => 2#0101#,
      LDR_INSTRUCTION => 2#0110#,
      STR_INSTRUCTION => 2#0111#,
      RTI_INSTRUCTION => 2#1000#,
      NOT_INSTRUCTION => 2#1001#,
      LDI_INSTRUCTION => 2#1010#,
      STI_INSTRUCTION => 2#1011#,
      JMP_INSTRUCTION => 2#1100#,
      LEA_INSTRUCTION => 2#1110#,
      TRAP_INSTRUCTION => 2#1111#
   );

   --  Operation code type
   type Operation_Code is mod 2 ** 4;
   for Operation_Code'Size use 4;

   --  Instruction remaining
   type Instruction_Remaining is mod 2 ** 12;
   for Instruction_Remaining'Size use 12;

   --  Memory index
   type Memory_Index is range 0 .. 2**16 - 1;

   --  Memory array
   type Memory_Array is array (Memory_Index) of Unsigned_16
      with Convention => C;

   --  Memory pointer from C code
   type Memory_Access is access all Memory_Array
      with Convention => C;

   --  Registers of the CPU
   type Registers_Record is record
      R0, R1, R2, R3, R4, R5, R6, R7 : Unsigned_16 := 0;
      PSR, USP, SSP, IR : Unsigned_16 := 0;
      PC : Memory_Index := 0;
   end record;

   --  Load memory from C array
   procedure Load_Memory (Memory_Source : Memory_Access)
      with Export => True, Convention => C, External_Name => "load_memory";

   --  Execute instructions stored in memory
   procedure Start
      with Export => True, Convention => C, External_Name => "start";

   -- Halt the CPU
   procedure Halt;

end Cpu;