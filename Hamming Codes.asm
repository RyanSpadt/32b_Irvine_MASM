; CPSC 232 - Assignment 6 - Hamming Code Analyzer
; Author: Ryan Spadt
; Revisions: 0
; Date: 17 November 2020


.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword


INCLUDE	Irvine16.inc


.data
welcome1		BYTE	"CPSC 232 - Assignment 6", 0							; Welcome message
promptParity	BYTE	"Input the pairty type (0-even, *-odd) >> ", 0			; prompt for parity input
prompt			BYTE	"Please enter an 8 hex digit number: ", 0				; Prompt for input from user
errorBit		BYTE	"The bit in error is: ", 0								; dialog for error bit
valid			BYTE	"valid", 0
bitInError		BYTE	0
parityType		DWORD	0
one				BYTE	0
two				BYTE	0
four			BYTE	0
eight			BYTE	0
sixteen			BYTE	0
threetwo		BYTE	0
count			BYTE	0

oneOutput		BYTE	"1 = ", 0
twoOutput		BYTE	"2 = ", 0
fourOutput		BYTE	"4 = ", 0
eightOutput		BYTE	"8 = ", 0
sixteenOutput	BYTE	"16 = ", 0
threetwoOutput	BYTE	"32 = ", 0


.code

main PROC

	call	_welcome					; call welcome procedure
	call	_setbits					; call to _setbits procedure
	call	_finderror

	output:
		mov		edx,OFFSET	oneOutput
		call	WriteString
		movzx	eax, one
		call	WriteDec
		call	Crlf

		mov		edx,OFFSET	twoOutput
		call	WriteString
		movzx	eax, two
		call	WriteDec
		call	Crlf

		mov		edx,OFFSET	fourOutput
		call	WriteString
		movzx	eax, four
		call	WriteDec
		call	Crlf

		mov		edx,OFFSET	eightOutput
		call	WriteString
		movzx	eax, eight
		call	WriteDec
		call	Crlf

		mov		edx,OFFSET	sixteenOutput
		call	WriteString
		movzx	eax, sixteen
		call	WriteDec
		call	Crlf

		mov		edx,OFFSET	threetwoOutput
		call	WriteString
		movzx	eax, threetwo
		call	WriteDec
		call	Crlf
		call	Crlf

		cmp		ebx, 0
		jz		_valid
		mov		edx,OFFSET	errorBit
		call	WriteString
		mov		eax, ebx
		call	WriteDec
		jmp		_skipvalid

		_valid:
		mov		edx,OFFSET	valid
		call	WriteString

		_skipvalid:

 	invoke ExitProcess, 0
main endp


_welcome PROC

	mov		edx,OFFSET	welcome1		; move welcome1 into edx register
	call	WriteString					; Display what is in edx register (welcome1)
	call	Crlf						; new line
	call	Crlf						; new line
	mov		edx,OFFSET	promptParity	; move promptParity into edx register
	call	WriteString					; write what is in edx
	call	ReadHex						; read hex for desired parity type 0 for even anything else for odd
	cmp		eax, 0						; compare what was just input and read by readhex to 0
	jz		_parityEvenS				; if it's 0 jump to label
	inc		parityType					; if not increment parityType
	_parityEvenS:
	call	Crlf						; new line

	mov		edx,OFFSET	prompt			; move prompt into the edx register
	call	WriteString					; Display what is in edx register (prompt)
	call	ReadHex						; Reads a 32 bit number in hex from the console and stores into eax (max 8 hex digits)

	ret

_welcome endp


_setbits PROC

	call Crlf

	xor		ebx, ebx					; clear out ebx
	xor		edi, edi
	mov		ecx, 32						; move 32 into ecx register	
	mov		esi, 0						; set esi register to 0

L1: cmp		eax, 0						; compare our number to 0
	je		done						; if our number is 0 now jump to done
	test	eax, 1						; test if eax at index 0 is 1
	jnz		bitSet						; if the value is not zero jump to bitSet (the bit there is set to 1)
	inc		esi							; increase loop counter
	shr		eax, 1						; shift right in eax and loop again
	loop	L1
