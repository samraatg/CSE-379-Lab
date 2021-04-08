	.data
; ANSI Escape Sequences for cursor control and board printing
CUR: 		.string 27,"[0;0H",0
CUR_SAV: 	.string 27,"[s",0
CUR_RES: 	.string 27,"[u",0
CUR_U:		.string 27,"[1A",0
CUR_D:		.string 27,"[1B",0
CUR_R:		.string 27,"[1C",0
CUR_L:		.string 27,"[1D",0
X_LINE:		.string 27,"[s",27,"[37mXXXXXXXXX",27,"[u",27,"[1B",0
BOARD1: 	.string 27,"[s",27,"[37mX",27,"[32mO","   ",27,"[36mO"," ",27,"[31mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[36mO","   ",27,"[34mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[34mO","    ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[31mO","   ",27,"[37mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[37mO","   ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[35mO","  ",27,"[33mO","  ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[33mO"," ",27,"[32mO",27,"[35mO",27,"[37mX",27,"[u",27,"[1B",0
	.text
; Library Subroutines
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler
	.global timer_init
	.global interrupt_init
	.global lab6
	.global uart_init
	.global gpio_init
	.global illuminate_RGB_LED
	.global output_character
	.global output_string
	.global interrupt_init
; String Pointers
ptr_to_CUR: .word CUR
ptr_to_CUR_SAV: .word CUR_SAV
ptr_to_CUR_RES: .word CUR_RES
ptr_to_CUR_U: .word CUR_U
ptr_to_CUR_D: .word CUR_D
ptr_to_CUR_R: .word CUR_R
ptr_to_CUR_L: .word CUR_L
ptr_to_X_LINE: .word X_LINE
ptr_to_BOARD1: .word BOARD1
;ptr_to_B1_L2: .word B1_L2
;ptr_to_B1_L3: .word B1_L3
;ptr_to_B1_L4: .word B1_L4
;ptr_to_B1_L5: .word B1_L5
;ptr_to_B1_L6: .word B1_L6
;ptr_to_B1_L7: .word B1_L7

; Main Routine
lab6:
	STMFD SP!,{r0-r12,lr}
	; initializations
 	BL uart_init
 	BL gpio_init
	BL interrupt_init

	; print game board
	LDR r0, ptr_to_CUR		; initialize cursor
	BL output_string
	LDR r0, ptr_to_X_LINE	; top X line
	BL output_string
	LDR r0, ptr_to_BOARD1	; 1st line
	BL output_string
	LDR r0, ptr_to_X_LINE	; bottom X line
	BL output_string

loop:
	mov r0, #1
	CMP r0, #0
	BNE loop

	LDMFD sp!, {r0-r12,lr}
 	MOV pc, lr

UART0_Handler:
	STMFD SP!,{r0-r12,lr} ; Store register lr on stack
	; set RXIM in UARTICR
	MOV r4, #0xC000
	MOVT r4, #0x4000 ; base address of UART0
	LDR r5, [r4, #0x44] ; load UARTICR
	ORR r5, r5, #0x10 ; set bit 4 (RXIM)
	STR r5, [r4, #0x44]


	; load uart data (char input)
	LDR r6, [r4]
UP:
	CMP r6, #0x77 ; check if char is ASCII 'w'
	BNE DOWN
	LDR r0, ptr_to_CUR_U
	BL output_string
DOWN:
	CMP r6, #0x73 	; check if char is ASCII 's'
	BNE LEFT
	LDR r0, ptr_to_CUR_D
	BL output_string
LEFT:
	CMP r6, #0x61 	; check if char is ASCII 'a'
	BNE RIGHT
	LDR r0, ptr_to_CUR_L
	BL output_string
RIGHT:
	CMP r6, #0x64 	; check if char is ASCII 'd'
	BNE NO_DIR
	LDR r0, ptr_to_CUR_R
	BL output_string
NO_DIR:
	LDMFD sp!, {r0-r12,lr}
	BX lr

Switch_Handler:
	STMFD SP!,{r0-r12,lr}
	; clear SW1 interrupt
	MOV r4, #0x5000
	MOVT r4, #0x4002 ; base address of GPIOF
	LDR r5, [r4, #0x41C] ; load GPIOICR
	ORR r5, r5, #0x10 ; set bit 4 (SW1) to clear
	STR r5, [r4, #0x41C]

	LDMFD sp!, {r0-r12,lr}
	BX lr

Timer_Handler:
	STMFD SP!,{r0-r12,lr}
	; clear timer interrupt
	MOV r4, #0x0000
 	MOVT r4, #0x4003 ; T0 base address
 	LDR r5, [r4, #0x024] ; GPTMICR offset
 	ORR r5, r5, #0x1 ; set bit0 to 1 (TATOCINT)
 	STR r5, [r4, #0x024]

	LDMFD sp!, {r0-r12,lr}
	BX lr
.end
