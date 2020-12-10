; CPSC 232 - Assignment 3
; Author: Ryan Spadt
; Revisions: 0
; Date: 6 October 2020


.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword


INCLUDE	Irvine16.inc


.data
welcome1		BYTE	"CPSC 232 - Assignment 3", 0					; Welcome message
buffer		BYTE	20	DUP(?)											; 20 character uninitialized string
bufferRev	BYTE	20	DUP(?)											; uninitialized 20 character string
message1	BYTE	"Enter a string 20 characters or less >> ", 0		; message 1 prompt input
stringSize	DWORD	?													; uninitialized byte
message2	BYTE	"Your string reversed is: ", 0						; message 2
pTrue		BYTE	"Your string is a palindrome!", 0					; palindrome true
pFalse		BYTE	"Your string is not a palindrome.", 0				; palindrome false


.code
main proc
	
	mov		edx,OFFSET	welcome1	; welcome message
	call	WriteString				; push to display edx contents
	call	Crlf					; new line
	mov		edx,OFFSET	message1	; move message1 into edx register
	call	WriteString				; Display what is in edx register (message1)

	mov		edx,OFFSET	buffer		; move our buffer into the edx register to accept input
	mov		ecx,SIZEOF	buffer		; Assign the size of buffer (20) into the ecx register
	call	ReadString				; Call to Read string to indicate we want to write into edx register
	mov		stringSize, eax			; Store the number of characters read into buffer

	cmp		eax, 0			; comparing the input accepted to an empty string to see if input was empty
	je		error					; jump to error if equal

	push	edx						; push the edx value to the top of the stack

	mov		edx, OFFSET	message2	; move message2 into edx register
	call	WriteString				; display the message2 to the prompt out of edx register
	pop		edx						; restore edx register to what is on the top stack (input string)

	mov		ecx, stringSize			; Move the number of characters in int to the ecx register
	mov		esi, 0

	L1: movzx eax,buffer[esi]		; get the character from buffer at location of esi
		push eax					; push the character from eax register onto the stack
		inc  esi					; increment esi register to get through the entirety of the string
		loop L1						; call to begin loop again

    mov  ecx,stringSize				; Move the string size into the ecx register
    mov  esi,0					

	L2: pop  eax					; grab whats on the top of the stack (should be last character of our input string)
		mov  bufferRev[esi],al      ; store that character into buffer
		inc  esi					; increment esi
		loop L2						; call to loop 2


    mov		edx,OFFSET bufferRev	; move our now reversed string thats stored in buffer to the edx register
	call	WriteString				; output the reversed string from inside edx
	call	Crlf					; new line

	mov		ecx,stringSize				; move the string size into the ecx register
	mov		esi, 0			

	L3: movzx eax,buffer[esi]			; move the character at location esi in buffer into eax
		movzx ebx,bufferRev[esi]		; move the character at location esi in buffer into ebx
		cmp eax, ebx					; compare the character in eax and ebc
		jne	paliFalse					; jump if they are not equal to paliFalse
		inc	esi							; if they are equal increment esi and re-loop
		loop L3

	jmp	paliTrue						; if loop makes it through all the way we know they are palindromes

	paliFalse:
		mov	edx,OFFSET	pFalse		; output the palindrome false message
		call	WriteString			; writes to console the message in edx
		jmp close
	
	paliTrue:
		mov	edx,OFFSET	pTrue		; output the palindrome true message
		call	WriteString			; writes to console the message in edx
		jmp	close

	error:
		jmp	close

	close:
		; just passes over everything else

	invoke ExitProcess, 0
main endp
end main
