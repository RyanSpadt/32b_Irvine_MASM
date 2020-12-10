; File contains: _quadFormula Procedure

INCLUDE all.inc


.data
coeA			REAL4	0.0
coeB			REAL4	0.0
coeC			REAL4	0.0
two				REAL4	2.0
four			REAL4	4.0
zero			Real4	0.0
imaginaryNum	BYTE	"This polynomial has an imaginary root.",0
divideZero		BYTE	"A is 0, and you cannot divide by 0.", 0
root1Text		BYTE	"Root 1: ",0
root2Text		BYTE	"Root 2: ",0
temp			Real4	0.0
root1			Real4	0.0
root2			Real4	0.0

.code

; ***************************************************************************************
;								_QUADFORMULA PROCEDURE
; Description: Accepts the three coefficients via the FPU stack and calculates their roots using the quadratic formula
; Receives: ST(0)=C ST(1)=B ST(2)=A
; Returns: The two roots to console
; Pre-conditions: must have accepted input from the console in _initConsole procedure
; Registers Changed: edx, ax,
; Stack Changed: ST(0) ST(1) ST(2)
; ***************************************************************************************
_quadFormula PROC

	fstp coeC										; save C into memory
	fstp coeB										; save B into memory
	fstp coeA										; save A into memory


	; Is A==0?
	; -----------------------------------------------------------------------------------------------------
	fld coeA
	fcomp zero										; compare ST(0) to 0.0
	fnstsw ax										; move status word into AX
	sahf											; copy AH into EFLAGS
	ja L1											; 
	jb L1											; if A is less than or greater than 0 skip the cannot divide by 0 error
	mov edx,OFFSET divideZero						; Move into edx register divideZero message
	call WriteString								; write to console
	jmp _end										; jump to _end


	; Compute sqrt(B^2-4AC)
	; -----------------------------------------------------------------------------------------------------
	L1:
		fld four										; move 4.0 into ST(0)
		fld coeA										; move A into ST(0) now: ST(0)=A, ST(1) = 4
		FMUL											; 4*A
		fld coeC										; move C into ST(0), now: ST(0)=C, ST(1)=4*A
		FMUL											; 4*A*C

		fld coeB										; move B into ST(0), now: ST(0)=B, ST(1)=4*A*C
		fld coeB										; ST(0)=B and now ST(1)=B, ST(2)=4*A*C
		FMUL											; ST(0)*ST(1) or B*B = B^2 now: ST(0)=B^2, ST(1)=4*A*C

		FSUBR											; ST(0)= B^2 - 4*A*C
		fst temp										; Store result into temp because fcomp is destructive

		
		; Compare our result inside of the square root to 0 to determine if it's negative

		fcomp zero										; compare ST(0) to 0.0
		fnstsw ax										; move status word into AX
		sahf											; copy AH into EFLAGS
		jna L2											; not greater? imaginary number

		fld temp										; ST(0) = B^2 - 4*A*C
		fsqrt											; ST(0) = SQRT(B^2 - 4*A*C)
		fst temp										; store this result into temp because we no longer need the old value


		; -B + sqrt(B^2-4*A*C) / 2A
		; -------------------------------------------------------------------------------------------------
		fld coeB										; ST(0)=B and ST(1)= SQRT(B^2 - 4*A*C)							
		Fchs											; ST(0)=-B and ST(1)= SQRT(B^2 - 4*A*C)
		FADD											; ST(0)=-B + SQRT(B^2 - 4*A*C)

		fld two											; ST(0)=2 and ST(1)=-B + SQRT(B^2 - 4*A*C)
		fld coeA										; ST(0)=A and ST(1)=2 and ST(2)=-B + SQRT(B^2 - 4*A*C)
		FMUL											; ST(0)=2A and ST(1)=-B + SQRT(B^2 - 4*A*C)

		FDIV											; ST(0)= (-B + SQRT(B^2 - 4*A*C)) / 2A
		fstp root1										; store result into root1


		; -B - sqrt(B^2-4*A*C) / 2A
		; -------------------------------------------------------------------------------------------------
		fld temp										; ST(0) = SQRT(B^2 - 4*A*C)
		fld coeB										; ST(0)=B and ST(1)= SQRT(B^2 - 4*A*C)	
		Fchs											; ST(0)=-B and ST(1)= SQRT(B^2 - 4*A*C)
		FSUBR											; ST(0)=-B - SQRT(B^2 - 4*A*C)

		fld two											; ST(0)=2 and ST(1)=-B - SQRT(B^2 - 4*A*C)
		fld coeA										; ST(0)=A and ST(1)=2 and ST(2)=-B - SQRT(B^2 - 4*A*C)
		FMUL											; ST(0)=2A and ST(1)=-B - SQRT(B^2 - 4*A*C)

		FDIV											; ST(0)= (-B - SQRT(B^2 - 4*A*C)) / 2A
		
		fld root1										; ST(0)=root1 and ST(1)=root2

		mov edx, OFFSET root1Text						; move root1Text into edx
		call WriteString								; display to console
		call WriteFloat									; Write the float in ST(0) to console
		fstp root1										; pop root1 back out of ST(0) now ST(0)=root2
		call crlf										; new line

		mov edx, OFFSET root2Text						; move root2Text into edx
		call WriteString								; display to console
		call WriteFloat									; Write the float in ST(0) to console
		; -------------------------------------------------------------------------------------------------

		jmp _end										; jump over imaginary num text

	L2:
		mov edx,OFFSET imaginaryNum						; move imaginaryNum into edx
		call WriteString								; display to console

	_end:
		ret												; return to calling procedure

_quadFormula endp
END