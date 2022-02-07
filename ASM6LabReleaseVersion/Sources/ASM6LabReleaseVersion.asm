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
; константы
.const
	inputFileName db "in.txt",0
	outputFileName db "out.txt",0
	BSIZE equ 256
	STD_OUTPUT_HANDLE equ -11
	GENERIC_READ equ 80000000h
	GENERIC_WRITE equ 40000000h
	GEN = GENERIC_READ or GENERIC_WRITE
	SHARE = 0
	OPEN_EXISTING equ 3
; сегмент данных
.data 

	myline db 31h
	handl dd ?
	outputHandl dd ?
	lpBytesRead dd ?
	lpBytesWritten dd 0
	stringFormat db 512 dup(0)
	readBuff db 8 dup(0)
	outbuf db 512 dup (0)
	outputValue dd ?
	sizeOfFile db "Size of file = ",0

	errorMessage db "It's not possible to read a file", 0
	anotherMessage db "It's not possible to open file", 0
	
	sizeOfInputFile dd ?	
	
	buf dd BSIZE DUP (?)
	counter db ?
	tempWord dw ?
	index dd 0
	wordCounter dd 0
	tempCounter dd 0
	
; сегмент кода
.code

start:
		
		invoke GetStdHandle, STD_OUTPUT_HANDLE
		mov outputValue, eax ;дескриптор вывода в консоль
		
		invoke CreateFileA, offset inputFileName, GENERIC_READ, 0, 0, OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL, 0
		mov handl, eax
		
		cmp eax, INVALID_HANDLE_VALUE
		je exitErrorOpening
	
		invoke GetFileSize, handl, NULL
		mov sizeOfInputFile, eax
		
		cmp sizeOfInputFile, INVALID_FILE_SIZE
		je exitProgram
		
		invoke CreateFileA,offset outputFileName, GENERIC_WRITE, 0, 0, OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
		mov outputHandl,eax
		

		lp0:
			 call getFileData
			 
			 cmp eax,-1
			 jz kon_file
			 
			 inc tempCounter
			 lea esi,stringFormat
			 lea edi,outbuf
			 
			 mov eax,tempCounter
			 
			 call printDec
			 
			 mov al,':'
			 
			 stosb 
		 
		lp1:
			 mov al,[esi]
			 
			 cmp al,0
			 jz fin1
			 
			 cmp al,' '
			 jnz m1
			 
			 inc esi
			 jmp lp1
		m1:
			mov edx,esi
			
		lp2:
			
			 mov al,[esi]
			 cmp al,0
			 jz m2
			 cmp al,' '
			 jz m2
			 inc esi
			 jmp lp2
		m2:
			 mov ebp,esi
			 sub ebp,edx
			 cmp ebp,3
			 jbe lp1
			 mov ebx,edx
		
		lp4:
			 mov al,[ebx]
			 mov wordCounter,0
			 mov ecx,edx
		lp3:
			cmp al,[ecx]
			jnz m3
			inc wordCounter
		m3:
			 inc ecx
			 cmp ecx,esi
			 jnz lp3
			 cmp wordCounter,3
			 jbe m4
			 
			 push esi
			 
			 mov esi,edx
			 mov ecx,ebp
			 mov al,' '
			 
			 stosb
			 rep movsb
			 
			 mov al,'('
			 stosb
			 
			 mov eax,edx
			 sub eax,offset stringFormat - 1
			 call printDec
			 mov al,')'
			 
			 stosb
			 pop esi
			 
			 jmp lp1
			 
		m4:
			inc ebx
			cmp ebx,esi
			jnz lp4
			jmp lp1 
		fin1:
			 mov al,13
			 stosb
			 mov al,10
			 stosb
			 mov ecx,edi
			 sub ecx,offset outbuf
			 invoke WriteFile,outputHandl,offset outbuf,ecx,offset lpBytesWritten,NULL
			 jmp lp0
		
		kon_file:
			
			 invoke CloseHandle,handl
			 invoke CloseHandle,outputHandl
		
		getFileData proc
			push edi
			push ebx
			push ecx
			push edx
			
			lea edi,stringFormat
			@@m1:
				 invoke ReadFile,handl,offset readBuff,1,offset lpBytesWritten,NULL
				 cmp lpBytesWritten,0
				 jz @@ex1
				 mov al,readBuff
				 cmp al,0dh
				 jz @@ex
				 stosb
				 jmp @@m1
			@@ex:
				invoke ReadFile,handl,offset readBuff,1,offset lpBytesWritten,NULL
			@@ex3: 
				 mov eax,edi
				 sub eax,offset stringFormat
				 jmp @@ex2
			@@ex1: 
				cmp edi,offset stringFormat
				jnz @@ex3
				mov eax,-1
			@@ex2: 
				mov [edi],byte ptr 0
				pop edx
				pop ecx
				pop ebx
				pop edi
				ret
			getFileData endp
		
		printDec proc
			
			 push ecx
			 push edx
			 push ebx
			 mov ebx,10
			 xor ecx,ecx
			@@m1a: 
				 xor edx,edx
				 div ebx
				 push edx
				 inc ecx
				 test eax,eax
				 jnz @@m1a
			@@m2a: 
				 pop eax
				 add al,'0'
				 stosb
				 loop @@m2a
				 pop ebx
				 pop edx
				 pop ecx
				 ret
				 
		printDec endp
	
	exitErrorOpening:
		
		invoke WriteConsole, outputValue, addr anotherMessage, sizeof anotherMessage, 0, 0 
		jmp ex
	
	exitProgram:
		
		invoke WriteConsole, outputValue, addr errorMessage, sizeof errorMessage, 0, 0 
		jmp ex
			
	ex:
		invoke ExitProcess, 0
		end start
