AS = nasm
CC = gcc
LD = ld

CFLAGS = -m32 -ffreestanding -fno-pie -nostdlib -Os -c -fno-stack-protector -fno-builtin -Wall
LDFLAGS = --oformat binary -T linker.ld

all:
	$(AS) -f bin boot.asm -o boot.bin
	$(CC) $(CFLAGS) kernel.c -o kernel.o
	$(LD) $(LDFLAGS) kernel.o -o kernel.bin
	dd if=/dev/zero of=kernel.pad bs=512 count=1 conv=notrunc
	truncate -s 512 kernel.bin  # Ensure exactly 1 sector

	dd if=/dev/zero of=os.img bs=512 count=2880
	dd if=boot.bin of=os.img conv=notrunc
	dd if=kernel.bin of=os.img bs=512 seek=1 conv=notrunc

run: all
	qemu-system-i386 -fda os.img -serial stdio

clean:
	rm -f *.bin *.o *.img *.pad