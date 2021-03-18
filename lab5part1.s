	.text
	.global UART0_Handler
	.global Switch_Handler
	.global interrupt_init
	.global lab5
	.global uart_init
	.global gpio_init
lab5:
	STMFD SP!,{r0-r12,lr} ; Store register lr on stack

	; Your code is placed here
 	BL uart_init
 	BL gpio_init
 	BL interrupt_init

 	MOV r4, #0xC000
	MOVT r4, #0x4000 ; base address of UART0

LOOP:
	LDRB r0,[r4] ; load UARTDATA
	CMP r0, #0x71 ; compare data to ASCII 'q'
	BNE LOOP

 	LDMFD sp!, {r0-r12,lr}
 	MOV pc, lr
interrupt_init:
	STMFD SP!,{r0-r12,lr} ; Store register lr on stack

	; Your code is placed here

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



	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr
UART0_Handler:
	STMFD SP!,{r0-r12,lr} ; Store register lr on stack

	; Your code is placed here

	; set RXIM in UARTICR
	MOV r4, #0xC000
	MOVT r4, #0x4000 ; base address of UART0
	LDR r5, [r4, #0x44] ; load UARTIM
	ORR r5, r5, #0x10 ; set bit 4 (RXIM)
	STR r5, [r4, #0x44]

	;
	LDMFD sp!, {r0-r12,lr}
	BX lr

Switch_Handler:
	STMFD SP!,{r0-r12,lr} ; Store register lr on stack

	; Your code is placed here
	LDMFD sp!, {r0-r12,lr}
	BX lr
.end
