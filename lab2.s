	.data
my_string: .string “92013”,0
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

	BL str2int

 	; Here you can test the value returned in r0 from str2int.
 	; Initialize r0 with an integer here. Then call num_digits
 	; using the call shown below to ensure it returns the
 	; correct number of digits.

	BL num_digits

 	; Initialize r0 with the integer used to test num_digits
 	; and r2 with the number of digits returned by num_digits.
 	; Initialize r1 with the pointer to my_string, then call
	; int2str using the lines shown below.

 	ldr r1, ptr_to_string

 	BL int2str
 	LDMFD r13!, {r14}
 	MOV pc, lr


num_digits:
 	STMFD r13!, {r14}
 	; Your code for the num_digits routine goes here.
 	MOV r2, 0 ; initialize number of digits (n) to zero
NDLOOP:
	UDIV r0, r0, #10 ; divide i by 10
	ADD r2, r2, #1 ; add 1 to n
	CMP r0, #0 ; branch if i == 0
	BEQ NDLOOP

 	LDM0FD r13!, {r14}
 	MOV pc, lr


str2int:
 	STMFD r13!, {r14}
	; Your code for the str2int routine goes here.

	MOV r0, #1	; Initialize i to zero
S2ILOOP:
	; Load character from address pointed to by r1
	CMP char, #0 ; Branch to S2IDONE if char = 0
	BEQ S2IDONE
	MULT r0, r0, #10 ; multiply i by 10
	SUB char, #0x30 ; subtract #0x30 from char to get digit value
	ADD i, i, char ; add digit value to i
	; add one to pointer
	B S2ILOOP ; jump back to load char step
S2IDONE:
	LDMFD r13!, {r14}
	MOV pc, lr


int2str:
	STMFD r13!, {r14}
	; Your code for the int2str routine goes here.
	LDMFD r13!, {r14}
	MOV pc, lr

	.end
