with Interfaces; use Interfaces;
with Ada.Text_IO; use Ada.Text_IO;

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
      --  PC Offset of 9 bits
      PCoffset9 : constant Unsigned_16 := Unsigned_16 (Operands) and 16#01FF#;

      --  Extended PC Offset value to 16 bits
      --  If the last bit is 1, I fill the bits [10; 16] with 1
      --  Else I do nothing
      Ext_PCoffset9 : constant Unsigned_16 := (if ((PCoffset9 and 16#100#) /= 0) then (PCoffset9 or 16#FE00#) else PCoffset9);
   begin

      if (Shift_Right (Unsigned_16 (Operands), 9) and 2#111# and Registers.PSR and 2#111#) /= 0
      then
         Registers.PC := Registers.PC + Memory_Index (Ext_PCoffset9);
      end if;

      return True;
   end Execute_BR;

   --  Execute an ADD instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_ADD (Operands : Operands_Bits) return Boolean is
      --  Destination register
      DR : constant Register_Index := Register_Index (Shift_Right (Unsigned_16 (Operands), 9));

      --  First register
      SR1 : constant Register_Index := Register_Index
         (Shift_Right (Unsigned_16 (Operands), 6) and 2#111#);
      
      --  Mode bit
      Mode : constant Mode_Bit := Mode_Bit (Shift_Right (Unsigned_16 (Operands), 5) and 2#1#);

      --  Second register (if mode = 0)
      SR2 : Register_Index;

      --  Immediate value (id mode = 1) of 5 bits
      Imm5 : Unsigned_16;

      --  Extended immediate value to 16 bits
      Ext_Imm5 : Unsigned_16;
   begin
      --  ADD the content of SR1 with SR2 (first 3 bits)
      if Mode = 0 then
         SR2 := Register_Index (Unsigned_16 (Operands) and 2#111#);
         Registers.Registers (DR) := Registers.Registers (SR1) +
            Registers.Registers (SR2);
      
      --  ADD the content of SR1 with the immediate value (first 5 bits, extended to 16)
      else
         Imm5 := Unsigned_16 (Operands) and 2#11111#;

         --  If the last bit is 1, the number is negatively signed
         --  I fill the bits [5; 15] by 1
         if (Imm5 and 2#10000#) /= 0 then
            Ext_Imm5 := Imm5 or 16#FFE0#;
         
         --  else it's a positive
         --  I do nothing
         else
            Ext_Imm5 := Imm5;
         end if;

         Registers.Registers (DR) := Registers.Registers (SR1) + Register (Ext_Imm5);
      end if;

      --  Update PSR
      Update_PSR (Unsigned_16 (Registers.Registers (DR)));

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
      --  Destination register
      DR : constant Register_Index := Register_Index (Shift_Right (Unsigned_16 (Operands), 9));

      --  First register
      SR1 : constant Register_Index := Register_Index
         (Shift_Right (Unsigned_16 (Operands), 6) and 2#111#);
      
      --  Mode bit
      Mode : constant Mode_Bit := Mode_Bit (Shift_Right (Unsigned_16 (Operands), 5) and 2#1#);

      --  Second register (if mode = 0)
      SR2 : Register_Index;

      --  Immediate value (id mode = 1) of 5 bits
      Imm5 : Unsigned_16;

      --  Extended immediate value to 16 bits
      Ext_Imm5 : Unsigned_16;
   begin
      --  AND the content of SR1 with SR2 (first 3 bits)
      if Mode = 0 then
         SR2 := Register_Index (Unsigned_16 (Operands) and 2#111#);
         Registers.Registers (DR) := Registers.Registers (SR1) +
            Registers.Registers (SR2);
      
      --  AND the content of SR1 with the immediate value (first 5 bits, extended to 16)
      else
         Imm5 := Unsigned_16 (Operands) and 2#11111#;

         --  If the last bit is 1, the number is signed at negative
         --  I fill the bits [5; 15] by 1
         if (Imm5 and 2#10000#) /= 0 then
            Ext_Imm5 := Imm5 or 16#FFE0#;
         
         --  else it's a positive
         --  I do nothing
         else
            Ext_Imm5 := Imm5;
         end if;

         Registers.Registers (DR) := Registers.Registers (SR1) and Register (Ext_Imm5);
      end if;

      --  Update PSR
      Update_PSR (Unsigned_16 (Registers.Registers (DR)));

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
      Halt;
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
   end Execute;

   --  Halt the CPU
   procedure Halt is
   begin
      Is_Halted := True;
   end Halt;

   --  Update PSR register
   procedure Update_PSR (Value : Unsigned_16) is
   begin
      --  If it is equal to zero
      if Value = 16#0000# then
         Registers.PSR := 2#010#;

      --  If it is positive
      elsif Shift_Right (Value, 15) = 0 then
         Registers.PSR := 2#001#;
      
      --  If it is negative
      elsif Shift_Right (Value, 15) = 1 then
         Registers.PSR := 2#100#;
      end if; 
   end Update_PSR;

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
         Print_Registers (Registers, BINARY);
      end loop;
   end Start;

   --  ####

begin
   null;
end Cpu;