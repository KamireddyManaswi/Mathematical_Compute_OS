AS = nasm
CC = gcc
LD = ld

CFLAGS = -m32 -ffreestanding -fno-pie -nostdlib -Os -c -fno-stack-protector -Wno-unused-function
LDFLAGS = -m elf_i386 -Ttext 0x1000 -Tdata 0x1000 -Tbss 0x2000 --oformat binary

all:
	$(AS) -f bin boot.asm -o boot.bin
	$(CC) $(CFLAGS) kernel.c -o kernel.o
	$(LD) $(LDFLAGS) kernel.o -o kernel.bin

	# Create 1.44MB floppy image
	dd if=/dev/zero of=os.img bs=512 count=2880
	dd if=boot.bin of=os.img conv=notrunc
	dd if=kernel.bin of=os.img bs=512 seek=1 conv=notrunc

run:
	qemu-system-i386 -fda os.img

clean:
	rm -f *.bin *.o *.img