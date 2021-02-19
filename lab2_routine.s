	.data
my_string:	.string '92013',0

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
	MOV r2,#0

DIVby10:
	MOV r3,#10
	UDIV r0,r0,r3
	ADD r2,r2,#1
	CMP r0,#0
	BNE DIVby10

	LDMFD r13!, {r14}
	MOV pc, lr


str2int:
	STMFD r13!, {r14}


	; Your code for the str2int routine goes here.



	LDMFD r13!, {r14}
	MOV pc, lr


int2str:
	STMFD r13!, {r14}


	; Your code for the int2str routine goes here.
	ADD r1,r1,r2
	MOV r8,#0
	STRB r8,[r1]
	SUB r1,r1,#1

DivideByTen:
	MOV r3,#10
	UDIV r4,r0,r3		;r4 = q
	MUL r5,r4,r3		;r5= p
	SUB r6,r0,r5		;r6 = dig
	ADD r7,r6,#0x30		;r7=ascii
	STRB r7,[r1]
	MOV r0,r4
	CMP r0,#0
	BEQ STOP
	SUB r1,r1,#1
	B DivideByTen
	
STOP:

	LDMFD r13!, {r14}
	MOV pc, lr

	.end

