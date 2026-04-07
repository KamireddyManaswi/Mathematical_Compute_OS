[BITS 16]
[ORG 0x7C00]

start:
    ; setup segments
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; print B
    mov ah, 0x0E
    mov al, 'B'
    int 0x10

    ; load kernel at 0x1000:0000
    mov ax, 0x1000
    mov es, ax
    xor bx, bx

    mov ah, 0x02
    mov al, 10          ; load 10 sectors (matches your kernel size)
    mov ch, 0
    mov cl, 2
    mov dh, 0
    ; IMPORTANT: DO NOT overwrite DL (BIOS sets it)
    int 0x13

    jc disk_error

    ; jump to kernel
    jmp 0x1000:0000

disk_error:
    mov si, msg
    call print
    jmp $

print:
    mov ah, 0x0E
.next:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next
.done:
    ret

msg db "Disk Error!",0

times 510-($-$$) db 0
dw 0xAA55