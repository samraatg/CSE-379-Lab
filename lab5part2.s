	.text
	.global UART0_Handler
	.global Switch_Handler
	.global interrupt_init
	.global lab5
	.global uart_init
	.global gpio_init
	.global illuminate_RGB_LED
lab5:
	STMFD SP!,{r0-r12,lr} ; Store register lr on stack

	; Your code is placed here
 	BL uart_init
 	BL gpio_init
 	BL interrupt_init

 	MOV r0, #1 ; set RGB LED to red
	BL illuminate_RGB_LED

 	MOV r4, #0xC000
	MOVT r4, #0x4000 ; base address of UART0 (data register)

UART_LOOP:
	LDRB r0,[r4] ; load UARTDATA
	CMP r0, #0x71 ; compare data to ASCII 'q'
	BNE UART_LOOP


;GPIO_LOOP:
;	MOV r4, #0x53FC	; GPIOF data register
;	MOVT r4, #0x4002
;	LDR r0, [r4]
;	CMP r0, #0 ; compare data to 0 for RGB LED off
;	BNE GPIO_LOOP


 	LDMFD sp!, {r0-r12,lr}
 	MOV pc, lr


interrupt_init:
	STMFD SP!,{r0-r12,lr} ; Store register lr on stack

	; Your code is placed here

	; UART interrupt initialization
	; set RXIM in UARTIM
	MOV r4, #0xC000
	MOVT r4, #0x4000 ; base address of UART0
	LDR r5, [r4, #0x38] ; load UARTIM
	ORR r5, r5, #0x10 ; set bit 4 (RXIM)
	STR r5, [r4, #0x38]
	; set UART0 in EN0
	MOV r4, #0xE000
	MOVT r4, #0xE000 ; base address of EN0
	LDR r5, [r4, #0x100] ; load EN0 offset
	ORR r5, r5, #0x20 ; set bit 5 (UART0)
	STR r5, [r4, #0x100]

	; GPIO interrupt initialization
	; set SW1 for edge sensitive in GPIOIS
	MOV r4, #0x5000
	MOVT r4, #0x4002 ; base address of GPIOF
	LDR r5, [r4, #0x404] ; load GPIOIS offset
	BIC r5, #0x10 ; set bit 4 (SW1) to 0 (for edge sensitive)
	STR r5, [r4, #0x404]

	; set GPIOEV for interrupt control in GPIOIBE
	LDR r5, [r4, #0x408] ; load GPIOEV offset
	BIC r5, #0x10 ; set bit 4 (SW1) to 0 (for GPIOEV)
	STR r5, [r4, #0x408]

	; set falling edge in GPIOIV
	LDR r5, [r4, #0x40C] ; load GPIOIV offset
	BIC r5, #0x10 ; set bit 4 (SW1) to falling edge
	STR r5, [r4, #0x40C]

	; enable interrupt via GPIOIM
	LDR r5, [r4, #0x410] ; load GPIOIM offset
	AND r5, #0x10 ; set bit 4 (SW1) to enable
	STR r5, [r4, #0x410]

	; set GPIOF in EN0
	MOV r4, #0xE000
	MOVT r4, #0xE000 ; base address of EN0
	LDR r5, [r4, #0x100] ; load EN0 offset
	ORR r5, r5, #0x40000000 ; set bit 30 (GPIOF)
	STR r5, [r4, #0x100]


	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr
UART0_Handler:
	STMFD SP!,{r0-r12,lr} ; Store register lr on stack

	; Your code is placed here

	; set RXIM in UARTICR
	MOV r4, #0xC000
	MOVT r4, #0x4000 ; base address of UART0
	LDR r5, [r4, #0x44] ; load UARTICR
	ORR r5, r5, #0x10 ; set bit 4 (RXIM)
	STR r5, [r4, #0x44]

	;
	LDMFD sp!, {r0-r12,lr}
	BX lr

Switch_Handler:
	STMFD SP!,{r0-r12,lr} ; Store register lr on stack

	; Your code is placed here

	; clear SW1 in GPIOICR
	MOV r4, #0x5000
	MOVT r4, #0x4002 ; base address of GPIOF
	LDR r5, [r4, #0x41C] ; load GPIOICR
	ORR r5, r5, #0x10 ; set bit 4 (SW1) to clear
	STR r5, [r4, #0x41C]

	MOV r0, #0
	BL illuminate_RGB_LED

	LDMFD sp!, {r0-r12,lr}
	BX lr
.end
