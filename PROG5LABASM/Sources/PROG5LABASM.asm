; Новый проект masm32 успешно создан
; Заполнен демо программой «Здравствуй, мир!»
.386
.model flat, stdcall
option casemap :none
include includes\masm32.inc
include includes\kernel32.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib
.data

	firstNum db "Enter first num  "
	secondNum db 10, "Enter second num "
	permResA db 10, "a =  " 
	permResB db 10, "b =  " 
	multipliedValue db 10,"Multiplied result "
	finalResult db 10, "Swaped bits "
	
	num db ?
	num2 db ?
	permres db ?
	resultFin db ?
	permresFin db ?
	newNum db ?
	buff dd ?
	
	inputValue dd ?
	outputValue dd ?
	
	bufInput dd ?
	bufMyOutput dd ?
	
	count dd 8
	
	myZero db "0"
	myOne db "1"
	
.code
start:
	invoke GetStdHandle, -10
	mov inputValue, eax
	invoke GetStdHandle, -11
	mov outputValue, eax
		
	invoke WriteConsole, outputValue, addr firstNum, sizeof firstNum, addr bufMyOutput, 0
	invoke SetConsoleMode, inputValue, 0
	
	readNum:
		invoke ReadConsole, inputValue, addr buff, 1, addr bufInput, 0
		mov eax, buff 
		;проверяем нажатие клавиши ENTER
		cmp eax, 13 
		je finishInput
		
		sub eax, 30h
		jz zeroBit
		cmp eax, 1
		jne otherNumbers
		invoke WriteConsole, outputValue, addr buff, 1, addr bufMyOutput, 0
		add num, 1
		shl num, 1
		jmp finalNumber
			
		zeroBit:
			invoke WriteConsole, outputValue, addr buff, 1, addr bufMyOutput, 0
			shl num, 1
			jmp finalNumber
		
		otherNumbers:
			jmp readNum
			
		finishInput:
			mov count, 1
			
		finalNumber:
			dec count
			mov eax, count
			jnz readNum
		rcr num, 1
		
		invoke WriteConsole,outputValue, addr permResA, sizeof permResA, addr bufMyOutput, 0
		mov al, num
		mov newNum, al
		mov count, 0
		
		printNum:
			inc count
			cmp count, 9
			je exitOfPrint
			shl newNum, 1
			jc oneBit
			invoke WriteConsole, outputValue, addr myZero, 1, addr bufMyOutput, 0
			jmp printNum
			
		oneBit:
			invoke WriteConsole, outputValue, addr myOne, 1, addr bufMyOutput, 0
			jmp printNum
		exitOfPrint:
			invoke WriteConsole, outputValue, addr secondNum, sizeof secondNum, addr bufMyOutput, 0 ;ВВОД второго числа
			jmp readB
	readB:
		invoke ReadConsole, inputValue, addr buff, 1, addr bufInput, 0
		mov eax, buff 
		;проверяем нажатие клавиши ENTER
		cmp eax, 13 
		je finishInputB
		
		sub eax, 30h
		jz zeroBitB
		cmp eax, 1
		jne otherNumbersB
		invoke WriteConsole, outputValue, addr buff, 1, addr bufMyOutput, 0
		add num2, 1
		shl num2, 1
		jmp finalNumberB
			
		zeroBitB:
			invoke WriteConsole, outputValue, addr buff, 1, addr bufMyOutput, 0
			shl num2, 1
			jmp finalNumberB
		
		otherNumbersB:
			jmp readB
			
		finishInputB:
			mov count, 1
			
		finalNumberB:
			dec count
			mov eax, count
			jnz readB
		rcr num2, 1
		
		invoke WriteConsole,outputValue, addr permResB, sizeof permResB, addr bufMyOutput, 0
		mov al, num2
		mov newNum, al
		mov count, 0
		
		printNumB:
			inc count
			cmp count, 9
			je exitOfPrintB
			shl newNum, 1
			jc oneBitB
			invoke WriteConsole, outputValue, addr myZero, 1, addr bufMyOutput, 0
			jmp printNumB
		oneBitB:
			invoke WriteConsole, outputValue, addr myOne, 1, addr bufMyOutput, 0
			jmp printNumB
		exitOfPrintB:
			jmp switchValues
	switchValues:
		
		
		
		invoke WriteConsole, outputValue, addr multipliedValue, sizeof multipliedValue, addr bufMyOutput, 0 ;Результат логического умножения
		mov al, num
		and al, num2
		mov permres, al
		mov resultFin,al
		
		
		mov newNum, al
		mov count, 0
		
		printResult:
			inc count
			cmp count, 9
			je exitOfPrintRes
			shl permres, 1
			jc oneBitRes
			invoke WriteConsole, outputValue, addr myZero, 1, addr bufMyOutput, 0
			jmp printResult
			
		oneBitRes:
			invoke WriteConsole, outputValue, addr myOne, 1, addr bufMyOutput, 0
			jmp printResult
		exitOfPrintRes:
			jmp next
	next:
		mov al, resultFin
		and al, 00000001b
		rcl al, 6
		
		mov ah, resultFin
		and ah, 01000000b
		rcr ah, 6
		or al,AH
		and resultFin, 10111110b
		or resultFin,al
		
		mov al, resultFin
		and al, 00000010b
		rcl al, 3
		
		mov ah, resultFin
		and ah, 00010000b
		rcr ah, 3
		or al,AH
		and resultFin, 11101101b
		or resultFin,al
		
		mov al, resultFin
		invoke WriteConsole, outputValue, addr finalResult, sizeof finalResult, addr bufMyOutput, 0 ;Результат логического умножения
		mov newNum, al
		mov count, 0
		
		printResultF:
			inc count
			cmp count, 9
			je exitOfPrintResF
			shl resultFin, 1
			jc oneBitResF
			invoke WriteConsole, outputValue, addr myZero, 1, addr bufMyOutput, 0
			jmp printResultF
		oneBitResF:
			invoke WriteConsole, outputValue, addr myOne, 1, addr bufMyOutput, 0
			jmp printResultF
		exitOfPrintResF:
		
	exit
end start
