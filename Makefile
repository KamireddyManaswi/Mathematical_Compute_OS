CC=i686-elf-gcc
AS=nasm

all:
	nasm -f elf32 boot.asm -o boot.o
	i686-elf-gcc -c kernel.c -o kernel.o -ffreestanding
	i686-elf-gcc -T linker.ld -o mathos.bin -ffreestanding -nostdlib boot.o kernel.o -lgcc

run:
	qemu-system-i386 -kernel mathos.bin

clean:
	rm *.o *.bin