	.data

boardNumber: .string "0",0
    
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
    .global int2str
    .global num_digits

ptr_to_boardNumber:	.word boardNumber


    ; inside timer handler
    BL timer_init

    ; a%b = a - (b*(a/b))
 	MOV r5,#16
	MOV r4, #0x0050
	MOVT r4, #0x4003
    LDR r4, [r4]
    UDIV r6,r4,r5
    MUL r6,r5,r6
    SUB r6,r4,r6
    MOV r0,r6
    BL num_digits
    mov r2,r0
    mov r0,r6
    BL int2str
    LDR r10, ptr_to_boardNumber
    STR r1,[r10]