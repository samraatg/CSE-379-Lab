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
board: 	.string "-----------", 0xA, 0xD
		.string "|         |", 0xA, 0xD
		.string "|         |", 0xA, 0xD
		.string "|         |", 0xA, 0xD
		.string "|         |", 0xA, 0xD
		.string "|    *    |", 0xA, 0xD
		.string "|         |", 0xA, 0xD
		.string "|         |", 0xA, 0xD
		.string "|         |", 0xA, 0xD
		.string "|         |", 0xA, 0xD
		.string "|         |", 0xA, 0xD
		.string "-----------", 0xA, 0xD, 0x0
lab5:
	STMFD SP!,{r0-r12,lr}
	; Your code is placed here
 	BL uart_init
 	BL gpio_init
 	BL interrupt_init
 	BL timer_init

 	; DONE initialize game board, 10x10 asterik in middle

 	; make asktrik drift to right

 	; if space pressed go from right to left, left to right,
 	; up to down, or down to up

 	; if asterik hits wall, end game

 	; if sw1 is pressed go from vertical to horizontal, or vice versa

 	MOV r4, #0xC000
	MOVT r4, #0x4000 ; base address of UART0 (data register)

LOOP:
	LDRB r0,[r4] ; load UARTDATA
	CMP r0, #0x20 ; compare data to ASCII 'space'
	BNE NO_SPACE
	; change direction, right to left, vice versa
	; or up to down, vice versa
NO_SPACE:
	CMP r0, #0x71 ; compare data to ASCII 'q'
	BNE LOOP ; exit if q pressed

 	LDMFD sp!, {r0-r12,lr}
 	MOV pc, lr


interrupt_init:
	STMFD SP!,{r0-r12,lr}
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
	ORR r5, #0x10 ; set bit 4 (SW1) to enable
	STR r5, [r4, #0x410]
	; set GPIOF in EN0
	MOV r4, #0xE000
	MOVT r4, #0xE000 ; base address of EN0
	LDR r5, [r4, #0x100] ; load EN0 offset
	ORR r5, r5, #0x40000000 ; set bit 30 (GPIOF)
	STR r5, [r4, #0x100]
	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr

timer_init:
	STMFD SP!,{r0-r12,lr} ; Preserve registers on the stack
 	; connect clock to timer via RCGCTIMER
 	MOV r4, #0xE000
 	MOVT r4, #0x400F
 	LDR r5, [r4, #0x604] ; T0 RCGCTIMER effective address
 	ORR r5, r5, #0x1 ; set bit0 to 1 (enable T0)
 	STR r5, [r4, #0x604]
 	; disable timer via GPTMCTL
 	MOV r4, #0x0000
 	MOVT r4, #0x4003 ; T0 base address
 	LDR r5, [r4, #0x00C] ; GPTMCTL offset
 	BIC r5, #0x1 ; set bit0 to 0 (TAEN)
 	STR r5, [r4, #0x00C]
 	; put timer in 32bit mode via GPTMCFG
 	LDR r5, [r4] ; GPTMCFG offset
 	BIC r5, #0x1 ; set bit0 to 0 for config0
 	BIC r5, #0x2 ; set bit1 to 0 for config0
 	BIC r5, #0x4 ; set bit2 to 0 for config0
 	STR r5, [r4]
 	; put timer in periodic mode via GPTMTAMR
 	LDR r5, [r4, #0x004] ; GPTMTAMR offset
 	ORR r5, r5, #0x2 ; set bit1 to 1 for mode2 (periodic)
 	BIC r5, #0x1 ; set bit0 to 0 for mode2 (periodic)
 	STR r5, [r4, #0x004]
 	; setup interrupt interval period via GPTMTAILR
 	;LDR r5, [r4, #0x028] ; GPTMTAILR offset
 	MOV r5, #0x2400
	MOVT r5, #0x00F4 ; r5 = 16*10^6, timer should be 1s intervals
 	STR r5, [r4, #0x028]
 	; enable timer to interrupt processor via GPTMIMR
 	LDR r5, [r4, #0x018] ; GPTMIMR offset
 	ORR r5, r5, #0x1 ; set bit0 to 1 (TATOIM)
 	STR r5, [r4, #0x018]
 	; configure processor to allow timer interrupts via EN0
 	MOV r6, #0xE000
 	MOVT r6, #0xE000 ; EN0 base address
 	LDR r5, [r6, #0x100] ; EN0 offset
 	ORR r5, r5, #0x80000 ; set bit19 to 1 (Timer0A)
 	STR r5, [r6, #0x100]
 	; enable timer via GPTMCTL
 	LDR r5, [r4, #0x00C] ; GPTMCTL offset
 	ORR r5, r5, #0x1 ; set bit0 to 1 (TAEN)
 	STR r5, [r4, #0x00C]

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
	LDMFD sp!, {r0-r12,lr}
	BX lr

Switch_Handler:
	STMFD SP!,{r0-r12,lr} ; Store register lr on stack
	; clear SW1 in GPIOICR
	MOV r4, #0x5000
	MOVT r4, #0x4002 ; base address of GPIOF
	LDR r5, [r4, #0x41C] ; load GPIOICR
	ORR r5, r5, #0x10 ; set bit 4 (SW1) to clear
	STR r5, [r4, #0x41C]

	; change dirction, up to down, vice versa
	; or left to right, vice versa

	LDMFD sp!, {r0-r12,lr}
	BX lr

Timer_Handler:
	STMFD SP!,{r0-r12,lr} ; Preserve registers on the stack
	; clear interrupt via GPTMICR
 	MOV r4, #0x0000
 	MOVT r4, #0x4003 ; T0 base address
 	LDR r5, [r4, #0x024] ; GPTMICR offset
 	ORR r5, r5, #0x1 ; set bit0 to 1 (TATOCINT)
 	STR r5, [r4, #0x024]

	; swap asterik with next position

	LDMFD sp!, {r0-r12,lr}
	BX lr

.end
