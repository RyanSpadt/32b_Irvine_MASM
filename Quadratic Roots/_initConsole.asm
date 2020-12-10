; File contains: _initConsole Procedure

INCLUDE all.inc

.data
welcomeMsg		BYTE	"CPSC 232 - Assignment 8", 0						; Welcome Message
coeAtext		BYTE	"Coefficient (A) for Ax^2 + Bx + C: ", 0			; Text for coefficient A
coeBtext		BYTE	"Coefficient (B) for Ax^2 + Bx + C: ", 0			; Text for coefficient B
coeCtext		BYTE	"Coefficient (C) for Ax^2 + Bx + C: ", 0			; Text for coefficient C


.code

; ***************************************************************************************
;								_INITCONSOLE PROCEDURE
; Description: Displays welcome message and takes input from the console storing in FPU Stack
; Receives: Input from console
; Returns: 
; Pre-conditions: Must call from main
; Registers Changed: edx
; Stack Changed: ST(0)=C ST(1)=B ST(2)=A
; ***************************************************************************************
_initConsole PROC

	mov edx, OFFSET welcomeMsg						; move welcomeMsg into edx
	call WriteString								; display message1 to console
	call crlf										; new line
	call crlf										; new line

	mov edx, OFFSET coeAtext						; move coeAtext into edx
	call WriteString								; display message1 to console
	call ReadFloat									; Read a float into ST(0)

	mov edx, OFFSET coeBtext						; move coeAtext into edx
	call WriteString								; display message1 to console
	call ReadFloat									; Read a float into ST(0)

	mov edx, OFFSET coeCtext						; move coeAtext into edx
	call WriteString								; display message1 to console
	call ReadFloat									; Read a float into ST(0)

	ret

_initConsole endp
END