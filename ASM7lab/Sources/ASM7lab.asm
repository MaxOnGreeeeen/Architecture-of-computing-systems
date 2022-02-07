.386
.model flat, stdcall
option casemap :none
include includes\kernel32.inc
include includes\msvcrt.inc
include includes\windows.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib
includelib includes\msvcrt.lib

BSIZE equ 4
.data
result dd 0
mn_dec dd 10d
mn_div dd 10d

get_error db "ERROR DIVISION BY ZERO!"

get_a db "Enter a: "
a dd ?
get_b db "Enter b: "
b dd ?
get_c db "Enter c: "
@c dd ?
get_d db "Enter d: "
d dd ?
get_e db "Enter e: "
e dd ?
get_f db "Enter f: "
f dd ?
get_g db "Enter g: "
g dd ?
get_h db "Enter h: "
h dd ?
get_k db "Enter k: "
k dd ?
get_m db "Enter m: "
m dd ?
cifri dd 0
stdout dd ?
stdin dd ?

cdkey dd ?

get_result db "(ab+cd+e/f+gh)/(k+m)= "
lineBreak db 0ah, 0dh, 0

buffer_key_1 db ?
buffer_key_2 db ?

get db ?
.code
start:
invoke GetStdHandle, STD_INPUT_HANDLE
mov stdin, eax

invoke GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax

lea esi, [get_a]
call @enter
mov a, eax

lea esi, [get_b]
call @enter
mov b, eax

lea esi, [get_c]
call @enter
call zero
mov @c, eax

lea esi, [get_d]
call @enter
mov d, eax

lea esi, [get_e]
call @enter
mov e, eax

lea esi, [get_f]
call @enter
call zero
mov f, eax

lea esi, [get_g]
call @enter
mov g, eax

lea esi, [get_h]
call @enter
mov h, eax

lea esi, [get_k]
call @enter
mov k, eax

lea esi, [get_m]
call @enter
mov m, eax

invoke WriteConsole, stdout, offset get_result, 21d, 0, 0

mov eax, a
mov ebx, b
mul ebx ; ab
mov a, eax

mov eax, @c
mov ebx, d
mul ebx ; сd
mov @c, eax

mov eax, e
mov ebx, f
div ebx; e/f
mov e, eax

mov eax, g
mov ebx, h
mul ebx ; gh
mov g, eax

mov eax, k
add eax, m; k+m
mov k, eax

mov eax, a
add eax, @c
add eax, e
add eax, g
mov ebx, k
div ebx



call @out

exit



@enter proc

lea edi, [get]
mov ecx, 9d
rep movsb
invoke WriteConsole, stdout, offset [get], 9d, 0, 0

@1:
cmp cifri,4
je @2
invoke ReadConsoleInput, stdin, offset [buffer_key_1], BSIZE, offset cdkey

cmp [buffer_key_1+10d], 0dh
je @2

cmp [buffer_key_1+14d], 0
je @1

cmp [buffer_key_1+14d], 30h
jl @1

cmp [buffer_key_1+14d], 3Ah
jnc @1

cmp [buffer_key_1+04d], 1h
jne @1

invoke WriteConsole, stdout, offset [buffer_key_1+14d], 1, 0, 0

mov eax, result
mul mn_dec
mov result, eax

xor eax, eax
mov al, [buffer_key_1+14d]
sub al, 30h
add result, eax
inc cifri
jmp @1

@2:
cmp cifri, 1
je @1
cmp cifri, 0
je @1
mov [buffer_key_1+10d], 00h
invoke ReadConsoleInput, stdin, offset [buffer_key_1], BSIZE, offset cdkey

invoke WriteConsole, stdout, offset [lineBreak], 2d, 0, 0
mov cifri, 0
mov eax, result
mov result, 0
ret
@enter endp

@out proc
xor ecx, ecx
xor edx, edx

@3:
mov ebx, mn_div
div ebx


add edx, 30h
push edx
xor edx, edx
inc ecx
cmp eax, 0
jne @3


mov edi, 0

@4:
pop edx
mov [buffer_key_2 + edi], dl
inc edi
dec ecx
jnz @4

invoke WriteConsole, stdout, offset [buffer_key_2], 10d , 0, 0
invoke WriteConsole, stdout, offset [lineBreak], 2d, 0, 0
ret
@out endp

zero proc
cmp eax, 0
je @exit
ret

@exit:
invoke WriteConsole, stdout, offset [get_error], 17d, 0, 0
invoke WriteConsole, stdout, offset [lineBreak], 2d, 0, 0
exit
zero endp
end start




