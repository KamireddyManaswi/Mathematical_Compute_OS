/*
 * Single-purpose "compute node" kernel: no tasks, no syscalls —
 * boots, runs a few pure math routines, prints results to VGA text.
 *
 * Freestanding: no libc. Build with -ffreestanding -nostdlib.
 */
#include <stdint.h>

#define VGA_WIDTH  80
#define VGA_HEIGHT 25
#define VGA_MEMORY ((volatile uint16_t *)0xB8000)

static void vga_putc(int row, int col, char c, uint8_t color) {
    if (row < 0 || row >= VGA_HEIGHT || col < 0 || col >= VGA_WIDTH)
        return;
    VGA_MEMORY[row * VGA_WIDTH + col] = (uint16_t)(uint8_t)c
                                        | ((uint16_t)color << 8);
}

static void vga_puts(int row, int col, const char *s, uint8_t color) {
    int c = col;
    for (int i = 0; s[i] && c < VGA_WIDTH; i++, c++)
        vga_putc(row, c, s[i], color);
}

static void vga_clear(uint8_t color) {
    for (int r = 0; r < VGA_HEIGHT; r++) {
        for (int c = 0; c < VGA_WIDTH; c++) {
            vga_putc(r, c, ' ', color);
        }
    }
}

static void put_u32(int row, int col, uint32_t n, uint8_t color) {
    char buf[11];
    int i = 0;
    if (n == 0) {
        vga_putc(row, col, '0', color);
        return;
    }
    while (n > 0 && i < (int)sizeof(buf)) {
        buf[i++] = (char)('0' + (n % 10U));
        n /= 10U;
    }
    int c = col;
    while (i > 0 && c < VGA_WIDTH)
        vga_putc(row, c++, buf[--i], color);
}

static void put_i32(int row, int col, int32_t n, uint8_t color) {
    if (n < 0) {
        vga_putc(row, col++, '-', color);
        /* avoid overflow on INT32_MIN */
        uint32_t u = (uint32_t)(-(n + 1)) + 1U;
        put_u32(row, col, u, color);
        return;
    }
    put_u32(row, col, (uint32_t)n, color);
}

void kernel_main(void) {
    const uint8_t plain = 0x07; /* light grey on black */

    vga_clear(plain);

    vga_puts(0, 0, "Math compute kernel (single-purpose OS demo)", plain);
    vga_puts(2, 0, "add: 123 + 456 = ", plain);
    put_u32(2, 19, 123U + 456U, plain);

    vga_puts(3, 0, "sub: 100 - 250 = ", plain);
    put_i32(3, 19, (int32_t)100 - (int32_t)250, plain);

    vga_puts(6, 0, "Done. Halted.", plain);
}