	.text
	.global interrupt_init
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
;extras
	.global do_newline
	; Your routines go here
	; Required routines are shown in the global declarations above

; initialize timer 0 for interrupts every 1 second
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

; initialize interrupts for LED and SW1
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

; input: char from PuTTy terminal
; output: char in r0
read_character:
	STMFD sp!,{lr, r4-r11}
		MOV r4,#0xC000
		MOVT r4,#0x4000 	; r4 = base address of UART
TEST_RFE:
		LDRB r5,[r4, #0x18] ; load 0x4000C018 (U0FR) into r5
		AND r5,r5,#0x10 	; mask all bits except RxFE (bit 4)
		CMP r5,#0x10		; test RxFE in status register
		BEQ TEST_RFE 		; if RxFE == 1, test again
		LDRB r0,[r4] 		; else RxFE == 0, read byte from receive register (r4)
		; char is returned in r0
 	LDMFD sp!, {lr, r4-r11}
	mov pc, lr

; input: char to output in r0
; output: char in PuTTy terminal
output_character:
	STMFD sp!,{lr, r4-r11}
		MOV r4,#0xC000
		MOVT r4,#0x4000 	; r4 = base address of UART
TEST_TFF:
		LDRB r5,[r4, #0x18] ; load 0x4000C018 (U0FR) into r4
		AND r5,r5,#0x20 	; mask all bits except TxFF (bit 5)
		CMP r5,#0x20		; test TxFF in status register
		BEQ TEST_TFF 		; if TxFF == 1, test again
		STRB r0,[r4] 		; else TxFF == 0, store byte (r0) in transmit register (r4)
 	LDMFD sp!, {lr, r4-r11}
	mov pc, lr

; input: base address of str in r0
; output: str in PuTTy terminal
output_string:
	STMFD sp!,{lr, r4-r11}
	MOV r5,r0				; move str base address to r1
OS_LOOP:
		LDRB r0,[r5]   		; load char
		CMP r0,#0x0    		; check if char=NULL
		BEQ OS_STR_END 		; if so, exit
		BL output_character ; display char
		ADD r5,r5,#1		; increment ptr
		B OS_LOOP
OS_STR_END:
 	LDMFD sp!, {lr, r4-r11}
	mov pc, lr

; input: str from PuTTy terminal
; output: str stored in memory, base address r0
read_string:
	STMFD sp!,{lr, r4-r11}
	MOV r4, r0				; move str base address to r1
RS_LOOP:
		BL read_character
		CMP r0,#0xD 		; check for enter char
		BEQ RS_STR_END 		; exit if char='enter'
		STRB r0,[r4]   		; store char in str
		ADD r4,r4,#1   		; increment ptr
		B RS_LOOP
RS_STR_END:
		MOV r0, #0x0
		STRB r0, [r4] 		; store null at end of str
 	LDMFD sp!, {lr, r4-r11}
	mov pc, lr

; initializes uart for use
uart_init:
	STMFD SP!,{lr, r4-r11}	; Store register lr on stack

		MOV r4,#1
		MOV r5,#0xE618
		MOVT r5,#0x400F
		str r4,[r5]

		MOV r4,#1
		MOV r5,#0xE608
		MOVT r5,#0x400F
		str r4,[r5]

		MOV r4,#0
		MOV r5,#0xC030
		MOVT r5,#0x4000
		str r4,[r5]

		MOV r4,#8
		MOV r5,#0xC024
		MOVT r5,#0x4000
		str r4,[r5]

		MOV r4,#44
		MOV r5,#0xC028
		MOVT r5,#0x4000
		str r4,[r5]

		MOV r4,#0
		MOV r5,#0xCFC8
		MOVT r5,#0x4000
		str r4,[r5]

		MOV r4,#0x60
		MOV r5,#0xC02C
		MOVT r5,#0x4000
		str r4,[r5]

		MOV r4,#0x301
		MOV r5,#0xC030
		MOVT r5,#0x4000
		str r4,[r5]

		MOV r4,#0x03
		MOV r5,#0x451C
		MOVT r5,#0x4000
		ldr r6,[r5]
		ORR r6,r6,r4
		str r6,[r5]

		MOV r4,#0x03
		MOV r5,#0x4420
		MOVT r5,#0x4000
		ldr r6,[r5]
		ORR r6,r6,r4
		str r6,[r5]

		MOV r4,#0x11
		MOV r5,#0x452C
		MOVT r5,#0x4000
		ldr r6,[r5]
		ORR r6,r6,r4
		str r6,[r5]
 	LDMFD sp!, {lr, r4-r11}
	mov pc, lr

; initializes onboard RGB LED and SW1 for GPIO use
gpio_init:
	STMFD sp!, {lr, r4-r11}
		MOV r4,#0xE000
		MOVT r4,#0x400F
		LDR r5, [r4, #0x608]
		ORR r5, r5, #0x20		; enable clock for gpio port F
		STRB r5, [r4, #0x608]
		MOV r4, #0x5000			; move r4 to GPIO port F base address
		MOVT r4, #0x4002
		LDR r5, [r4, #0x400]
		ORR r5, r5, #0xE		; 1110 for pin directions
		STR r5, [r4, #0x400] 	; set direction for each pin
		LDR r5, [r4, #0x51C]
		ORR r5, r5, #0xFF	 	; digital io pin enable
		STR r5, [r4, #0x51C] 	; configure pins for digital io
		LDR r5, [r4, #0x510]
		ORR r5, r5, #0x10		; enable pull-up resistor for pin4 (sw1)
		STR r5, [r4, #0x510] 	; configure pins for digital io
	LDMFD sp!, {lr, r4-r11}
	MOV pc, lr

; input: momentary button press from onboard SW1
; output: r0 (1 if pressed, 0 if not)
read_from_push_btn:
	STMFD SP!,{lr, r4-r11}	; Store register lr on stack
		MOV r0, #0
		MOV r4, #0x53FC		; move r4 to GPIO port F data register
		MOVT r4, #0x4002
		LDR r5, [r4]
		AND r6, r5, #0x10 	; check pin4 value
		CMP r6, #0x0
		BNE RFPB_DONE
		MOV r0, #1			; if pin4=0, r0=1
RFPB_DONE:
	LDMFD sp!, {lr, r4-r11}
	MOV pc, lr

; input: integer in r0
; output: onboard RGB LED color output
illuminate_RGB_LED:
	STMFD SP!,{lr, r4-r11}
		  ; encoding: RGB, 001=red, 010=blue, 100=green,
		  ; 011=purple, 101=yellow, 110=cyan, 111=white
		  MOV r4, #0x53FC	; move r4 to GPIO port F data register
		  MOVT r4, #0x4002
		  LDR r6, [r4]		; load data reg in r6
		  AND r5, r0, #0x1 	; check bit1
		  CMP r5, #0x1
		  BEQ RED_ON
		  LDR r6, [r4]
		  BIC r6, #0x2 		; set pin1 to 0 for red off
		  STR r6, [r4]
		  B BLUE_START
RED_ON:
		  ORR r6, #0x2 		; set pin1 to 1 for red on
		  STR r6, [r4]
BLUE_START:
		  LDR r6, [r4]		; reload data reg in r6
		  AND r5, r0, #0x2 	; check bit2
		  CMP r5, #0x2
		  BEQ BLUE_ON
		  BIC r6, #0x4 		; set pin2 to 0 for blue off
		  STR r6, [r4]
		  B GREEN_START
BLUE_ON:
		  ORR r6, #0x4 		; set pin2 to 1 for blue on
		  STR r6, [r4]
GREEN_START:
		  LDR r6, [r4]		; reload data reg in r6
		  AND r5, r0, #0x4 	; check bit3
		  LDR r6, [r4]
		  CMP r5, #0x4
		  BEQ GREEN_ON
		  BIC r6, #0x8 		; set pin3 to 0 for green off
		  STR r6, [r4]
		  B IRGB_EXIT
GREEN_ON:
		  ORR r6, #0x8 		; set pin3 to 1 for green on
		  STR r6, [r4]
IRGB_EXIT:
	LDMFD sp!, {lr, r4-r11}
	MOV pc, lr

; input: integer in r0
; output: length of integer in r0
num_digits:
 	STMFD sp!, {lr, r4-r11}
 		CMP r0, #0 		; r0=i, check if i is negative
 		BGE ND_START
 		MOV r4, #-1
 		MUL r0, r4 		; if so, make positive
ND_START:
 		MOV r5, #0 		; r2=n, initialize n=0
ND_LOOP:
		MOV r6, #10
		UDIV r0, r0, r6 ; i=i/10
		ADD r5, r5, #1 	; n=n+1
		CMP r0, #0 		; exit if i=0
		BNE ND_LOOP
		MOV r0, r5 		; return n in r0
 	LDMFD sp!, {lr, r4-r11}
 	MOV pc, lr

; input: string starting at r1
; output: integer in r0
str2int:
 	STMFD sp!, {lr, r4-r11}
		MOV r0, #0		; r0=i, initialize i=0
		LDRB r4, [r1] 	; load 1st char to see if int is negative
		MOV r5, #1
		CMP r4, #0x2D 	; compare 1st char with ASCII'-'
		BNE S2I_LOOP
		MOV r5, #-1 	; if first char is '-', r5=-1
		ADD r1, r1, #1	; move ptr to 2nd char (start of int)
S2I_LOOP:
		LDRB r4, [r1] 	; r4=char, load char from str ptr
		CMP r4, #0x0 	; if char=NULL, exit
		BEQ S2I_DONE
		MOV r6, #10
		MULT r0,r0,r6 	; r0=i, i=i*10
		SUB r4,r4,#0x30 ; r4=dig, dig=ASCII'dig'-ASCII'0'
		ADD r0,r0,r4 	; i=i+dig
		ADD r1,r1,#1 	; increment ptr
		B S2I_LOOP
S2I_DONE:
		MULT r0, r5 	; restore int sign if negative
	LDMFD sp!, {lr, r4-r11}
	MOV pc, lr

; input: integer in r0, integer length in r2
; output: string of the integer starting at r1
int2str:
	STMFD sp!, {lr, r4-r11}
		ADD r1,r1,r2	; add num of digits to str ptr, r1=r1+r2
		MOV r2,#0		; r2 is placeholder for '-' character
		CMP r0,#0		; check to see if int is negative
		BGE I2S_START
		ADD r1,r1,#1 	; add another "digit" to account for '-'
		MOV r7,#-1
		MULT r0,r0,r7 	; make int positive
		MOV r7,#0x2D 	; store ASCII'-' in r3 to add to str later
I2S_START:
		ADD r1,r1,r2    ; add num of digits to str ptr r1=r1+r2
		MOV r4,#0x0
		STRB r4,[r1]	; store NULL at the end of the str
		SUB r1,r1,#1	; increment to next char in str
I2S_LOOP:
		MOV r4,#10
		UDIV r5,r0,r4	; r5=q, q=i/10
		MUL r6,r5,r4	; r6=p, p=q*10
		SUB r6,r0,r6	; r6=dig, dig=i-p
		ADD r6,r6,#0x30	; r6=ascii, ascii=dig+ASCII'0'
		STRB r6,[r1]	; store ascii digit in str
		MOV r0,r5		; r0=i=q, remove LSD from int
		CMP r0,#0		;
		BEQ I2S_STOP	; if i=0, exit
		SUB r1,r1,#1	; else i!=0, increment to next char in str
		B I2S_LOOP
I2S_STOP:
		CMP r7,#0x2D 	; check to see if '-' still needs to be in str
		BNE I2S_DONE
		SUB r1,r1,#1 	; go to front of string
		STRB r7,[r1] 	; store '-' at front of string
I2S_DONE:
	LDMFD sp!, {lr, r4-r11}
	MOV pc, lr

; extras
;-----------------------------------------------------------------------------

; formats a newline after string is outputed with UART
do_newline:
	STMFD sp!, {lr, r0-r11}
		MOV r0, #0xA 				; ASCII newline
		BL output_character 		; output newline in terminal
		MOV r0, #0xD 				; ASCII CR(enter), formats newline to front
		BL output_character 		; fix newline to front
	LDMFD sp!, {lr, r0-r11}
	MOV pc, lr

	.end
