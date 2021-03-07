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
results:	.string "Place holder string for your results",0
num_1_string: .string "Place holder string for your first number",0
num_2_string: .string "Place holder string for your second number",0
prompt_end: .string "Do you want to enter another operation? If so, enter Y: ",0
error1: .string "Error: Number out of bounds, please enter numbers in range 0-99999",0
error2: .string "Error: Invalid operation",0
.text
	.global lab3
	.global uart_init
U0FR:  .equ 0x18			; UART0 Flag Register
ptr_to_prompt1:	.word prompt1
ptr_to_prompt2: .word prompt2
ptr_to_prompt3: .word prompt3
ptr_to_results:	.word results
ptr_to_num_1_string: .word num_1_string
ptr_to_num_2_string: .word num_2_string
ptr_to_prompt_end: .word prompt_end
ptr_to_error1: .word error1
ptr_to_error2: .word error2


lab3:
	STMFD SP!,{lr}	; Store register lr on stack
   		; Your code is placed here.  This is your main routine for
   		; Lab #3.  This should call your other routines such as
   		; uart_init, read_string, and output_string.
		; r0 = results string
START:
		; 1st prompt and number
		LDR r3, ptr_to_prompt1
		BL output_string 			; output prompt1
		LDR r3, ptr_to_num_1_string
		BL read_string 				; read number1
		LDR r3, ptr_to_num_1_string
		BL output_string 			; output entered number1
		MOV r0, #0xA 				; ASCII newline
		BL output_character 		; output newline in terminal
		MOV r0, #0xD 				; ASCII CR(enter), formats newline to front
		BL output_character 		; fix newline to front

		; 2nd prompt and number
		LDR r3, ptr_to_prompt2
		BL output_string 			; output prompt2
		LDR r3, ptr_to_num_2_string
		BL read_string 				; read number2
		LDR r3, ptr_to_num_2_string
		BL output_string 			; output entered number2
		MOV r0, #0xA
		BL output_character 		; output newline in terminal
		MOV r0, #0xD
		BL output_character 		; fix newline to front

		; converting number strings to integers
		LDR r1, ptr_to_num_1_string
		BL str2int
		MOV r7, r0 					; r7 = number1 as int
		LDR r1, ptr_to_num_2_string
		BL str2int
		MOV r8, r0 					; r8 = number2 as int

		; 3rd prompt and operation
		LDR r3, ptr_to_prompt3
		BL output_string			; output prompt3
		BL read_character			; read operation char
		MOV r9, r0					; r9 = entered operation char
		BL output_character			; output entered operation
		MOV r0, #0xA
		BL output_character 		; output newline in terminal
		MOV r0, #0xD
		BL output_character 		; fix newline to front

		; checks for number errors
		MOV r0, r7
		BL num_digits
		CMP r0, #6					; check if num1 length > 5 digits
		BGE ERROR1					; if |num1|>99999, throw error and reprompt
		MOV r0, r8
		BL num_digits
		CMP r0, #6					; check if num2 length > 5 digits
		BGE ERROR1					; if |num2|>99999, throw error and reprompt

		; checks for valid operation
		CMP r9, #0x2B
		BEQ DO_ADD
		CMP r9, #0x2D
		BEQ DO_SUB
		B ERROR2
DO_ADD:
		ADD r10,r7,r8				; r10 = num1 + num2
		B RESULT
DO_SUB:
		SUB r10,r7,r8				; r10 = num1 - num2
		B RESULT
RESULT:
		MOV r0,r7					; r0=num1 for num_digits
		BL num_digits				; num_digits num1
		MOV r2,r0					; r2=num1 length for int2str
		LDR r1, ptr_to_results 		; load results as placement str
		MOV r0,r7					; r0=num1 for int2str
		MOV r7,r2					; save num1 length for moving ptr past num1
		CMP r0,#0
		BGE SKIP_NEG1
		ADD r7,r7,#1				; if num1<0, length + 1 to account for '-'
SKIP_NEG1:
		BL int2str					; int2str num1 in results
		ADD r1,r1,r7				; move ptr past num1

		STRB r9,[r1]				; store operation char in results
		ADD r1,r1,#1				; increment ptr
		MOV r4,r1					; save current ptr in r4 for num2 later

		MOV r0,r8					; r0=num2
		BL num_digits				; num_digits num2
		MOV r2,r0					; r2=num2 length for int2str
		MOV r1,r4					; r1 is current ptr in results
		MOV r0,r8					; r0=num2
		MOV r8,r2					; save num2 length for moving ptr past num2
		CMP r0, #0
		BGE SKIP_NEG2
		ADD r8,r8,#1				; if num2<0, length + 1 to account for '-'
