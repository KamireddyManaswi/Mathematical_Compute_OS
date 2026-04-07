AS=nasm
all:
	$(AS) -f bin boot.asm -o boot.bin
	dd if=/dev/zero of=os.img bs=512 count=2880
	dd if=boot.bin of=os.img conv=notrunc

run:
	qemu-system-i386 -fda os.img

clean:
	rm -f *.bin *.img