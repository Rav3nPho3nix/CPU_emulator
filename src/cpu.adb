with Interfaces; use Interfaces;

with Cpu; use Cpu;
with Print_Utility; use Print_Utility;

package body Cpu is
   --  #### Variables ####

   --  Memory (need to be loaded before calling 'Execute')
   Memory : Memory_Array := (others => 0);

   --  Registers of the CPU
   Registers : Registers_Record;

   --  Boolean value to check if the memory have been loaded
   Memory_Is_Loaded : Boolean := False;

   --  Boolean value to check if the cpu has halted
   Is_Halted : Boolean := False;

   --  Array of instructions execution functions
   --  Each instuction execution function is indexed by an Operation Code
   Instruction_Functions : Instruction_Functions_Array := (
      Instructions'Enum_Rep (BR_INSTRUCTION) => Execute_BR'Access,
      Instructions'Enum_Rep (ADD_INSTRUCTION) => Execute_ADD'Access,
      Instructions'Enum_Rep (LD_INSTRUCTION) => Execute_LD'Access,
      Instructions'Enum_Rep (ST_INSTRUCTION) => Execute_ST'Access,
      Instructions'Enum_Rep (JSR_INSTRUCTION) => Execute_JSR'Access,
      Instructions'Enum_Rep (AND_INSTRUCTION) => Execute_AND'Access,
      Instructions'Enum_Rep (LDR_INSTRUCTION) => Execute_LDR'Access,
      Instructions'Enum_Rep (STR_INSTRUCTION) => Execute_STR'Access,
      Instructions'Enum_Rep (RTI_INSTRUCTION) => Execute_RTI'Access,
      Instructions'Enum_Rep (NOT_INSTRUCTION) => Execute_NOT'Access,
      Instructions'Enum_Rep (LDI_INSTRUCTION) => Execute_LDI'Access,
      Instructions'Enum_Rep (STI_INSTRUCTION) => Execute_STI'Access,
      Instructions'Enum_Rep (JMP_INSTRUCTION) => Execute_JMP'Access,
      Instructions'Enum_Rep (LEA_INSTRUCTION) => Execute_LEA'Access,
      Instructions'Enum_Rep (TRAP_INSTRUCTION) => Execute_TRAP'Access,
      others => null
   );

   --  ####

   --  #### Functions implementations ####

   --  Execute a BR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_BR (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_BR;

   --  Execute an ADD instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_ADD (Operands : Operands_Bits) return Boolean is
   begin
      --  --  What register the ADD value must me stored
      --  dr : Register_Index := Register_Index (Shift_Right (Unsigned_16 (Operands), 8));
      return True;
   end Execute_ADD;

   --  Execute an LD instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LD (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_LD;

   --  Execute an ST instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_ST (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_ST;

   --  Execute an JSR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_JSR (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_JSR;

   --  Execute an AND instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_AND (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_AND;

   --  Execute an LDR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LDR (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_LDR;

   --  Execute an STR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_STR (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_STR;

   --  Execute an RTI instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_RTI (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_RTI;

   --  Execute a NOT instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_NOT (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_NOT;

   --  Execute a LDI instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LDI (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_LDI;

   --  Execute an STI instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_STI (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_STI;

   --  Execute a JMP instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_JMP (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_JMP;

   --  Execute an LEA instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LEA (Operands : Operands_Bits) return Boolean is
   begin
      return True;
   end Execute_LEA;

   --  Execute a TRAP instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_TRAP (Operands : Operands_Bits) return Boolean is
   begin
      return True;
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

      --  Returned value of the instruction execution call
      Execution_Status : Boolean;
   begin
      --  Increment PC by one
      Registers.PC := Registers.PC + 1;

      --  Halt if the operation is illegal
      if Operation = 2#1101# then
         Print_Error ("Unused operation detected.");
         Print_Error ("Exiting.");
         Halt;
      end if;

      Execution_Status := Instruction_Functions (Operation).all (Operands);

      --  Print_Instruction (Instruction);
   end Execute;

   --  Halt the CPU
   procedure Halt is
   begin
      Is_Halted := True;
   end Halt;

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

      while (not Is_Halted) and (Registers.PC < 2**16) loop
         Execute (Memory (Registers.PC));
      end loop;
   end Start;

   --  ####

begin
   null;
end Cpu;