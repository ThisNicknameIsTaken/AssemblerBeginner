TITLE      (Lab3.asm)
; Library Test #1: Integer I/O   (InputLoop.asm)

; Tests the Clrscr, Crlf, DumpMem, ReadInt, SetTextColor, 
; WaitMsg, WriteBin, WriteHex, and WriteString procedures.

INCLUDE Irvine32.inc

.data
buffer BYTE 21 DUP(?)					;	
outString BYTE 20 DUP(?),0				;
reverseOutString BYTE 20 Dup(?),0		;
upperReverseString BYTE 20 Dup(?),0		;
inputByteCount DWORD ?					;

.code
main PROC
	
mov edx, OFFSET buffer					;
mov ecx, (SIZEOF buffer)-1				;

call ReadString							;
mov inputByteCount, eax					;

xor edi, edi							;
mov ecx,inputByteCount					;
copy1:
	mov al, buffer[edi]					;
	mov outString[edi],al				;
	inc edi								;
	loop copy1							;


call Crlf								;
mov edx,OFFSET outString				;
call WriteString 						;
				

xor edi, edi							;
mov ecx,inputByteCount					;
copyReverse:
	mov al, buffer[edi]					;
	mov reverseOutString[ecx-1],al		;
	movzx ebx,al						;
	push ebx							;
	call	UpperCase					;
	mov upperReverseString[ecx-1],al	;
	inc edi								;
	loop copyReverse	
	
call Crlf								;
mov edx,OFFSET reverseOutString			;
call WriteString 						;


call Crlf								;
mov edx,OFFSET upperReverseString		;
call WriteString 						;
call Crlf								;
call WaitMsg							;

main ENDP


Uppercase PROC							; convert stack char arg to uppercase
	push	ebp
	mov	ebp,esp
	
	mov	al,[esp+8]						; AL = character
	cmp	al,'Z'							; less than 'Z'?
	jb	L1								; yes: convert	
	cmp	al,'z'							; greater than 'z'?							;
	ja	L2								; yes: do nothing
	jb	L2_2						    ; no: convert it
	pop ebp								;
	ret 4

L1:
    cmp al,'A'							;
	ja L1_2								;						;
	pop ebp								;
	ret 4								;
L1_2:
	add al,32							;
	pop	ebp	
	ret	4	

L2:	pop	ebp		
	ret	4								; clean up the stack

L2_2:
	cmp al,'a'							;
	jb L2								;
	sub al,32							;
	pop ebp								;
	ret 4								;
Uppercase ENDP


END main
