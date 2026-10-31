# CPU Emulator

## Presentation

LC-3 CPU Emulator made in ADA.

## Compilation

Compilation :
```make```

## Execution

Usage : `./bin/cpu.out [OPTIONS] path/to/program.asm`

Here are the availables options :

|Options name|Command-line argument|Description|
|---|---|---|
|Registers debug mode|`-dr`|print registers values at every step of the execution|
|Instructions debug mode|`-di`|print instruction currently executed at every step of the execution|
|Debug mode|`-d`|Enable the two debug modes|