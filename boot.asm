[BITS 16]
[ORG 0x7C00]

start:
    mov ah, 0x0E          ; BIOS teletype
    mov al, 'B'
    int 0x10              ; Print 'B'

    ; Set up segments
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Load kernel (sector 2 → 0x1000:0x0000)
    mov ah, 0x02          ; Read sectors
    mov al, 1             ; 1 sector
    mov ch, 0             ; Cylinder 0
    mov cl, 2             ; Sector 2
    mov dh, 0             ; Head 0
    ; dl already set by BIOS (0 for floppy in QEMU)
    mov bx, 0x1000        ; ES:BX = 0x1000:0x0000
    int 0x13
    jc disk_error         ; Handle error if needed

    jmp 0x0000:0x1000     ; Jump to kernel

disk_error:
    mov ah, 0x0E
    mov al, 'E'
    int 0x10
    hlt

times 510-($-$$) db 0
dw 0xAA55               ; Boot signature