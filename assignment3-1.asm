; Author: Ahmet Yilmaz
; Section: CS218 1001 - 2020 Fall
; Date Last Modified: 09/13/2020
; Program Description: This assignment will cover the 
; use of loops and conditional
; code created from jump instructions to work with arrays.

section .data
; System service call values
SERVICE_EXIT equ 60
SERVICE_WRITE equ 1
EXIT_SUCCESS equ 0
STANDARD_OUT equ 1
NEWLINE equ 10

programDone db "Program Done.", NEWLINE
stringLength dq 14

; Lists:

list1 	dd 2078, 3854, 6593, 947, 5252, 1190, 716, 3587, 8014, 9563 
	dd 9821, 3195, 1051, 6454, 5752, 980, 9015, 2478, 5624, 7251
	dd 2936,1073, 1731, 5376, 4452, 792, 2375, 2542, 5666, 2228
	dd 454, 2379, 6066, 3340, 2631, 9138, 3530, 7528, 7152, 1551
	dd 9537, 9590, 2168, 9647, 5362, 2728, 5939, 4620, 1828, 5736

list2	dd 25087, 6614, 6035, 6573, 6287, 5624, 4240, 3198, 5162, 6972
	dd 6219, 1331, 1039, 23, 4540, 2950, 2758, 3243, 1229, 8402
	dd 8522, 4559, 1704, 4160, 6746, 5289, 2430, 9660, 702, 9609
	dd 8673, 5012, 2340, 1477, 2878, 2331, 3652, 2623, 4679, 6041
	dd 4160, 2310, 5232, 4158, 5419, 2158, 380, 5383, 4140, 1874

;----
;Store the required values 
sum dq 0	;store the sum as quad words and initialize to 0
minimum dd 0	;store the minimum as double words	
maximum dd 0	;store the maximum as double words
average dd 0	;store the average as double words 
oddCount db 0	;store the odd count as byte 
evenCount db 0	;store the even count as byte 
ddTwo dd 2	;store number two to later use for average fnc.

;----
;declare CONSTANT length
LIST_LENGTH equ 50	

section .bss
; declare Calculated list
calculatedList resd 50

section .text
global _start
_start:

mov rbx, 0	;index

; -----
;Calculate averages
calculatedAverageLoop:
	mov eax, dword [list1+rbx*4]
	add dword [list2+rbx*4], eax
	mov edx, 0
	div dword [ddTwo]
	mov dword [calculatedList+rbx*4], eax	;move eax to the calculated list
	
	inc rbx		;increment the index value
loop calculatedAverageLoop	;end of loop

	mov eax, dword[calculatedList]	;move list3 to eax register
	mov dword [minimum], eax	;eax to minimum
	mov dword [maximum], eax	;eax to maximum
	mov dword [sum], 0		;sum to 0
	mov ecx, dword [LIST_LENGTH]	;length of an array to ecx register
	mov rbx, 0			;index
statsLoop;
	;-----
	;sum
	mov eax, dword [calculatedList+rbx*4]
	add dword [sum], eax

	;----
	;minimum
	cmp eax, dword [minimum]	;compare the value with next value
	jae skipUpdate	;should jump if more than or equal to new value
	mov dword [minimum], eax
skipUpdate:
	;----
	;maximum
	cmp eax, dword [maximum]
	jbe skipUpdate1	;should jump if less than or equal to new value
	mov dword [maximum], eax
skipUpdate1:
		
	inc rbx		;increment the value in array
loop statsLoop		;end of loop

;------
;Check to see if a value is an even or odd 
mov eax, dword[calculatedList]
mov ebx, 2
cdq
idiv ebx	;remainder stored in edx
cmp edx, 0
jne isOdd
	inc byte [evenCount]
	jmp evenOddDone
isOdd:
	inc byte [oddCount]
evenOddDone:

;------
;average
mov eax, dword [sum]
mov edx, 0
div dword[ecx]
mov dword[average], eax

endProgram:
; Outputs "Program Done." to the console
mov rax, SERVICE_WRITE
mov rdi, STANDARD_OUT
mov rsi, programDone
mov rdx, qword[stringLength]
syscall

; Ends program with success return value
mov rax, SERVICE_EXIT
mov rdi, EXIT_SUCCESS
syscall
