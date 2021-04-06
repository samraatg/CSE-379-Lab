	.data

x:	.string 27,"[01mx",0
blue_circle: .string 27,"[34mo",0
green_circle: .string 27,"[32mo",0
cyan_circle: .string 27,"[36mo",0
white_circle: .string 27,"[37mo",0
yellow_circle: .string 27,"[33mo",0
red_circle:	.string 27,"[31mo",0
magenta_circle:	.string 27,"[35mo",0
cursor: .string 27,"[8;14H",0


	.text
	.global UART0_Handler



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
	BL output_string

;print 10 X's
	mov r5,#0
First:
	add r5,#1
	LDR r0,ptr_to_x
	BL output_string
	cmp r5,#10
	BNE First

second:
	;move cursor to next line and left 9
	LDR r0,ptr_to_x
	BL output_string

	LDR r0, ptr_to_greenCircle
	BL output_string

	;add 3 to cursor
	LDR r0,ptr_to_cyanCircle
	BL output_string

	;add 1 to cursor
	LDR r0,ptr_to_redCircle
	BL output_string

	LDR r0,ptr_to_x
	BL output_string

third:
	;move cursor to next line and left 9
	LDR r0,ptr_to_x
	BL output_string

	;add 2 to cursor
	LDR r0,ptr_to_cyanCircle
	BL output_string

	;add 3 to cursor
	LDR r0, ptr_to_blueCircle
	BL output_string

	;add 1 to cursor
	LDR r0,ptr_to_x
	BL output_string

fourth:
	;move cursor to next line and left 9
	LDR r0,ptr_to_x
	BL output_string

	;add 2
	LDR r0, ptr_to_blueCircle
	BL output_string

	;add 4
	LDR r0,ptr_to_x
	BL output_string


fifth:
	;move cursor to next line and left 9
	LDR r0,ptr_to_x
	BL output_string

	;add 1
	LDR r0, ptr_to_redCircle
	BL output_string

	;add 3
	LDR r0, ptr_to_whiteCircle
	BL output_string

	;add 1
	LDR r0,ptr_to_x
	BL output_string


sixth:
	;move cursor to next line and left 9
	LDR r0,ptr_to_x
	BL output_string

	;add 3
	LDR r0, ptr_to_whiteCircle
	BL output_string

	;add 4
	LDR r0,ptr_to_x
	BL output_string

seventh:
	;move cursor to next line and left 9
	LDR r0,ptr_to_x
	BL output_string

	;add 1
	LDR r0, ptr_to_magentaCircle
	BL output_string

	;add 2
	LDR r0, ptr_to_yellowCircle
	BL output_string

	;add 2
	LDR r0,ptr_to_x
	BL output_string

eighth:
	;move cursor to next line and left 9
	LDR r0,ptr_to_x
	BL output_string

	;add 3
	LDR r0, ptr_to_yellowCircle
	BL output_string

	;add 1
	LDR r0,ptr_to_greenCircle
	BL output_string

	LDR r0,ptr_to_magentaCircle
	BL output_string

	LDR r0,ptr_to_x
	BL output_string

	mov r5,#0
Ninth:
	add r5,#1
	LDR r0,ptr_to_x
	BL output_string
	cmp r5,#10
	BNE Ninth
