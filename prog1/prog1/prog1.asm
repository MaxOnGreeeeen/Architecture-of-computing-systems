.386
.model flat,stdcall
option casemap:none

include includes/kernel32.inc
include includes\user32.inc
includelib includes/kernel32.lib
includelib includes/user32.lib
	
BSIZE equ 15

a equ 20
b equ 7
int_c equ 4
d equ 1
e equ 2
f equ 3
g equ 12
h equ 4
k equ 7
m equ 3

.data
	ifmt db "%d", 0
	buf db BSIZE dup(?)
	res dd ?
	stdout dd ?
	cWritten dd ?
.code
	start:
		
		mov eax, 0
		mov eax, (a - b) + (int_c - d) + ( e + f ) - g + h + (k + m)
		mov res, eax	
		
		invoke GetStdHandle, -11
		mov ebp, offset res
		mov esi, 0
		mov ebx,[ebp][esi]
		mov stdout,eax
		
		invoke wsprintf, ADDR buf, ADDR ifmt, res
		invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, 0
		
		invoke ExitProcess,0
	end start
