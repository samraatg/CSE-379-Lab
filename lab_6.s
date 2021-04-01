	.data

x:	.string 27,"[01mx",0
blue_circle: .string 27,"[34mo",0
green_circle: .string 27,"[32mo",0
cyan_circle: .string 27,"[36mo",0
white_circle: .string 27,"[37mo",0
yellow_circle: .string 27,"[33mo",0
red_circle:	.string 27,"[31mo",0
magenta_circle:	.string 27,"[35mo",0
cursor: .string 27,"[8;14H"


	.text
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler
	.global timer_init
	.global interrupt_init
	.global lab5
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

lab5:
	STMFD SP!,{r0-r12,lr}
 	BL uart_init
 	BL gpio_init
	BL interrupt_init

	LDR r0, ptr_to_cursor
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
	LDR r5, [r4]
	ldr r6,ptr_to_cursor
UP:
	CMP r5, #0x57 ; check if char is ASCII 'w'
	BNE DOWN
	



DOWN:
	CMP r5, #0x53 ; check if char is ASCII 'w'
	BNE LEFT



LEFT:
	CMP r5, #0x41 ; check if char is ASCII 'w'
	BNE RIGHT



RIGHT:
	CMP r5, #0x44 ; check if char is ASCII 'w'
	BNE ELSE


ELSE:
	LDMFD sp!, {r0-r12,lr}
	BX lr

.end

