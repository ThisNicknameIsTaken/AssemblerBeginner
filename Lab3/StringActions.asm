TITLE      (Lab3.asm)
; Library Test #1: Integer I/O   (InputLoop.asm)

; Tests the Clrscr, Crlf, DumpMem, ReadInt, SetTextColor, 
; WaitMsg, WriteBin, WriteHex, and WriteString procedures.

INCLUDE Irvine32.inc

.data
buffer BYTE 21 DUP(?)					;	Створюю змінну для буферу
outString BYTE 20 DUP(?),0				;	Створюю змінну для вихідної строки. Розміром 20 байтів, непроініціалізовану
reverseOutString BYTE 20 Dup(?),0		;	Створюю змінну для вихідної строки яка запишеться задом наперед
upperReverseString BYTE 20 Dup(?),0		;	Створюю змінну для вихідної строки яка запишеться задом наперед та літери в ній змінять свій регістр (великий на малий, малий на великий)
inputByteCount DWORD ?					;	Створюю змінну для збереження кількості введених знаків

.code
main PROC
	
mov edx, OFFSET buffer					;	Покажчик на початок буферу
mov ecx, (SIZEOF buffer)-1				;	Максимальна кількість символів що вводяться

call ReadString							;	ReadString зчитає символи введені в консолі в адрессу записану в регістрі edx 
mov inputByteCount, eax					;   Збережемо кількість введених символів

xor edi, edi							;	Очистимо edi
mov ecx,inputByteCount					;	Запишу в ecx кількість введених символів
copy1:									;	Тут буду копіювати по символьно символи з буферу в OutString
	mov al, buffer[edi]					;	Перемістити значення з буферу по індексу який зберігається в edi в регістр al
	mov outString[edi],al				;	Перемстити значення з al в outString по індексу edi
	inc edi								;	Збільшити edi на 1
	loop copy1							;	Loop працює таким чином. Якщо значення в ecx > 0, то перейти на мітку та зменшити еcx на 1 


call Crlf								;	Перемістити кареткку на новий рядок
mov edx,OFFSET outString				;	Перемістити адресу (зміщення до) outString в регістр edx
call WriteString 						;	WriteString друкує дані з адреси яка записана в регістрі edx
				

xor edi, edi							;	Очистити edi
mov ecx,inputByteCount					;	Запишу в ecx кількість введених символів
copyReverse:							;	Скопыюю дані задом-наперед у reverseOutString, а також запишу дані задом наперед та зміню маленькі букви на великі та навпаки
	mov al, buffer[edi]					;	Читаю перший символ із буферу
	mov reverseOutString[ecx-1],al		;	Записую його в індекс який був би останім при прямому заернені. Тобто якщо слово має 5 букв то зараз записую 1 букву на 5 позицію. Будинок => конидуБ
	movzx ebx,al						;	Запис до регістру ebx значення з al з розширення розрядності
	push ebx							;	Записую в стек значеня з регістру ebx
	call	UpperCase					;	Викликаю операцію UpperCase. Результат своєї роботи (символ) запише в al
	mov upperReverseString[ecx-1],al	;	Записую в upperReverseString результат із UpperCases 
	inc edi								;	Збільшую edi на 1
	loop copyReverse					;	Повторюю поки есх більше 0
	
call Crlf								;	Новий рядок
mov edx,OFFSET reverseOutString			;	Записую адресу (зміщення до) рядку який необхідно вивести на екран до регістру edx
call WriteString 						;	Виводжу на екран те що знаходиться за адресою яка записана в edx


call Crlf								;	Новий рядок
mov edx,OFFSET upperReverseString		;	Записую адресу (зміщення до) рядку який необхідно вивести на екран до регістру edx
call WriteString 						;	Виводжу на екран те що знаходиться за адресою яка записана в edx
call Crlf								;	Ноаий рядок
call WaitMsg							;	Повідомлення про очікування натиснення Enter щоб завершити роботу

main ENDP


Uppercase PROC							;	Перетворює літеру яка записана в стеку велику на малу і навпаки
	push	ebp							;	Додаю в стек ebp
	mov	ebp,esp							;	Записую в ebp значення esp
	
	mov	al,[esp+8]						; AL = символ
	cmp	al,'Z'							; Порівняти з 'Z'
	jb	L1								; менще? прейти в l1. jb значить jump below якщо менще то виконати 
	cmp	al,'z'							; greater than 'z'?							
	ja	L2								; yes: do nothing
	jb	L2_2						    ; no: convert it
	pop ebp								;
	ret 4

L1:										;
    cmp al,'A'							;
	ja L1_2								;						
	pop ebp								;
	ret 4								;
L1_2:									;
	add al,32							;
	pop	ebp								;
	ret	4								;

L2:	pop	ebp								;
	ret	4								; clean up the stack

L2_2:
	cmp al,'a'							;
	jb L2								;
	sub al,32							;
	pop ebp								;
	ret 4								;
Uppercase ENDP


END main
