	.data

x:	.string 27,"[37mx",0
blue_circle: .string 27,"[34mo",0
green_circle: .string 27,"[32mo",0
cyan_circle: .string 27,"[36mo",0
white_circle: .string 27,"[37mo",0
yellow_circle: .string 27,"[33mo",0
red_circle:	.string 27,"[31mo",0
magenta_circle:	.string 27,"[35mo",0
cursor: .string 27,"[0;0H",0
save_cur: .string 27, "[s",0
restore_cur: .string 27, "[u",0
up:	.string 27,"[1A",0
down:	.string 27,"[1B",0
right:	.string 27,"[1C",0
left:	.string 27,"[1D",0


	.text
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

;green_circle: .equ 0x0



ptr_to_blueCircle:	.word blue_circle
ptr_to_greenCircle:	.word green_circle
ptr_to_redCircle:	.word red_circle
ptr_to_cyanCircle:	.word cyan_circle
ptr_to_whiteCircle:	.word white_circle
ptr_to_yellowCircle:	.word yellow_circle
ptr_to_magentaCircle:	.word magenta_circle
ptr_to_cursor:	.word cursor
ptr_to_up: .word up
ptr_to_down: .word down
ptr_to_right: .word right
ptr_to_left: .word left
ptr_to_x:	.word x
ptr_to_save_cur: .word save_cur
ptr_to_restore_cur: .word restore_cur

lab6:
	STMFD SP!,{r0-r12,lr}
 	BL uart_init
 	BL gpio_init
	BL interrupt_init

	LDR r0, ptr_to_cursor
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string
;print 9 X's
	mov r5,#1
First:
	add r5,#1
	LDR r0,ptr_to_x
	BL output_string
	cmp r5, #10
	BNE First

second:
	LDR r0, ptr_to_restore_cur
	BL output_string
	LDR r0, ptr_to_down
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string
	LDR r0, ptr_to_x
	BL output_string
	LDR r0, ptr_to_greenCircle
	BL output_string
	LDR r0, ptr_to_right
	BL output_string
	BL output_string
	BL output_string
	LDR r0, ptr_to_cyanCircle
	BL output_string
	LDR r0, ptr_to_right
	BL output_string
	LDR r0, ptr_to_redCircle
	BL output_string
	LDR r0, ptr_to_x
	BL output_string

third:
	LDR r0, ptr_to_restore_cur
	BL output_string
	LDR r0, ptr_to_down
	BL output_string
	LDR r0, ptr_to_save_cur
	BL output_string
	LDR r0, ptr_to_x
	BL output_string
	LDR r0, ptr_to_right
	BL output_string
	BL output_string
	LDR r0, ptr_to_cyanCircle
	BL output_string
	LDR r0, ptr_to_right
	BL output_string
	BL output_string
	BL output_string
	LDR r0, ptr_to_blueCircle
	BL output_string
	LDR r0, ptr_to_x
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
	LDR r0, ptr_to_up
	BL output_string
DOWN:
	CMP r6, #0x73 	; check if char is ASCII 's'
	BNE LEFT
	LDR r0, ptr_to_down
	BL output_string
LEFT:
	CMP r6, #0x61 	; check if char is ASCII 'a'
	BNE RIGHT
	LDR r0, ptr_to_left
	BL output_string
RIGHT:
	CMP r6, #0x64 	; check if char is ASCII 'd'
	LDR r0, ptr_to_right
	BL output_string

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
