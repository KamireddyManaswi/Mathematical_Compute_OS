[BITS 16]
[ORG 0x7C00]

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00        ; Stack below boot sector

    mov si, boot_msg
    call print_str

    jmp kernel

kernel:
    mov si, kern_msg
    call print_str

    mov si, fact_msg
    call print_str

    ; Math demo: Compute factorial 6 = 720
    mov ax, 1              ; fact = 1
    mov cx, 6              ; n = 6
fact_loop:
    mul cx                 ; ax *= cx
    loop fact_loop         ; cx--, loop if cx > 0

    ; Print digits of ax (720)
    push ax                ; Save result
print_num:
    mov bx, 10
    xor dx, dx
    div bx                 ; ax /= 10, dx = remainder
    add dl, '0'
    mov [digit_buf], dl    ; Store digit
    push ax
    test ax, ax
    jnz print_num

    ; Print digits in reverse (pop stack)
print_digits:
    pop ax
    test ax, ax
    jz print_done
    mov si, digit_buf
    mov al, [si]
    mov ah, 0x0E
    int 0x10
    jmp print_digits
print_done:
    pop ax                 ; Discard saved result

    mov si, done_msg
    call print_str

hang: hlt
    jmp hang

print_str:
    mov ah, 0x0E
.loop: lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done: ret

boot_msg db 'Booting kernel...', 13, 10, 0
kern_msg db 'Kernel OK', 13, 10, 0
fact_msg db 'Fact(6)=', 0
done_msg db ' Math OS ready!', 13, 10, 0
digit_buf db 0
ten dw 10

times 510-($-$$) db 0
dw 0xAA55