SKIP_NEG2:
		BL int2str					; int2str num2 in results
		ADD r1,r1,r8				; move ptr past num2

		MOV r9,#0x3D				; ASCII '='
		STRB r9,[r1]				; store '=' in results
		ADD r1,r1,#1				; increment ptr
		MOV r4,r1					; save current ptr in r4 for result

		MOV r0,r10					; r0=result
		BL num_digits				; num_digits result
		MOV r2,r0					; r2=result length for int2str
		MOV r1,r4					; r1 is current ptr in results
		MOV r0,r10					; r0=result
		CMP r0, #0
		BGE SKIP_NEG3
		ADD r10,r10,#1				; if result<0, length + 1 to account for '-'
		MOV r10,r2					; save result length for moving ptr past result
SKIP_NEG3:
		BL int2str					; int2str result in results

		LDR r3, ptr_to_results
		BL output_string 			; output results
		MOV r0, #0xA
		BL output_character 		; output newline in terminal
		MOV r0, #0xD
		BL output_character 		; fix newline to front
		B EXIT
ERROR1:
		LDR r3, ptr_to_error1
		BL output_string			; output error1, number out of bounds
		MOV r0, #0xA
		BL output_character 		; output newline in terminal
		MOV r0, #0xD
		BL output_character 		; fix newline to front
		B EXIT
ERROR2:
		LDR r3, ptr_to_error2
		BL output_string			; output error2, invalid operation
		MOV r0, #0xA
		BL output_character 		; output newline in terminal
		MOV r0, #0xD
		BL output_character 		; fix newline to front
		B EXIT
EXIT:
		LDR r3, ptr_to_prompt_end
		BL output_string 			; output end prompt
		BL read_character			; read an entered char
		BL output_character 		; output entered char
		MOV r3, r0					; mov char to r3
		MOV r0, #0xA
		BL output_character 		; output newline in terminal
		MOV r0, #0xD
		BL output_character 		; fix newline to front
		CMP r3,#0x59 				; check if Y was entered
		BEQ	START					; if so, rerun routine
 	LDMFD sp!, {lr}
	mov pc, lr

; input: str from PuTTy terminal
; output: str stored in memory
; uses r0 for char, r3 for ptr
read_string:
	STMFD SP!,{lr}
RS_LOOP:
		BL read_character
		CMP r0,#0xD 		; check for enter char
		BEQ RS_STR_END 		; exit if char='enter'
		STRB r0,[r3]   		; store char in str
		ADD r3,r3,#1   		; increment ptr
		B RS_LOOP
RS_STR_END:
		MOV r0, #0x0
		STRB r0, [r3] 		; store null at end of str
 	LDMFD sp!, {lr}
	mov pc, lr

; input: ptr to a str in r3
; output: str in PuTTy terminal
; uses r0 for char, r3 for ptr
output_string:
	STMFD SP!,{lr}
OS_LOOP:
		LDRB r0,[r3]   		; load char
		CMP r0,#0x0    		; check if char=NULL
		BEQ OS_STR_END 		; if so, exit
		BL output_character ; display char
		ADD r3,r3,#1		; increment ptr
		B OS_LOOP
OS_STR_END:
 	LDMFD sp!, {lr}
	mov pc, lr

; input: char from PuTTy terminal
; output: char in r0
; uses r0-r2
read_character:
	STMFD SP!,{lr}
		MOV r1,#0xC000
		MOVT r1,#0x4000 	; r1 = base address of UART
