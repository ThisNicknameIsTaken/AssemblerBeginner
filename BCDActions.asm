INCLUDE Irvine32.inc

.data
errorMSG db 'ERROR',0
numOneASCII BYTE 5 DUP(?)        ;  Створюю змінну для 1 chisla v ascii 1236
numTwoASCII BYTE 5 DUP(?)        ;  3446

numOneUnpackedBCD  BYTE 4 Dup(?)  
numTwoUnpackedBCD  BYTE 4 Dup(?)  

numOnePackedBCD  BYTE 2 Dup(?)
numTwoPackedBCD  BYTE 2 Dup(?)

outRes  BYTE 3 Dup(?)           ; size is 3  becuase we can get minus
outString BYTE 4 DUP(?),0

.code
main PROC

mov edx, OFFSET numOneASCII
mov ecx, (SIZEOF numOneASCII)				
call ReadString  
call Crlf  

mov edx, OFFSET numTwoASCII
mov ecx, (SIZEOF numTwoASCII)
call ReadString  
call Crlf


xor edi,edi
mov ecx, 4 ; 4 is size of unpacked number one
convertOne:
  mov al, numOneASCII[edi]
  call convertASCII
  mov numOneUnpackedBCD[edi],al
  inc edi
  loop convertOne


xor edi,edi
mov ecx, 4 ; 4 is size of unpacked number one
convertTwo:
  mov al, numTwoASCII[edi]
  call convertASCII
  mov numTwoUnpackedBCD[edi],al
  inc edi
  loop convertTwo


; pack first num
mov al,numOneUnpackedBCD[0]
mov bl,numOneUnpackedBCD[1]
rcl al,4    ;rotate circular to left al 00001111 -> 11110000
add al,bl
mov numOnePackedBCD[0],al
mov al,numOneUnpackedBCD[2]
mov bl,numOneUnpackedBCD[3]
rcl al,4    ;rotate circular to left al 00001111 -> 11110000
add al,bl
mov numOnePackedBCD[1],al

; pack second num
mov al,numTwoUnpackedBCD[0]
mov bl,numTwoUnpackedBCD[1]
rcl al,4    ;rotate circular to left al 00001111 -> 11110000
add al,bl
mov numTwoPackedBCD[0],al
mov al,numTwoUnpackedBCD[2]
mov bl,numTwoUnpackedBCD[3]
rcl al,4    ;rotate circular to left al 00001111 -> 11110000
add al,bl
mov numTwoPackedBCD[1],al



mov al,numOnePackedBCD[0]
and al, 0f0h
rcr al,4
mov bl,numTwoPackedBCD[0]
and bl, 0f0h
rcr bl,4
sub al,bl
jb Minushh
jae Okhh
Minushh:
    NOT al
    add al, 1
    mov outRes[3], 1
    jmp Nexthh
Okhh:
    mov outRes[3], 0
    das
   
Nexthh:
mov outRes[0],al

;;;;;;;;;2
mov al,numOnePackedBCD[0]
and al, 0fh
mov bl,numTwoPackedBCD[0]
and bl, 0fh
sub al,bl
jb Minushl
jae Okhl
Minushl:
    cmp outRes[3],1
        jne notNeg1
        je Neg1
        notNeg1:
            cmp outRes[0],0
                jne notZ1
                je Neg1
                notZ1:
                  
                    sub outRes[0],1
                    and al, 0fh
                    das

                    
                    cmp bl,9
                    je ne1
                    jne con1
                    ne1:
                    sub al,6
                    jmp con1
    

    Neg1:
    NOT al
    add al, 1
    mov outRes[3], 1
    con1:
    jmp Nexthl
Okhl:
    das
   
Nexthl:
rcl outRes[0],4
add outRes[0],al

;;;;;;;;;;;;;;3
mov al,numOnePackedBCD[1]
and al, 0f0h
rcr al, 4
mov bl,numTwoPackedBCD[1]
and bl, 0f0h
rcr bl, 4
sub al,bl
jb Minuslh
jae Oklh
Minuslh:
      cmp outRes[3],1
        jne notNeg2
        je Neg2
        notNeg2:
            cmp outRes[0],0
                jne notZ2
                je Neg2
                notZ2:
                    
                    sub outRes[0],1
                    and al, 0fh
                    das

                    cmp bl,9
                    je ne2
                    jne con2
                    ne2:
                    sub al,6
                    jmp con2
    

    Neg2:
    NOT al
    add al, 1
    mov outRes[3], 1
    con2:
    jmp Nextlh
Oklh:
    das
mov al,outRes[0]
das
mov outRes[0],al 
 

;;;;;;;;;;;;;;;;;4
Nextlh:
mov outRes[1],al
mov al,outRes[0]
cmp al,0
jne ccon1
das
ccon1:
mov outRes[0],al

mov al,numOnePackedBCD[1]
and al, 0fh
mov bl,numTwoPackedBCD[1]
and bl, 0fh
sub al,bl
jb Minusl
jae Okl
Minusl:
    cmp outRes[3],1
        jne notNeg3
        je Neg3
        notNeg3:
            cmp outRes[1],0
                jne notZ3
                je Neg3
                notZ3:
                 
                    sub outRes[1],1
                    and al, 0fh
                    das

                    cmp bl,9
                    je ne3
                    jne con3
                    ne3:
                    sub al,6

                    jmp con3
    

    Neg3:
    NOT al
    add al, 1
    mov outRes[3], 1
    con3:
    jmp Nextl
Okl:
    das
   
Nextl:
rcl outRes[1],4
and outRes[1],0f0h
add outRes[1],al


;unpack
mov al, outRes[3] ;minus
cmp al,1
jb plus
je minus

plus:
    mov al, 2bh
    jmp fin

minus:
    mov al, 2dh
    jmp fin

fin:
mov outString[0], al


mov al, outRes[0]
and al, 0fh
add al, 30h
mov outString[2], al

mov al, outRes[0]
and al, 0f0h
rcr al, 4
add al, 30h
mov outString[1], al

mov al, outRes[1]
and al, 0fh
add al, 30h
mov outString[4], al

mov al, outRes[1]
and al, 0f0h
rcr al, 4
add al, 30h
mov outString[3], al


mov edx, offset outString
call WriteString             ;  WriteString друкує дані з адреси яка записана в регістрі edx
call Crlf
call WaitMsg            ;  WriteString друкує дані з адреси яка записана в регістрі e

main ENDP


convertASCII PROC
  
  call checkNUM
  cmp ah,0

  ja NoError ;if ah 1 jump to noError
  je KillMe

  KillMe:
    mov edx, OFFSET errorMSG ;else show Error
    call WriteString
    call WaitMsg
    mov ax,4c01h    ; end with error
    int 21h      ;interrupt 21 (terminate program)

  NoError:
  ret  
convertASCII ENDP


checkNUM PROC ;Check if al if ascii 0 to 9 if it is than ah = 1 else ah = 0
mov ah, 0
cmp al, '0'

ja moreZero
jb Finish

moreZero:
  cmp al, '9'
  jb Success
  ja Finish

Success:
  sub al,30h
  mov ah,1
  ret

Finish:
ret
checkNUM ENDP


END main
