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
results:	.string "-999999",0
num_1_string: .string "Place holder string for your first number",0
num_2_string: .string "Place holder string for your second number",0
prompt_end: .string "Do you want to enter another operation? (Y/N): ",0
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
	LDR r3, ptr_to_prompt1
	LDR r4, ptr_to_results
   	LDR r5, ptr_to_num_1_string
 	LDR r6, ptr_to_num_2_string

   		 ; Your code is placed here.  This is your main routine for
   		 ; Lab #3.  This should call your other routines such as
   		 ; uart_init, read_string, and output_string.
		; r0 = results string
		MOV r1, r4
		BL str2int ;
		MOV r1, r5
		MOV r4, r0
		BL num_digits
		MOV r2, r0
		MOV r0, r4
		BL int2str
		MOV r0, r0
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

; Lab 2 subroutines, int2str, num_digits, and str2int
; are needed for performing the operation on the strings

; input: integer in r0
; output: length of integer in r0
num_digits:
 	STMFD r13!, {r14}
 		CMP r0, #0 ; check if r0 is negative
 		BGE ND_START
 		MOV r9, #-1
 		MUL r0, r9 ; if so, make positive
ND_START:
 		MOV r7, #0 ; initialize number of digits (n) to zero
ND_LOOP:
		MOV r8, #10
		UDIV r0, r0, r8 ; divide i by 10
		ADD r7, r7, #1 ; add 1 to n
		CMP r0, #0 ; branch if i != 0
		BNE ND_LOOP
		; else exit
		MOV r0, r7 ; return n in r0
 	LDMFD r13!, {r14}
 	MOV pc, lr

; input: string starting at r1
; output: integer in r0
str2int:
 	STMFD r13!, {r14}
	; Your code for the str2int routine goes here.
		MOV r7, #0	; initialize i to zero (i is in r7 for now, returned in r0 later)
		LDRB r8, [r1] ; load first character to see if negative integer
		MOV r9, #1
		CMP r8, #0x2D ; compare character with ASCII '-'
		BNE S2I_LOOP
		ADD r1, r1, #1 ; if first char is '-', move pointer to second char
		MOV r9, #-1 ; r9 = -1 for multiplying later
S2I_LOOP:
		LDRB r8, [r1] ; load character from address pointed to by r1
		CMP r8, #0 ; branch to S2IDONE if char == 0
		BEQ S2I_DONE
		MOV r10, #10
		MULT r7, r7, r10 ; multiply i by 10
		SUB r8, r8, #0x30 ; subtract 0x30 (ASCII 0) from char to get digit value
		ADD r7, r7, r8 ; add digit value to i
		ADD r1, r1, #1 ; add one to pointer
		B S2I_LOOP ; jump back to load char step
S2I_DONE:
		MULT r7, r9
		MOV r0, r7 ; return i in r0
	LDMFD r13!, {r14}
	MOV pc, lr

; input: integer in r0, integer length in r2
; output: string of the integer starting at r1
int2str:
	STMFD r13!, {r14}
	; Your code for the int2str routine goes here.
		ADD r1,r1,r2    ;Add num of digits to pointer r1=r1+r2
		MOV r2, #0 ; placeholder for negative check
		CMP r0, #0 ; check to see if integer is negative
		BGE I2S_START
		ADD r1, r1, #1 ;add another "digit" to account for '-'
		MOV r2, #-1
		MULT r0, r0, r2 ; make integer positive
		MOV r2, #0x2D ;store ASCII '-' to add to string later
I2S_START:
		;ADD r1,r1,r2    ;Add num of digits to pointer r1=r1+r2
		MOV r7,#0 		;Store 0 at r7 to be used as NULL
		STRB r7,[r1]	;Store Null at adress pointed to by pointer
		SUB r1,r1,#1	; Subtract 1 from pointer r1= r1-1
DivideByTen:
		MOV r8,#10		; Move 10 to r8 to be used for division and multiplication
		UDIV r9,r0,r8		;r9 = q  Divide r0 by 10
		MUL r10,r9,r8		;r10 = p	 Multiply r9 by 10
		SUB r10,r0,r10		;r10 = dig Subtract p from r0
		ADD r10,r10,#0x30		;r7=ascii	add 0x30 to r10
		STRB r10,[r1]		; store value of r10 at adress pointed to by pointer r1
		MOV r0,r9			;Move value of r9 into r0
		CMP r0,#0			; Compare value of r0 to 0
		BEQ I2S_STOP		; We Branch if r0=0
		SUB r1,r1,#1		; If r0!=0 then we subtract 1 from r1 and branch
		B DivideByTen
I2S_STOP:
		CMP r2, #0x2D ;check to see if '-' still needs to be in string
		BNE I2S_DONE
		SUB r1, r1, #1 ; go to front of string
		STRB r2, [r1] ;store '-' at front of string
I2S_DONE:
	LDMFD r13!, {r14}
	MOV pc, lr

.end
