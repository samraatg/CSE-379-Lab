	.data
	.global prompt1
	.global prompt2
	.global prompt3
prompt1:	.string "This program changes the color of the LED and displays the time between consecutive button presses",0
prompt2:	.string "Press switch 1 on the tiva board to change LED from blue to green",0
prompt3:	.string "Press switch 1 again to change LED to red and display time between the button pushes",0
result: 	.string "Seconds between button presses:   ", 0
.text
	.global lab4part2
	.global non_interrupt_timer_init
	.global read_character
	.global output_character
	.global output_string
	.global read_string
	.global uart_init
	.global gpio_init
	.global read_from_push_btn
	.global illuminate_RGB_LED
	.global num_digits
	.global int2str
	.global str2int
	.global do_newline
ptr_to_prompt1:	.word prompt1
ptr_to_prompt2:	.word prompt2
ptr_to_prompt3:	.word prompt3
ptr_to_result: .word result

lab4part2:
	STMFD SP!,{lr, r4-r11}	; Store register lr on stack

          ; Your code is placed here
	; Initalize UART for PuTTy terminal and GPIO for RGB LED and SW1
    BL uart_init
    BL gpio_init

    ; Display the introduction and directions
    LDR r0, ptr_to_prompt1
    BL output_string
    BL do_newline
    LDR r0, ptr_to_prompt2
	BL output_string
	BL do_newline
	LDR r0, ptr_to_prompt3
	BL output_string
	BL do_newline

	; Turn on blue LED
	MOV r0,#0x2 ; blue=b010
	BL illuminate_RGB_LED

	; check for SW1 press
	MOV r0, #0
PRESS1:
	BL read_from_push_btn
	CMP r0, #1
	BNE PRESS1

	; record time
	MOV r4, #0x0050
	MOVT r4, #0x4003
	LDR r4, [r4] ; load timer timestamp

	; Turn on green LED
	MOV r0,#0x4 ; green=b100
	BL illuminate_RGB_LED

	; wait a little to allow second button press
	MOV r5, #0
WAIT_LOOP:
	CMP r5, #0x100000
	ADD r5, r5, #1
	BNE WAIT_LOOP

	; check for SW1 press
	MOV r0, #0
PRESS2:
	BL read_from_push_btn
	CMP r0, #1
	BNE PRESS2

	; record time
	MOV r5, #0x0050
	MOVT r5, #0x4003
	LDR r5, [r5] ; load timer timestamp

	; Turn on red LED
	MOV r0,#0x1 ; red=b001
	BL illuminate_RGB_LED

	; find time between presses
	SUB r4, r5, r4 ; subtract timestamps

	; convert to seconds
	MOV r5, #0x2400
	MOVT r5, #0x00F4
	UDIV r4, r4, r5 ; divide time by 16*10^6 to get seconds

	; convert time in seconds to string
	MOV r0, r4
	BL num_digits
	MOV r2, r0
	MOV r0, r4
	LDR r1, ptr_to_result
	ADD r1, r1, #31 ; skip to after : in result string
	BL int2str

	; output time between presses
	LDR r0, ptr_to_result
	BL output_string
	Bl do_newline


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
