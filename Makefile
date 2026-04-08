# i386 Multiboot 1 kernel. Needs: nasm, and a toolchain that can emit 32-bit ELF.
#
# Option A (common on OS dev): install i686-elf-gcc / i686-elf-ld and run:
#   make CROSS_COMPILE=i686-elf-
#
# Option B (Linux with multilib): leave CROSS_COMPILE empty and ensure gcc -m32 works:
#   sudo apt install gcc-multilib  # Debian/Ubuntu
#   make
#
# Run in QEMU:
#   qemu-system-i386 -kernel kernel.elf

CROSS_COMPILE ?=

AS      := nasm
ASFLAGS := -f elf32

CC      := $(CROSS_COMPILE)gcc
CFLAGS  := -std=c11 -ffreestanding -O2 -Wall -Wextra -nostdlib \
           -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables \
           -m32 -march=i686

LD      := $(CROSS_COMPILE)ld
LDFLAGS := -m elf_i386 -nostdlib -T linker.ld

OBJS := boot.o kernel.o

.PHONY: all clean run

all: kernel.elf

boot.o: boot.asm
	$(AS) $(ASFLAGS) $< -o $@

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel.elf: $(OBJS) linker.ld
	$(LD) $(LDFLAGS) $(OBJS) -o $@

clean:
	rm -f $(OBJS) kernel.elf

run: kernel.elf
	qemu-system-i386 -kernel kernel.elf