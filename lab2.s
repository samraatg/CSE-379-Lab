	.data
my_string: .string "929042",0
	.text
 	.global lab_2_test
	.global ptr_to_string
ptr_to_string: .word my_string

lab_2_test:
	STMFD r13!, {r14}

	; Your code to test your num_digits, str2int, and int2str
	; routines go here. Modify the string shown in red above to
	; test num_digits and str2int.
	; To test int2str, use the lines shown below to initialize
	; the pointer to the string and call str2int.

	LDR r1, ptr_to_string

	BL str2int

 	; Here you can test the value returned in r0 from str2int.
 	; Initialize r0 with an integer here. Then call num_digits
 	; using the call shown below to ensure it returns the
 	; correct number of digits.

	MOV r9, r0 ; save returned int from str2int for testing int2str

	BL num_digits

 	; Initialize r0 with the integer used to test num_digits
 	; and r2 with the number of digits returned by num_digits.
 	; Initialize r1 with the pointer to my_string, then call
	; int2str using the lines shown below.

	MOV r2, r0 ; initializations for int2str
	MOV r0, r9 ; Initaialize r0 with integer used to test num_digits
 	LDR r1, ptr_to_string

 	BL int2str
 	LDMFD r13!, {r14}
 	MOV pc, lr


num_digits:
 	STMFD r13!, {r14}
 	; Your code for the num_digits routine goes here.
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

	.end
