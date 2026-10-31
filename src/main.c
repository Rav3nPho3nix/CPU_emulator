#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

extern void load_memory(uint16_t *t);
extern void start();

extern void adainit();
extern void adafinal();

#define TEST 2

int main(int argc, char *argv[]) {
    // 2**16 = 65536
    uint16_t tab[65536];

    // Temporary
    // Fill the memory
#if TEST == 0
    // Example program to test ADD instructions

    // ADD with R0 the immediate value 1 => store in R1
    // 0001 001 000 1 0 0001
    tab[0] = 0b0001001000100001;

    // ADD with R1 the immediate value 4 => store in R1
    // 0001 001 001 1 0 0100
    tab[1] = 0b0001001001100100;

    // ADD with R1 the immediate value -1 => store in R0
    // 0001 000 001 1 0 1111
    tab[2] = 0b0001000001111111;

    // ADD with R0 the immediate value -4 => store in R0
    // 0001 000 000 1 1 1101
    tab[3] = 0b0001000000111100;

    // Halt
    tab[4] = 0b1111000000000000;

#elif TEST == 1
    // Example program to test AND instructions

    // ADD with R0 the immediate value 6 => store in R0
    // 0001 000 000 1 0 0110
    tab[0] = 0b0001000000100110;

    // ADD with R1 the immediate value 5 => store in R1
    // 0001 001 001 1 0 0110
    tab[1] = 0b0001001001100110;

    // AND with R1 the immediate value 4 => store in R1
    // 0101 001 001 1 0 0100
    tab[2] = 0b0101001001100100;
    // Should store in R1 the value 4

    // AND with R0 and R1 => store in R2
    // 0101 010 000 0 00 001
    tab[3] = 0b0101010000000001;

    // Halt
    tab[4] = 0b1111000000000000;

#elif TEST == 2
    // Example program to test BR instructions

    // ADD with R0 the immediate value 1 => store in R0
    // 0001 000 000 1 0 0001
    tab[0] = 0b0001000000100001;
    // R0 = 1

    // ADD with R0 the immediate value 1 => store in R0
    // 0001 000 000 1 0 0001
    tab[1] = 0b0001000000100001;
    // R0 = 2

    // Branch if the last instruction result is positive
    // to 2 instructions laters
    // 0000 001 000000010
    tab[2] = 0b0000001000000010;

    // Branch if the last instruction result is negative
    // to 4 instructions later
    // 0000 010 000000100
    tab[3] = 0b0000010000000100;

    // Just here to use memory
    tab[4] = 0b0000000000000000;

    // ADD with R0 the immediate value -2 => store in R0
    // 0001 000 000 1 1 1110
    tab[5] = 0b0001000000111110;
    // R0 = 0

    // Branch with no condition
    // to 5 instructions before
    // 0000 111 111111011
    tab[6] = 0b0000111111111011;

    // Just here to use memory
    tab[7] = 0b0000000000000000;

    // Halt
    tab[8] = 0b1111000000000000;

    // The order of execution will be : 0, 1, 2, 5, 6, 2, 3, 8

#endif

    adainit();
    load_memory(tab);
    start();
    adafinal();

    exit(EXIT_SUCCESS);
}