CC = gcc
AS = nasm

CFLAGS = -m32 -ffreestanding -fno-pie -nostdlib -c
LDFLAGS = -m elf_i386 -T linker.ld

all:
	$(AS) -f bin boot.asm -o boot.bin
	$(CC) $(CFLAGS) kernel.c -o kernel.o
	ld $(LDFLAGS) kernel.o -o kernel.bin

	dd if=/dev/zero of=os.img bs=512 count=2880
	dd if=boot.bin of=os.img conv=notrunc
	dd if=kernel.bin of=os.img bs=512 seek=1 conv=notrunc

run:
	qemu-system-i386 -fda os.img

clean:
	rm -f *.bin *.o *.img