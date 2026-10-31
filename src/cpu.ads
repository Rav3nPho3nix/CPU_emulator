with Interfaces; use Interfaces;

package Cpu is
   --  Operation code type
   type Operation_Code is mod 2 ** 4;
   for Operation_Code'Size use 4;

   --  Operands
   type Operands_Bits is mod 2 ** 12;
   for Operands_Bits'Size use 12;

   --  Mode bit
   type Mode_Bit is mod 2;
   for Mode_Bit'Size use 1;
   
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
      BR_INSTRUCTION => Operation_Code (2#0000#),
      ADD_INSTRUCTION => Operation_Code (2#0001#),
      LD_INSTRUCTION => Operation_Code (2#0010#),
      ST_INSTRUCTION => Operation_Code (2#0011#),
      JSR_INSTRUCTION => Operation_Code (2#0100#),
      AND_INSTRUCTION => Operation_Code (2#0101#),
      LDR_INSTRUCTION => Operation_Code (2#0110#),
      STR_INSTRUCTION => Operation_Code (2#0111#),
      RTI_INSTRUCTION => Operation_Code (2#1000#),
      NOT_INSTRUCTION => Operation_Code (2#1001#),
      LDI_INSTRUCTION => Operation_Code (2#1010#),
      STI_INSTRUCTION => Operation_Code (2#1011#),
      JMP_INSTRUCTION => Operation_Code (2#1100#),
      LEA_INSTRUCTION => Operation_Code (2#1110#),
      TRAP_INSTRUCTION => Operation_Code (2#1111#)
   );

   --  Memory index
   type Memory_Index is range 0 .. 2 ** 16 - 1;

   --  --  Memory array
   --  type Memory_Array is array (Memory_Index) of Unsigned_16
   --     with Convention => C;

   --  --  Memory pointer from C code
   --  type Memory_Access is access all Memory_Array
   --     with Convention => C;

   --  Memory array
   type Memory_Array is array (Memory_Index) of Unsigned_16;

   --  Memory pointer from C code
   type Memory_Access is access all Memory_Array;

   --  Register type
   type Register is new Unsigned_16;

   --  Register index
   --  2 ** 3 registers => range between 0 and 2 ** 3 - 1
   type Register_Index is range 0 .. 2 ** 3 - 1;

   --  Register array
   type Register_Array is array (Register_Index) of Register;

   --  Registers of the CPU
   type Registers_Record is record
      --  R0, R1, R2, R3, R4, R5, R6, R7 : Unsigned_16 := 0;
      Registers : Register_Array := (others => 0);
      PSR, USP, SSP, IR : Unsigned_16 := 0;
      PC : Memory_Index := 0;
   end record;

   --  Pointer to an instruction execution function
   type Instruction_Function is access function (Operands : Operands_Bits)
      return Boolean;

   --  Instruction execution functions array
   type Instruction_Functions_Array is array (Operation_Code)
      of Instruction_Function;

   --  --  Load memory from C array
   --  procedure Load_Memory (Memory_Source : Memory_Access)
   --     with Export => True, Convention => C, External_Name => "load_memory";

   --  --  Execute instructions stored in memory
   --  procedure Start
   --     with Export => True, Convention => C, External_Name => "start";

   --  Load memory
   procedure Load_Memory (Memory : Memory_Array);

   --  Execute instructions
   procedure Start;

   --  Execute a BR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_BR (Operands : Operands_Bits) return Boolean;

   --  Execute an ADD instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_ADD (Operands : Operands_Bits) return Boolean;

   --  Execute an LD instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LD (Operands : Operands_Bits) return Boolean;

   --  Execute an ST instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_ST (Operands : Operands_Bits) return Boolean;

   --  Execute an JSR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_JSR (Operands : Operands_Bits) return Boolean;

   --  Execute an AND instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_AND (Operands : Operands_Bits) return Boolean;

   --  Execute an LDR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LDR (Operands : Operands_Bits) return Boolean;

   --  Execute an STR instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_STR (Operands : Operands_Bits) return Boolean;

   --  Execute an RTI instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_RTI (Operands : Operands_Bits) return Boolean;

   --  Execute a NOT instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_NOT (Operands : Operands_Bits) return Boolean;

   --  Execute a LDI instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LDI (Operands : Operands_Bits) return Boolean;

   --  Execute an STI instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_STI (Operands : Operands_Bits) return Boolean;

   --  Execute a JMP instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_JMP (Operands : Operands_Bits) return Boolean;

   --  Execute an LEA instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_LEA (Operands : Operands_Bits) return Boolean;

   --  Execute a TRAP instruction
   --  Return False if the instruction couldn't be executed
   --  Else True
   function Execute_TRAP (Operands : Operands_Bits) return Boolean;

   --  Decode and execute an instruction
   --  Always increment PC by one
   procedure Execute (Instruction : Unsigned_16);

   --  Update PSR register
   procedure Update_PSR (Value : Unsigned_16);

   --  Halt the CPU
   procedure Halt;

end Cpu;