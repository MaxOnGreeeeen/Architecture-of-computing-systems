
.386
.model flat, stdcall
option casemap :none
include includes\windows.inc
include includes\masm32.inc
include includes\kernel32.inc
include includes\macros\macros.asm
include includes\msvcrt.inc
includelib includes\masm32.lib
includelib includes\kernel32.lib
includelib includes\msvcrt.lib

.data
	; указываем форматы вывода
	print_x db "%x", 0 
	print_int db "%d",0
	print_char db "%c",0
	print_string db "%s",0
	printInput db 'Enter the a variable value:  ', 0
	decOutput db "Decimal: ", 0
	hexOutput db "Hex: ", 0
	xOutput db " x = ", 0
	theY1Value db " y1 = ", 0
	theY2Value db "y2 = ", 0
	counter dd 15
	space db " ", 0 
	
.data?
	inputValue dd ?
	firstYVariable dd ?
	secondYVariable dd ?
	result dd ?
	
	
.code
start:
	
	invoke crt_printf, offset print_string, addr printInput
	invoke crt_scanf, offset print_int, offset inputValue
	
	mov eax, inputValue
	
	mov ecx, 15
	
	CYCL:
		push ecx
		mov counter,ecx
		mov eax,counter
		
		cmp eax, inputValue
		jg x_less_then_a; меньше а 
		
		cmp eax, inputValue
		jle x_less_orequals_a; <= а
		
		cmp inputValue, 3
		jg a_more_then
		
		cmp inputValue, 3
		jle a_less_then
		
		x_less_orequals_a:
			mov eax, inputValue
			sub eax, 7
			mov firstYVariable, eax	
			
		x_less_then_a:
			neg eax
			@module:
				neg eax; берём число с отриц знаком
				js @module;если значение отрицательное(флаг SF = 1), выполняем ещё раз
			add eax, inputValue; a + |x|
			mov firstYVariable, eax	
		a_more_then:
			mov ebx, inputValue
			mov eax, 3
			mul ebx
			mov secondYVariable, eax
			jmp results
	    a_less_then:
	    	mov secondYVariable, 11
		results:
			mov eax,firstYVariable
			sub eax,secondYVariable
			mov result,eax
			
		invoke crt_printf, offset print_string, addr xOutput
		invoke crt_printf, offset print_int, counter
		invoke crt_printf, offset print_char, 10,12
			
		invoke crt_printf, offset print_string, addr theY1Value
		invoke crt_printf, offset print_int, firstYVariable
		invoke crt_printf, offset print_char, 10,12
		
		invoke crt_printf, offset print_string, addr theY2Value
		invoke crt_printf, offset print_int, secondYVariable
		invoke crt_printf, offset print_char, 10,12
			
		invoke crt_printf, offset print_string, addr decOutput
		invoke crt_printf, offset print_int, result
		invoke crt_printf, offset print_char, 10,12
			
		invoke crt_printf, offset print_string, addr hexOutput
		invoke crt_printf, offset print_x, result
		invoke crt_printf, offset print_char, 10,12
	
		pop ecx
		dec ecx
		cmp ecx,0
		je EXIT
		jmp CYCL
	EXIT:
	invoke ExitProcess, 0
exit
end start