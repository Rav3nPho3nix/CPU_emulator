with Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;

with Core; use Core;

package body Print_Utility is

   --  Pointer to a Print_XXX function
   type Print_Function is access procedure (i : Unsigned_16);

   --  Get a String of the binary representation of i
   function Binary_Representation (i : Unsigned_16) return String is
      str : String (1 .. 16) := (others => '0');
      n : Unsigned_16 := i;
   begin
      for j in reverse str'Range loop
         if (n mod 2) = 1 then
            str (j) := '1';
         end if;

         n := n / 2;

         exit when n = 0;
      end loop;

      return str;
   end Binary_Representation;


   --  Get a String of the hexadecimal representation of i
   function Hexadecimal_Representation (i : Unsigned_16) return String is
      str : String (1 .. 4) := (others => '0');
      n : Unsigned_16 := i;
   begin
      for j in reverse str'Range loop
         if (n mod 16) < 10 then
            str (j) := Character'Val (Character'Pos ('0') + Integer (n mod 10));
         else
            str (j) := Character'Val (Character'Pos ('A') + Integer (n mod 6));

         end if;
         
         n := n / 16;

         exit when n = 0;
      end loop;

      return str;
   end Hexadecimal_Representation;


   --  Get a String of the octal representation of i
   function Octal_Representation (i : Unsigned_16) return String is
      str : String (1 .. 6) := (others => '0');
      n : Unsigned_16 := i;
   begin
      for j in reverse str'Range loop
         str (j) := Character'Val (Character'Pos ('0') + Integer (n mod 8));
         
         n := n / 8;

         exit when n = 0;
      end loop;

      return str;
   end Octal_Representation;

   --  Get a String of the decimal representation of i
   function Decimal_Representation (i : Unsigned_16) return String is
      str : String (1 .. 5) := (others => '0');
      n : Unsigned_16 := i;
   begin
      for j in reverse str'Range loop
         str (j) := Character'Val (Character'Pos ('0') + Integer (n mod 10));
         
         n := n / 10;

         exit when n = 0;
      end loop;

      return str;
   end Decimal_Representation;

   --  Print n times the character c
   procedure Print_Character (c : Character; n : Unsigned_16) is
   begin
      for i in 1 .. n loop
         Put (c);
      end loop;
   end Print_Character;

   --  Print a binary number with correct width
   procedure Print_Binary (i : Unsigned_16) is
   begin
      Put ("0b ");
      Put (Binary_Representation (i));
   end Print_Binary;

   --  Print an hexadecimal number with correct width
   procedure Print_Hexadecimal (i: Unsigned_16) is
   begin
      Put ("0x ");
      Put (Hexadecimal_Representation (i));
   end Print_Hexadecimal;

   --  Print an octal number with correct width
   procedure Print_Octal (i: Unsigned_16) is
   begin
      Put ("0o ");
      Put (Octal_Representation (i));
   end Print_Octal;

   --  Print a decimal number with correct width
   procedure Print_Decimal (i: Unsigned_16) is
   begin
      Put (Decimal_Representation (i));
   end Print_Decimal;

   --  Print the registers value based on given Base_Representation
   procedure Print_Registers (Registers : Registers_Record; Base : Base_Representation := HEXADECIMAL) is
      LABEL_OFFSET : Unsigned_16 := 8;

      f : Print_Function;
      prefix_offset : Unsigned_16;
      value_witdh : Unsigned_16;
   begin
      if Base = HEXADECIMAL then
         f := Print_Hexadecimal'Access;
         prefix_offset := 3;
         value_witdh := 4;

      elsif Base = OCTAL then
         f := Print_Octal'Access;
         prefix_offset := 3;
         value_witdh := 6;

      elsif Base = BINARY then
         f := Print_Binary'Access;
         prefix_offset := 3;
         value_witdh := 16;

      else
         f := Print_Decimal'Access;
         prefix_offset := 0;
         value_witdh := 5;
      end if;

      --  Line of underscore
      Put (" ");
      Print_Character ('_', 2 * (LABEL_OFFSET + prefix_offset + value_witdh));
      Put_Line ("");

      --  R0 & R1
      Put ("| R0  : ");
      f.all (Registers.R0);
      Put (" | R1  : ");
      f.all (Registers.R1);
      Put_Line (" |");
      
      --  R2 & R3
      Put ("| R2  : ");
      f.all (Registers.R2);
      Put (" | R3  : ");
      f.all (Registers.R3);
      Put_Line (" |");

      --  R4 & R5
      Put ("| R4  : ");
      f.all (Registers.R4);
      Put (" | R5  : ");
      f.all (Registers.R5);
      Put_Line (" |");

      --  R6 & R7
      Put ("| R6  : ");
      f.all (Registers.R6);
      Put (" | R7  : ");
      f.all (Registers.R7);
      Put_Line (" |");
      
      --  PSR & USP
      Put ("| PSR : ");
      f.all (Registers.PSR);
      Put (" | USP : ");
      f.all (Registers.USP);
      Put_Line (" |");
      
      --  SSP & IR
      Put ("| SSP : ");
      f.all (Registers.SSP);
      Put (" | IR  : ");
      f.all (Registers.IR);
      Put_Line (" |");
      
      --  PC
      Put ("| PC  : ");
      f.all (Unsigned_16 (Registers.PC));
      Put (" |");
      Print_Character (' ', LABEL_OFFSET + prefix_offset + value_witdh);
      Put_Line ("|");

      --  Line of underscore
      Put (" ");
      Print_Character ('_', 2 * (LABEL_OFFSET + prefix_offset + value_witdh));
      Put_Line ("");
      
   end Print_Registers;

begin
   null;
end Print_Utility;