bitSet:
	mov		ebx, esi					; move a copy of the value of esi into ebx register
	inc		ebx							; increment ebx one because esi starts at 0 but our index starts at 1
	push	ebx
	inc		count
	shr		eax, 1						; shift right one in eax
	inc		esi							; increment loop counter
	loop	L1							; call to loop L1

done:
	
	movzx	ecx, count
	mov		esi, 0
	xor		ebx, ebx
	xor		eax, eax

	L2: pop eax
		mov		edi, ecx
		mov		edx, esi

		mov		ecx, 5
		mov		esi, 0

		L3: cmp		eax, 0
			je		innerLoopDone
			test	eax, 1
			jnz		setBit
			inc		esi
			shr		eax, 1
			loop	L3
		setBit:
			mov		ebx, esi
			inc		ebx
			cmp		ebx, 1
			je		_onef
			cmp		ebx, 2
			je		_twof
			cmp		ebx, 3
			je		_fourf
			cmp		ebx, 4
			je		_eightf
			cmp		ebx, 5
			je		_sixteenf
			jmp		_threetwof
		_onef:
			inc		one
			jmp		cont
		_twof:
			inc		two
			jmp		cont
		_fourf:
			inc		four
			jmp		cont
		_eightf:
			inc		eight
			jmp		cont
		_sixteenf:
			inc		sixteen
			jmp		cont
		_threetwof:
			inc		threetwo
			jmp		cont
		cont:
			shr		eax, 1
			inc		esi
			loop	L3
		innerLoopDone:
			mov		ecx, edi
			mov		esi, edx
			inc		esi
			loop	L2

 ret

_setbits endp


_finderror PROC

xor	ebx, ebx
mov eax, parityType							; compare memory location for desired parity here and jump to even if its 0
cmp eax, 0
jz _even_parity								; if pairty selection was even then eax will be 0 and should jump to label if not continue

_odd_parity:

_one_bit_o:
	movzx	eax, one
	and		eax, 1
	cmp		eax, 0
	jnz		_two_bit_o
	inc		ebx
	
_two_bit_o:
	movzx	eax, two
	and		eax, 1
	cmp		eax, 0
	jnz		_four_bit_o
	add		ebx, 2

_four_bit_o:
	movzx	eax, four
	and		eax, 1
	cmp		eax, 0
	jnz		_eight_bit_o
	add		ebx, 4

_eight_bit_o:
	movzx	eax, eight
	and		eax, 1
	cmp		eax, 0
	jnz		_sixteen_bit_o
	add		ebx, 8

_sixteen_bit_o:
	movzx	eax, sixteen
	and		eax, 1
	cmp		eax, 0
	jnz		_odd_done
	add		ebx, 16

_odd_done:
	jmp	_finish

_even_parity:

_one_bit_e:
	movzx	eax, one						; move value of one into eax
	and		eax, 1							; only keep the least significant bit of eax
	cmp		eax, 0							; if one's bit parity is even then the LSB will be 0.
	jz		_two_bit_e
	inc		ebx

_two_bit_e:
	movzx	eax, two						; move value of one into eax
	and		eax, 1							; only keep the least significant bit of eax
	cmp		eax, 0							; if one's bit parity is even then the LSB will be 0.
	jz		_four_bit_e
	add		ebx, 2

_four_bit_e:
	movzx	eax, four						; move value of one into eax
	and		eax, 1							; only keep the least significant bit of eax
	cmp		eax, 0							; if one's bit parity is even then the LSB will be 0.
	jz		_eight_bit_e
	add		ebx, 4

_eight_bit_e:
	movzx	eax, eight						; move value of one into eax
	and		eax, 1							; only keep the least significant bit of eax
	cmp		eax, 0							; if one's bit parity is even then the LSB will be 0.
	jz		_sixteen_bit_e
	add		ebx, 8

_sixteen_bit_e:
	movzx	eax, sixteen					; move value of one into eax
	and		eax, 1							; only keep the least significant bit of eax
	cmp		eax, 0							; if one's bit parity is even then the LSB will be 0.
	jz		_finish
	add		ebx, 16
	
_finish:
ret
_finderror endp

END main