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

    jmp kernel             ; "Load" = jump to kernel code (fits in boot sector)

kernel:
    mov si, kern_msg
    call print_str

    ; Math demo: Compute factorial 6 = 720
    mov ax, 1              ; fact = 1
    mov cx, 6              ; n = 6
fact_loop:
    mul cx                 ; ax *= cx
    loop fact_loop         ; cx--, loop if cx > 0

    ; Print "720 " (digits in ax)
    mov bx, ax
    mov ax, '0'
    mov cx, 3
print_digits:
    mov si, digit_buf + 2  ; 3-digit buffer
    sub si, cx
    mov [si], al
    dec cx
    jz print_fact
    mov dx, 10
    xor dx, dx             ; Divide bx / 10
    mov ax, bx
    div word [ten]
    mov bx, dx             ; Remainder to bx
    mov ax, '0'
    add al, bl
    jmp print_digits
print_fact:
    mov si, digit_buf
    call print_str

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
digit_buf db 0,0,0
ten dw 10

times 510-($-$$) db 0
dw 0xAA55