[BITS 16]
[ORG 0x7C00]

start:
    cli

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov si, boot_msg
    call print_str


; load kernel from disk (sector 2 onwards) to memory 0x1000

    mov ah, 0x02
    mov al, 10        ; number of sectors to read
    mov ch, 0
    mov cl, 2         ; start reading from sector 2
    mov dh, 0
    mov dl, 0x00
    mov bx, 0x1000    ; memory location for kernel
    int 0x13


; jump to kernel

    jmp 0x0000:0x1000



print_str:
    mov ah, 0x0E
.next:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next
.done:
    ret


boot_msg db "Booting kernel...",13,10,0


times 510-($-$$) db 0
dw 0xAA55