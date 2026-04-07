# compiler
CC = gcc
ASM = nasm

# flags
CFLAGS = -ffreestanding -m32 -c
LDFLAGS = -m elf_i386 -T linker.ld

# files
C_SOURCES = kernel.c
ASM_SOURCES = boot.asm

OBJECTS = boot.o kernel.o

# default target
all: os.bin

# compile assembly
boot.o: boot.asm
	$(ASM) -f elf32 boot.asm -o boot.o

# compile C
kernel.o: kernel.c
	$(CC) $(CFLAGS) kernel.c -o kernel.o

# link files
os.bin: $(OBJECTS)
	ld $(LDFLAGS) $(OBJECTS) -o os.bin

# run OS in qemu
run: os.bin
	qemu-system-i386 -kernel os.bin

# clean build files
clean:
	rm -f *.o *.bin