global _start                   

section .text

_start:

; !/bin/sh
; 
; int execve(const char *filename, char *const argv[], char *const envp[]);
; execve() è definita come #define __NR_execve 11 on /usr/include/i386-linux-gnu/asm/unistd_32.h

xor eax, eax
push eax        ; Il NULL byte
push 0x68732f2f ; "sh//". Il secondo '\' mi serve per allineare il comando nello stack
push 0x6e69622f ; "nib/"
mov ebx, esp    ; EBX punta a  "/bin//sh"

xor ecx, ecx
xor edx, edx    ; execve("/bin/sh", NULL, NULL)
mov al, 0xB     ; 11 in decimal
int 0x80
