AS = nasm
CC = gcc
LD = ld
OBJCOPY = objcopy

CFLAGS = -m32 -ffreestanding -fno-pie -nostdlib -Os -c -fno-stack-protector -fno-builtin -Wall -Wno-int-conversion
LDFLAGS = -m elf_i386 -T linker.ld -nostdlib

all:
	$(AS) -f bin boot.asm -o boot.bin
	$(CC) $(CFLAGS) kernel.c -o kernel.o
	$(LD) $(LDFLAGS) kernel.o -o kernel.elf
	$(OBJCOPY) -O binary kernel.elf kernel.bin

	dd if=/dev/zero of=os.img bs=512 count=2880
	dd if=boot.bin of=os.img conv=notrunc
	dd if=kernel.bin of=os.img bs=512 seek=1 conv=notrunc

run:
	qemu-system-i386 -fda os.img

clean:
	rm -f *.bin *.o *.elf *.img