[BITS 16]
[ORG 0x7C00]

start:
    mov ah, 0x0E
    mov al, 'B'
    int 0x10

    ; load kernel (sector 2 → memory 0x1000)
    mov ah, 0x02
    mov al, 1        ; load 1 sector (very important)
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x00
    mov bx, 0x1000
    int 0x13

    jmp 0x0000:0x1000

times 510-($-$$) db 0
dw 0xAA55