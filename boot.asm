[BITS 16]
[ORG 0x7C00]

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, msg_boot
    call print_string

    ; Load kernel sector 2 to 0x1000
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov bx, 0x1000  ; ES:BX
    int 0x13
    jc error

    jmp 0x1000

error:
    mov si, msg_err
    call print_string
    hlt

print_string:
    mov ah, 0x0E
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

msg_boot db 'Booting kernel...', 0
msg_err  db 'Load error!', 0

times 510-($-$$) db 0
dw 0xAA55