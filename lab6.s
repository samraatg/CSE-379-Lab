	.data

x:	.string 27,"[01mx",0
blue_circle: .string 27,"[34mo",0
green_circle: .string 27,"[32mo",0
cyan_circle: .string 27,"[36mo",0
white_circle: .string 27,"[37mo",0
yellow_circle: .string 27,"[33mo",0
red_circle:	.string 27,"[31mo",0
magenta_circle:	.string 27,"[35mo",0
cursor: .string 27,"[0;0H",0


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
ptr_to_x:	.word x

lab6:
	STMFD SP!,{r0-r12,lr}
 	BL uart_init
 	BL gpio_init
	BL interrupt_init

	LDR r0, ptr_to_cursor
	LDR r4, [r0] 		;top half of cursor (ESC [8;)
	LDR r5, [r0, #4]	; bottom half of cursor (14H 0x0)
	BL output_string

;print 10 X's
	mov r5,#0
X_loop:
	add r5,#1
	LDR r0,ptr_to_x
	BL output_string
	cmp r5,#10
	BNE X_loop


	LDR r0, ptr_to_greenCircle
	BL output_string
LOOP:
	B LOOP

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
	LDR r5, ptr_to_cursor
	LDR r7, [r5] 		;top half of cursor (ESC [8;)
	LDR r8, [r5, #4]	; bottom half of cursor (14H 0x0)
	; grab row and column of cursor
	UBFX r9, r7, #16, #8	; r9 = line
	UBFX r10, r8, #0, #16	; r10 = column
UP:
	CMP r6, #0x77 ; check if char is ASCII 'w'
	BNE DOWN
	ADD r9, r9, #1	; move line up
DOWN:
	CMP r6, #0x73 	; check if char is ASCII 's'
	BNE LEFT
	SUB r9, r9, #1	; move line down
LEFT:
	CMP r6, #0x61 	; check if char is ASCII 'a'
	BNE RIGHT
	SUB r10, r10, #0x100	; move column left
RIGHT:
	CMP r6, #0x64 	; check if char is ASCII 'd'
	BNE ELSE
	ADD r10, r10, #0x100	; move column right
ELSE:
	; update postion
	BFI r7, r9, #16, #8
	BFI r8, r10, #0, #16
	STR r7, [r5] 			; store top half of cursor (ESC [8;)
	STR r8, [r5, #4]		; store bottom half of cursor (14H 0x0)
	; output cursor
	MOV r0, r5
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
