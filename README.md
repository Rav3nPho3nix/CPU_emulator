# CPU Emulator

## Presentation

LC-3 CPU Emulator made in ADA.

## Compilation

Compilation :
```make```

## Execution

Usage : `./bin/cpu.out [OPTIONS] path/to/binary.obj`

Here are the availables options :

|Options name|Command-line argument|Description|
|---|---|---|
|Registers debug mode|`-dr`|print registers values at every step of the execution|
|Instructions debug mode|`-di`|print instruction currently executed at every step of the execution|
|Debug mode|`-d`|Enable the two debug modes|

## Manually creating .obj file

To manually create an .obj file to store binary before having an LLVM backend to automaticaly compile, i use this command :

`echo "1221 F000" | xxd -r -p > "OUTPUT.obj"`

Le `F000` est l'instruction `halt`.
`1221` is the hex code for an `ADD R1 R0, 1`.