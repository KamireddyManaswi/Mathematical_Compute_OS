[BITS 16]
[ORG 0x7C00]

start:

    ; BIOS loads bootloader at 0x7C00
    ; load kernel (next sectors) into memory 0x1000

    mov ah, 0x02      ; BIOS read sector function
    mov al, 20        ; number of sectors to read
    mov ch, 0         ; cylinder
    mov cl, 2         ; sector number (start after boot sector)
    mov dh, 0         ; head
    mov dl, 0x00      ; drive (floppy in qemu)
    mov bx, 0x1000    ; memory location
    int 0x13          ; call BIOS

    ; jump to kernel
    jmp 0x0000:0x1000


; fill remaining bytes with 0
times 510-($-$$) db 0

; boot signature
dw 0xAA55