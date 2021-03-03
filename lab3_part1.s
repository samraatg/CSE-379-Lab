	.text
	.global lab3

U0FR:  .equ 0x18			; UART0 Flag Register

lab3:
	STMFD SP!,{lr}	; Store register lr on stack

		; Your code is placed here
		BL read_character
		;MOV r0, #0x31 ; pass ASCII "1" to r0 to test output_character
		BL output_character
		;BL read_character
	LDMFD sp!, {lr}
	mov pc, lr

output_character:
	STMFD SP!,{lr}	; Store register lr on stack

		; Your code to output a character to be displayed in PuTTy
		; is placed here.  The character to be displayed is passed
		; into the routine in r0.

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

read_character:
	STMFD SP!,{lr}	; Store register lr on stack

		; Your code to receive a character obtained from the keyboard
		; in PuTTy is placed here.  The character is received in r0.

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


	.end
