; Multiboot 1 header + entry for i386 (32-bit).
; Assemble: nasm -f elf32 boot.asm -o boot.o

global _start
extern kernel_main

section .multiboot
align 4
        dd 0x1BADB002            ; magic
        dd 0                     ; flags
        dd -(0x1BADB002 + 0)     ; checksum

section .text
bits 32

_start:
        cli
        mov esp, stack_top
        call kernel_main
.hang:
        hlt
        jmp .hang

section .bss
align 16
stack_bottom:
        resb 32768
stack_top: