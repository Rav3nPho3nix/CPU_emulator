with Interfaces; use Interfaces;

with Cpu; use Cpu;

package Print_Utility is
   --  Base representation for printing
   type Base_Representation is (
      DECIMAL,
      BINARY,
      HEXADECIMAL,
      OCTAL
   );

   --  Print the registers value based on given Base_Representation
   procedure Print_Registers (Registers : Registers_Record; Base : Base_Representation := HEXADECIMAL);

   --  Print an error with the given input message
   procedure Print_Error (Message : String);

   --  Print an instruction
   procedure Print_Instruction (Instruction : Unsigned_16);
end Print_Utility;