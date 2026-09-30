with Interfaces; use Interfaces;

with Core; use Core;

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
   
end Print_Utility;