TEST_RFE:
		LDRB r2,[r1, #U0FR] ; load 0x4000C018 (U0FR) into r2
		AND r2,r2,#0x10 	; mask all bits except RxFE (bit 4)
		CMP r2,#0x10		; test RxFE in status register
		BEQ TEST_RFE 		; if RxFE == 1, test again
		LDRB r0,[r1] 		; else RxFE == 0, read byte (r0) from receive register (r1)
 	LDMFD sp!, {lr}
	mov pc, lr

; input: char to output in r0
; output: char in PuTTy terminal
; uses r0-r2
output_character:
	STMFD SP!,{lr}
		MOV r1,#0xC000
		MOVT r1,#0x4000 	; r1= base address of UART
TEST_TFF:
		LDRB r2,[r1, #U0FR] ; load 0x4000C018 (U0FR) into r2
		AND r2,r2,#0x20 	; mask all bits except TxFF (bit 5)
		CMP r2,#0x20		; test TxFF in status register
		BEQ TEST_TFF 		; if TxFF == 1, test again
		STRB r0,[r1] 		; else TxFF == 0, store byte (r0) in transmit register (r1)
 	LDMFD sp!, {lr}
	mov pc, lr

uart_init:
	STMFD SP!,{lr}	; Store register lr on stack

		MOV r0,#1
		MOV r1,#0xE618
		MOVT r1,#0x400F
		str r0,[r1]

		MOV r0,#1
		MOV r1,#0xE608
		MOVT r1,#0x400F
		str r0,[r1]

		MOV r0,#0
		MOV r1,#0xC030
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#8
		MOV r1,#0xC024
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#44
		MOV r1,#0xC028
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#0
		MOV r1,#0xCFC8
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#0x60
		MOV r1,#0xC02C
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#0x301
		MOV r1,#0xC030
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#0x03
		MOV r1,#0x451C
		MOVT r1,#0x4000
		ldr r2,[r1]
		ORR r2,r2,r0
		str r2,[r1]

		MOV r0,#0x03
		MOV r1,#0x4420
		MOVT r1,#0x4000
		ldr r2,[r1]
		ORR r2,r2,r0
		str r2,[r1]

		MOV r0,#0x11
		MOV r1,#0x452C
		MOVT r1,#0x4000
		ldr r2,[r1]
		ORR r2,r2,r0
		str r2,[r1]

 	LDMFD sp!, {lr}
	mov pc, lr

; Lab 2 subroutines int2str, num_digits, and str2int
; are needed for performing the operation on the strings

; input: integer in r0
; output: length of integer in r0
; uses r0-r3
num_digits:
 	STMFD r13!, {r14}
 		CMP r0, #0 		; r0=i, check if i is negative
 		BGE ND_START
 		MOV r1, #-1
 		MUL r0, r1 		; if so, make positive
ND_START:
 		MOV r2, #0 		; r2=n, initialize n=0
ND_LOOP:
		MOV r3, #10
		UDIV r0, r0, r3 ; i=i/10
		ADD r2, r2, #1 	; n=n+1
		CMP r0, #0 		; exit if i=0
		BNE ND_LOOP
		MOV r0, r2 		; return n in r0
 	LDMFD r13!, {r14}
 	MOV pc, lr

; input: string starting at r1
; output: integer in r0
; uses r0-r4
str2int:
 	STMFD r13!, {r14}
		MOV r0, #0		; r0=i, initialize i=0
		LDRB r2, [r1] 	; load 1st char to see if int is negative
		MOV r3, #1
		CMP r2, #0x2D 	; compare 1st char with ASCII'-'
		BNE S2I_LOOP
		MOV r3, #-1 	; if first char is '-', r3=-1
		ADD r1, r1, #1	; move ptr to 2nd char (start of int)
S2I_LOOP:
		LDRB r2, [r1] 	; r2=char, load char from str ptr
		CMP r2, #0x0 	; if char=NULL, exit
		BEQ S2I_DONE
		MOV r4, #10
		MULT r0,r0,r4 	; r0=i, i=i*10
		SUB r2,r2,#0x30 ; r2=dig, dig=ASCII'dig'-ASCII'0'
		ADD r0,r0,r2 	; i=i+dig
		ADD r1,r1,#1 	; increment ptr
		B S2I_LOOP
S2I_DONE:
		MULT r0, r3 	; restore int sign if negative
	LDMFD r13!, {r14}
	MOV pc, lr

; input: integer in r0, integer length in r2
; output: string of the integer starting at r1
; uses r0-r6
int2str:
	STMFD r13!, {r14}
		ADD r1,r1,r2	; add num of digits to str ptr, r1=r1+r2
		MOV r2,#0		; r2 is placeholder for '-' character
		CMP r0,#0		; check to see if int is negative
		BGE I2S_START
		ADD r1,r1,#1 	; add another "digit" to account for '-'
		MOV r3,#-1
		MULT r0,r0,r3 	; make int positive
		MOV r3,#0x2D 	; store ASCII'-' in r3 to add to str later
I2S_START:
		ADD r1,r1,r2    ; add num of digits to str ptr r1=r1+r2
		MOV r4,#0x0
		STRB r4,[r1]	; store NULL at the end of the str
		SUB r1,r1,#1	; increment to next char in str
I2S_LOOP:
		MOV r4,#10
		UDIV r5,r0,r4	; r5=q, q=i/10
		MUL r6,r5,r4	; r6=p, p=q*10
		SUB r6,r0,r6	; r6=dig, dig=i-p
		ADD r6,r6,#0x30	; r6=ascii, ascii=dig+ASCII'0'
		STRB r6,[r1]	; store ascii digit in str
		MOV r0,r5		; r0=i=q, remove LSD from int
		CMP r0,#0		;
		BEQ I2S_STOP	; if i=0, exit
		SUB r1,r1,#1	; else i!=0, increment to next char in str
		B I2S_LOOP
I2S_STOP:
		CMP r3,#0x2D 	; check to see if '-' still needs to be in str
		BNE I2S_DONE
		SUB r1,r1,#1 	; go to front of string
		STRB r3,[r1] 	; store '-' at front of string
I2S_DONE:
	LDMFD r13!, {r14}
	MOV pc, lr

.end
