SECTION .data

; Some setup for the prompts we are about to print

promptOne:       db   "Enter the first string: "
promptOneLength: equ    $-promptOne

promptTwo:       db   "Enter the second string: "
promptTwoLength: equ    $-promptTwo

firstStringIsGreat: db  "True"
firstStringLength:  equ $-firstStringIsGreat

secondStringIsGreat: db "False"
secondStringLength: equ  $-secondStringIsGreat

; Create some space for our strings

SECTION .bss

digitsPromptOne: equ      30
inbufPromptOne:  resb     digitsPromptOne

digitsPromptTwo: equ      30
inbufPromptTwo:  resb     digitsPromptTwo

SECTION .text

global  _start

_start:
        ; Ask for the first user string
        mov     eax, 4              ; call the janitor to write
		mov     ebx, 1              ; to standard output
		mov     ecx, promptOne      ; the prompt string
		mov     edx, promptOneLength ; length of prompt
		int     80H                 ; syscall

		mov     eax, 3              ; call the janitor to read
		mov     ebx, 0              ; to standard input
		mov     ecx, inbufPromptOne ; into the input buffer
		mov     edx, digitsPromptOne
		int     80H                 ; syscall

        ; Ask for the second user string
two:
        mov     eax, 4              ; call the janitor to write
		mov     ebx, 1              ; to standard output
		mov     ecx, promptTwo      ; the prompt string
		mov     edx, promptTwoLength ; length of prompt
		int     80H                 ; syscall

		mov     eax, 3              ; call the janitor to read
		mov     ebx, 0              ; to standard input
		mov     ecx, inbufPromptTwo ; into the input buffer
		mov     edx, digitsPromptTwo  ; length of prompt
		int     80H                 ; syscall




compareFunc1:
    mov     ecx, inbufPromptOne      ; Move the first user string into the buffer
    mov     ebx, inbufPromptTwo      ; Move the second user string into the buffer
    jmp     compareFunc2


compareFunc2:
    cmp     byte[ecx], 10           ; if its 10, there is no string left (first string)
    je      stringLess
    mov     AH, byte[ecx]          ; take one char out

    cmp     byte[ebx], 10
    je      stringGreater         ; if it reaches here, then we are done
    mov     DL, byte[ebx]         ; take one char out

    cmp     AH, DL                 ; Get the char and compare
    jl      stringLess             ; jump if the first string is less than the first
    jg      stringGreater          ; else

    inc     ecx                    ; Go to the next char
    inc     ebx                    ; Go to the next char

    jmp     compareFunc2


stringLess:
        mov     eax, 4              ; call the janitor to write
		mov     ebx, 1              ; to standard output
		mov     ecx, secondStringIsGreat     ; the prompt string
		mov     edx, secondStringLength ; length of prompt
		int     80H                 ; syscall
		jmp     fin

stringGreater:
        mov     eax, 4              ; call the janitor to write
		mov     ebx, 1              ; to standard output
		mov     ecx, firstStringIsGreat     ; the prompt string
		mov     edx, firstStringLength ; length of prompt
		int     80H                 ; syscall
		jmp     fin

fin:
        mov     eax, 1				; set up process exit
        mov     ebx, 0				; and
        int	    80H				    ; terminate