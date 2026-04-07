[BITS 16]
[ORG 0x7C00]

start:
    mov [BOOT_DRIVE], dl   ; save boot drive

    ; print B
    mov ah, 0x0E
    mov al, 'B'
    int 0x10

    ; -------- LOAD KERNEL --------
    mov ah, 0x02
    mov al, 10
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [BOOT_DRIVE]   ; ✅ use correct drive
    mov bx, 0x1000
    int 0x13

    jc disk_error          ; if error → jump

    jmp 0x0000:0x1000

disk_error:
    mov si, err_msg
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

BOOT_DRIVE db 0
err_msg db "Disk Error!",0

times 510-($-$$) db 0
dw 0xAA55