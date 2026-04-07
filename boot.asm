[BITS 16]
[ORG 0x7C00]

start:
    ; Print 'B' to show bootloader is running
    mov ah, 0x0E
    mov al, 'B'
    int 0x10

    ; Load kernel from disk (starting at sector 2)
    mov ah, 0x02      ; BIOS read function
    mov al, 5         ; number of sectors to read
    mov ch, 0         ; cylinder
    mov cl, 2         ; sector (boot = 1, kernel starts at 2)
    mov dh, 0         ; head
    mov dl, 0x00      ; drive (floppy)
    mov bx, 0x1000    ; load address
    int 0x13          ; BIOS interrupt

    ; Jump to kernel
    jmp 0x0000:0x1000

; Fill remaining bytes to make 512 bytes
times 510-($-$$) db 0

; Boot signature (VERY IMPORTANT)
dw 0xAA55