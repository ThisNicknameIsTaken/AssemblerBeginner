; AddTwo.asm - adds two 32-bit integers.
; Chapter 3 example

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.code
main proc

	xor cx, cx							
	mov ch, 97h							
	add	cx, 9210h						

	mov ax, cx							
	add ecx, eax						
	sub cx, ax
	invoke ExitProcess,0
main endp
end main