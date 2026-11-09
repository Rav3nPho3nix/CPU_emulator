with Ada.Command_Line; use Ada.Command_Line;
--  with Ada.Numerics.Generic_Complex_Types;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Directories; use Ada.Directories;
with Ada.Sequential_IO;
with Interfaces; use Interfaces;
with GNAT.String_Split; use GNAT.String_Split;

with Cpu; use Cpu;

procedure Main is
   --  Package to handle Unsigned_8 in Sequential_IO
   --  Because the LC-3 is a big endian machine, i nneed to read 2 Unsigned_8
   package Unsigned_8_IO is new Ada.Sequential_IO (Unsigned_8);
   use Unsigned_8_IO;

   --  Get the string just after the last specified separator
   function Get_String_After_Separator (Str: String; Separator: Character) return String is
      i : Natural := Str'Last;
   begin
      --  Loop while the separator is not found
      while Str (i) /= Separator loop
         i := i-1;
      end loop;

      if i >= Str'Last then
         return "";
      end if;

      return Str (i+1 .. Str'Last);
   end Get_String_After_Separator;

   --  Emulator memory
   Memory : Cpu.Memory_Array;

   --  Flags
   Program_Provided : Boolean := False;
   Debug_Instructions_Enabled : Boolean := False;
   Debug_Registers_Enabled : Boolean := False;

   --  Input program file name
   Program_File_Name : Unbounded_String;

   --  Program file
   Program_File : Unsigned_8_IO.File_Type;

   --  Temporary values to read the program file
   Instruction_P1 : Unsigned_8;
   Instruction_P2 : Unsigned_8;

   --  Index to store inside memory
   Index : Memory_Index := 0;
begin
   --  Loop through arguments
   for i in 1 .. Argument_Count loop
      --  If the character '-' is at the first position of the argument, it is an optional argument
      if Argument (i)(Argument (i)'First) = '-' then
         --  If the argument is '-di'
         if Argument (i) = "-di" then
            Debug_Instructions_Enabled := true;

         --  If the argument is '-dr'
         elsif Argument (i) = "-dr" then
            Debug_Registers_Enabled := true;

         --  Else it is both
         else
            Debug_Instructions_Enabled := true;
            Debug_Registers_Enabled := true;

         end if;
      
      --  Else it is the source program
      else
         --  Pass the flag to true if it is the only program file provided
         if not Program_Provided then
            Program_Provided := True;
            Program_File_Name := To_Unbounded_String (Argument (i));

         -- Else a program file has already been provided
         else
            Put_Line ("A program was already provided. Exiting.");
            return;
         end if;
      end if;

   end loop;

   --  Error if no program was provided
   if not Program_Provided then
      Put_Line ("A program must be provided. Exiting.");
      return;
   end if;

   --  Error if the program does not exist
   if not Exists (To_String (Program_File_Name)) then
      Put_Line ("The provided program file does not exist. Exiting.");
      return;
   end if;

   --  Error if the provided file is not a .obj file
   if Get_String_After_Separator (To_String (Program_File_Name), '.') /= "obj" then
      Put_Line ("The provided program file must be a '.obj'. Exiting.");
      return;
   end if;

   --  Print selected arguments
   Put_Line ("[x] Using program file : " & Program_File_Name);
   if Debug_Instructions_Enabled then
      Put_Line ("[x] Debug instructions enabled");
   end if;
   if Debug_Registers_Enabled then
      Put_Line ("[x] Debug registers enabled");
   end if;

   --  Open the program file
   Open (Program_File, In_File, To_String (Program_File_Name));

   --  Fill the memory
   while not End_Of_File (Program_File) loop
      --  Read the first byte of an instruction
      Read (Program_File, Instruction_P1);

      --  If it's the end of the file, the program file is odd
      if End_Of_File (Program_File) then
         Put_Line ("The provided program has an odd size. Exiting.");
         return;
      end if;

      --  Read the second byte of an instruction
      Read (Program_File, Instruction_P2);

      --  Fill the memory
      Memory (Index) := Shift_Left (Unsigned_16 (Instruction_P1), 8) or Unsigned_16 (Instruction_P2);

      Index := Index + 1;
   end loop;

   --  Close the file
   Close (Program_File);

   Load_Memory (Memory);
   Start;
end Main;