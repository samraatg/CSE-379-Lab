	.data
	.global prompt1
	.global prompt2
	.global prompt3
	.global results
	.global num_1_string
	.global num_2_string
	.global prompt_end
prompt1:	.string "Enter a number: ",0
prompt2:	.string "Enter another number: ",0
prompt3:	.string "Enter an operation (+ or -) : ",0
results:	.string "Your results are reported here",0
num_1_string: .string "Place holder string for your first number",0
num_2_string: .string "Place holder string for your second number",0
prompt_end: .string "Do you want to enter another operation? Press enter: ",0
.text
	.global lab3
U0FR:  .equ 0x18			; UART0 Flag Register
ptr_to_prompt1:	.word prompt1
ptr_to_prompt2: .word prompt2
ptr_to_prompt3: .word prompt3
ptr_to_results:	.word results
ptr_to_num_1_string: .word num_1_string
ptr_to_num_2_string: .word num_2_string
ptr_to_prompt_end: .word prompt_end


lab3:
	STMFD SP!,{lr}	; Store register lr on stack
	ldr r4, ptr_to_prompt1
	ldr r5, ptr_to_prompt2
	ldr r6, ptr_to_prompt3
	ldr r7, ptr_to_results
   	ldr r8, ptr_to_num_1_string
 	ldr r9, ptr_to_num_2_string

   		 ; Your code is placed here.  This is your main routine for
   		 ; Lab #3.  This should call your other routines such as
   		 ; uart_init, read_string, and output_string.

		;read_string prompt1
		;output_string prompt1
		;read_string first number
		;store first number to r8

		;read_string prompt2
		;output_string prompt2
		;read_string second number
		;store second number to r9

		;str2int first number
		;str2int second number

		;read_string prompt3
		;output_string prompt3
		;read_character operation

		;if operation == "+", do addition
		;else operation == "-", do subtraction
		;int2str result

		;
 	LDMFD sp!, {lr}
	mov pc, lr

read_string:
	STMFD SP!,{lr}	; Store register lr on stack
	
		; Your code for your read_string routine is placed here
	
read_string_loop:
	BL read_character
	CMP r0,#0x0A
	BEQ EndOfNumber ;:PlaceHolder Number
	STRB r0,[r6]   ;store character at the pointer to placeholder string
	ADD r6,r6,#1   ;Advance the pointer
	B read_string_loop
	
EndOfNumber:

 	LDMFD sp!, {lr}
	mov pc, lr

output_string:
	STMFD SP!,{lr}	; Store register lr on stack
	
	;load prompt string to register r3
StringLoop:	
	LDR r0,[r1]   ; change r1 to the pointer to the prompt to be displayed
	CMP r0,#0    
	BEQ StringEnd ; End if we reach a null character
	BL output_character ; Display character 
	ADD r1,r1,#1		; Advance pointer
	B StringLoop		; Move to next character in the string
	
	
		; Your code for your output_string routine is placed here
StringEnd:

 	LDMFD sp!, {lr}
	mov pc, lr


read_character:
	STMFD SP!,{lr}	; Store register lr on stack

		; Your code for your read_character routine is placed here
		MOV r1, #0xC000
		MOVT r1, #0x4000 ; r1 = base address of UART
	TEST_RFE:
		LDRB r2, [r1, #U0FR] ; load 0x4000C018 (U0FR) into r2
		AND r2, r2, #0x10 ; mask all bits except RxFE (bit 4)

		CMP r2, #0x10	; Test RxFE in Status register
		BEQ TEST_RFE ; if RxFE == 1, test again
		LDRB r0, [r1] ; else RxFE == 0, read byte (r0) from receive register (r1)


 	LDMFD sp!, {lr}
	mov pc, lr

output_character:
	STMFD SP!,{lr}	; Store register lr on stack

		; Your code for your output_character routine is placed here
		MOV r1, #0xC000
		MOVT r1, #0x4000 ; r1 = base address of UART

	TEST_TFF:
		LDRB r2, [r1, #U0FR] ; load 0x4000C018 (U0FR) into r2
		AND r2, r2, #0x20 ; mask all bits except TxFF (bit 5)

		CMP r2, #0x20	; Test TxFF in Status register
		BEQ TEST_TFF ; if TxFF == 1, test again
		STRB r0, [r1] ; else TxFF == 0, store byte (r0) in transmit register (r1)


 	LDMFD sp!, {lr}
	mov pc, lr

uart_init:
	STMFD SP!,{lr}	; Store register lr on stack

; Your code for your uart_init routine is placed here

 	LDMFD sp!, {lr}
	mov pc, lr

	.end

; Lab 2 subroutines, int2str, num_digits, and str2int
; are needed for performing the operation on the strings

; input: integer in r0
; output: length of integer in r0
num_digits:
 	STMFD r13!, {r14}
 		MOV r3, #0 ; initialize number of digits (n) to zero
	NDLOOP:
		MOV r4, #10
		UDIV r0, r0, r4 ; divide i by 10
		ADD r3, r3, #1 ; add 1 to n
		CMP r0, #0 ; branch if i != 0
		BNE NDLOOP
		; else exit
		MOV r0, r3 ; return n in r0
 	LDMFD r13!, {r14}
 	MOV pc, lr

; input: string starting at r1
; output: integer in r0
str2int:
 	STMFD r13!, {r14}
	; Your code for the str2int routine goes here.
		MOV r3, #0	; Initialize i to zero (i is in r3 for now, returned in r0 later)
	S2ILOOP:
		LDRB r4, [r1] ; Load character from address pointed to by r1
		CMP r4, #0 ; Branch to S2IDONE if char == 0
		BEQ S2IDONE
		MOV r5, #10
		MULT r3, r3, r5 ; multiply i by 10
		SUB r4, r4, #0x30 ; subtract 0x30 (ASCII 0) from char to get digit value
		ADD r3, r3, r4 ; add digit value to i
		ADD r1, r1, #1 ; add one to pointer
		B S2ILOOP ; jump back to load char step
	S2IDONE:
		MOV r0, r3 ; return i in r0
	LDMFD r13!, {r14}
	MOV pc, lr

; input: integer in r0, integer length in r2
; output: string of the integer starting at r1
int2str:
	STMFD r13!, {r14}
	; Your code for the int2str routine goes here.
		ADD r1,r1,r2    ;Add num of digits to pinter r1=r1+r2
		MOV r8,#0 		;Store 0 at r8 to be used as NULL
		STRB r8,[r1]	;Store Null at adress pointed to by pointer
		SUB r1,r1,#1	; Subtract 1 from pointer r1= r1-1
	DivideByTen:
		MOV r3,#10		; Move 10 to r3 to be used for division and multiplication
		UDIV r4,r0,r3		;r4 = q  Divide r0 by 10
		MUL r5,r4,r3		;r5= p	 Multiply r4 by 10
		SUB r6,r0,r5		;r6 = dig Subtract r5 from r0
		ADD r7,r6,#0x30		;r7=ascii	add 0x30 to r7
		STRB r7,[r1]		; store value of r7 at adress pointed to by pointer r1
		MOV r0,r4			;Move value of r4 into r0
		CMP r0,#0			; Compare value of r0 to 0
		BEQ STOP			; We Branch if r0=0
		SUB r1,r1,#1		; If r0!=0 then we subtarct 1 from r1 and branch
		B DivideByTen
	STOP:
	LDMFD r13!, {r14}
	MOV pc, lr


