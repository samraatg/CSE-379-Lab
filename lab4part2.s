		.data
	.global prompt1
	.global prompt2
prompt1:	.string "This program changes the color of the LED and displays the time between consecutive button presses",0
prompt2:	.string "Directions- press switch 1 in the tive board to change light from blue to green",0
prompt3:	.string "Press switch 1 again to display time between the button pushes and chage LED to red",0	
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

ptr_to_prompt1:	.word prompt1
ptr_to_prompt2:	.word prompt2
ptr_to_prompt3:	.word prompt3

lab4part2:
	STMFD SP!,{lr}	; Store register lr on stack

          ; Your code is placed here
          
    BL uart_init
    BL gpio_init
    
    ; Display the inroduction and directions
    LDR r0, ptr_to_prompt1
    BL output_string
    LDR r0, ptr_to_prompt2
	BL output_string
	LDR r0, ptr_to_prompt3
	BL output_string	
	
	; Turn on Blue LED
	mov r0,#0x2
	BL illuminate_RGB_LED

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
