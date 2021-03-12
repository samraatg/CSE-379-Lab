	.text
	.global lab4part2
	.global non_interrupt_timer_init

lab4part2:
	STMFD SP!,{lr}	; Store register lr on stack

          ; Your code is placed here

	LDMFD sp!, {lr}
	MOV pc, lr




non_interrupt_timer_init:

RCGC_Timer:	.equ	0x604
GPTMCTL:	.equ 	0x00C
GPTMCFG: 	.equ 	0x000
GPTMTAMR: 	.equ 	0x004
GPTMTAILR: 	.equ 	0x028

	; Enable Timer Clock
	mov r1, #0xe000
	movt r1, #0x400f
	mov r0, #1
	strb r0, [r1, #RCGC_Timer]

	; Timer 0 Base Address
	mov r1, #0x0000
	movt r1, #0x4003

	; Disable Timer
	mov r0, #0
	str r0, [r1, #GPTMCTL]

	; Configure as 32-bit
	mov r0, #0
	str r0, [r1, #GPTMCFG]

	; Set to Periodic Mode
	mov r0, #0x12
	str r0, [r1, #GPTMTAMR]

	; Configure as 32-bit
	mov r0, #0
	str r0, [r1, #GPTMCFG]

	; Configure Interval
	mov r0, #0xFFFF
	movt r0, #0xFFFF
	str r0, [r1, #GPTMTAILR]

	; Enable Timer
	mov r0, #1
	str r0, [r1, #GPTMCTL]

	; Return
	mov pc,lr


	.end
