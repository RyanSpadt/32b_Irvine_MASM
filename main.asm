; CPSC 232 - Assignment 8
; Instructor: Robert Marmelstein
; Author: Ryan Spadt
; Revisions: 0.0
; Date: 11 December 2020


.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword


INCLUDE all.inc


.data



.code

; ***************************************************************************************
;								MAIN PROCEDURE
; Description: 
;	Main Procedure of Program
;	Initializes FPU stack and makes procedure calls
; Receives:
; Returns:
; Pre-conditions:
; Registers Changed:
; ***************************************************************************************
main PROC

	finit											; Initializes FPU stack.

	call _initConsole								; call to _initConsole procedure
	call _quadFormula								; call to _quadFormula procedure
	call _close										; call to _close procedure

main endp


_close PROC
	invoke ExitProcess, 0							; close down program
_close endp

END main