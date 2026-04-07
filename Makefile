CC = gcc
LD = ld

CFLAGS = -m32 -ffreestanding -fno-pie -nostdlib -c
LDFLAGS = -m elf_i386 -T linker.ld

all:
	$(CC) $(CFLAGS) kernel.c -o kernel.o
	$(LD) $(LDFLAGS) kernel.o -o kernel.bin

run:
	qemu-system-i386 -kernel kernel.bin

clean:
	rm -f *.o *.bin