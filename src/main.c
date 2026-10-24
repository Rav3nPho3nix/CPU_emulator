#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

extern void load_memory(uint16_t *t);
extern void start();

extern void adainit();
extern void adafinal();

int main() {
    // 2**16 = 65536
    uint16_t tab[65536];

    // Temporary
    // Fill the memory
    tab[0] = 0b0001000000000000;
    tab[1] = 0b0000111111111111;
    tab[2] = 0b1111000000000000;
    tab[3] = 0b1010101010101010;

    adainit();
    load_memory(tab);
    start();
    adafinal();

    exit(EXIT_SUCCESS);
}