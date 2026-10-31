with Ada.Command_Line; use Ada.Command_Line;
with Ada.Numerics.Generic_Complex_Types;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Directories; use Ada.Directories;

with GNAT.String_Split; use GNAT.String_Split;

with Cpu; use Cpu;

procedure Main is
   --  Emulator memory
   Memory : Cpu.Memory_Array;

   --  Flags
   Program_Provided : Boolean := False;
   Debug_Instructions_Enabled : Boolean := False;
   Debug_Registers_Enabled : Boolean := False;

   --  Input program fle name
   Program_File_Name : Unbounded_String;

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


   --  Example program to test ADD instructions

   --  ADD with R0 the immediate value 1 => store in R1
   --  0001 001 000 1 0 0001
   Memory (0) := 2#0001001000100001#;

   --  ADD with R1 the immediate value 4 => store in R1
   --  0001 001 001 1 0 0100
   Memory (1) := 2#0001001001100100#;

   --  ADD with R1 the immediate value -1 => store in R0
   --  0001 000 001 1 0 1111
   Memory (2) := 2#0001000001111111#;

   --  ADD with R0 the immediate value -4 => store in R0
   --  0001 000 000 1 1 1101
   Memory (3) := 2#0001000000111100#;

   --  Halt
   Memory (4) := 2#1111000000000000#;

   Load_Memory (Memory);
   --  Start;
end Main;