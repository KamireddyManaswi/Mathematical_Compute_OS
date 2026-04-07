[BITS 16]
[ORG 0x7C00]

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, boot_msg
    call print_str

    mov si, kern_msg
    call print_str

    mov si, fact_msg
    call print_str

    ; -------- factorial 6 = 720 --------
    mov ax, 1
    mov cx, 6

fact_loop:
    mul cx
    loop fact_loop

    ; now AX = 720

    call print_number

    mov si, done_msg
    call print_str

hang:
    jmp hang

; ---------------- PRINT NUMBER ----------------
print_number:
    mov bx, 10
    xor cx, cx

convert:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne convert

print_digits:
    pop dx
    add dl, '0'
    mov ah, 0x0E
    mov al, dl
    int 0x10
    loop print_digits

    ret

; ---------------- PRINT STRING ----------------
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

; ---------------- DATA ----------------
boot_msg db 'Booting kernel...',13,10,0
kern_msg db 'Kernel OK',13,10,0
fact_msg db 'Fact(6)=',0
done_msg db ' Math OS ready!',13,10,0

times 510-($-$$) db 0
dw 0xAA55