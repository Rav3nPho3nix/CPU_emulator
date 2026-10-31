# CPU Emulator

## Presentation

LC-3 CPU Emulator made in ADA.

## ToDo
- [ ] Implement all instructions
- [ ] Implement file reading
- [ ] Add registers debug mode mode (hex, binary, decimal)

## Usage

Here are the availables arguments :
* `-dr` (registers debug mode) : print registers every step of the execution
* `-di` (instructions debug mode) : print instructions before every step of the execution
* `-t=[BR|ADD|LD|...|LEA|TRAP]` (test program) : execute a test program for the specified instruction.
(if the argument `-e=...` is passed multiples times, the last one is taken)
* `-e=...` (example program) : execute an exemple program with the specified name.