	.text
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



	; Your routines go here
	; Required routines are shown in the global declarations above

; input: char from PuTTy terminal
; output: char in r0
; uses r0-r2
read_character:
	STMFD sp!,{lr}
	STMFD sp!,{r1-r2}
		MOV r1,#0xC000
		MOVT r1,#0x4000 	; r1 = base address of UART
TEST_RFE:
		LDRB r2,[r1, #U0FR] ; load 0x4000C018 (U0FR) into r2
		AND r2,r2,#0x10 	; mask all bits except RxFE (bit 4)
		CMP r2,#0x10		; test RxFE in status register
		BEQ TEST_RFE 		; if RxFE == 1, test again
		LDRB r0,[r1] 		; else RxFE == 0, read byte (r0) from receive register (r1)
	LDMFD sp!, {r1-r2}
 	LDMFD sp!, {lr}
	mov pc, lr

; input: char to output in r0
; output: char in PuTTy terminal
; uses r0-r2
output_character:
	STMFD sp!,{lr}
	STMFD sp!, {r1-r2}
		MOV r1,#0xC000
		MOVT r1,#0x4000 	; r1= base address of UART
TEST_TFF:
		LDRB r2,[r1, #U0FR] ; load 0x4000C018 (U0FR) into r2
		AND r2,r2,#0x20 	; mask all bits except TxFF (bit 5)
		CMP r2,#0x20		; test TxFF in status register
		BEQ TEST_TFF 		; if TxFF == 1, test again
		STRB r0,[r1] 		; else TxFF == 0, store byte (r0) in transmit register (r1)
	LDMFD sp!, {r1-r2}
 	LDMFD sp!, {lr}
	mov pc, lr

; input: base address of str in r0
; output: str in PuTTy terminal
; uses r0-r1
output_string:
	STMFD sp!,{lr}
	STMFD sp!,{r0-r1}
	MOV r1,r0				; move str base address to r1
OS_LOOP:
		LDRB r0,[r1]   		; load char
		CMP r0,#0x0    		; check if char=NULL
		BEQ OS_STR_END 		; if so, exit
		BL output_character ; display char
		ADD r1,r1,#1		; increment ptr
		B OS_LOOP
OS_STR_END:
	LDMFD sp!,{r0-r1}
 	LDMFD sp!, {lr}
	mov pc, lr

; input: str from PuTTy terminal
; output: str stored in memory, base address r0
; uses r0-r1
read_string:
	STMFD sp!,{lr}
	STMFD sp!,{r0-r1}
	MOV r1, r0				; move str base address to r1
RS_LOOP:
		BL read_character
		CMP r0,#0xD 		; check for enter char
		BEQ RS_STR_END 		; exit if char='enter'
		STRB r0,[r1]   		; store char in str
		ADD r1,r1,#1   		; increment ptr
		B RS_LOOP
RS_STR_END:
		MOV r0, #0x0
		STRB r0, [r1] 		; store null at end of str
	LDMFD sp!, {r0-r1}
 	LDMFD sp!, {lr}
	mov pc, lr

; initializes uart for use
uart_init:
	STMFD SP!,{lr}	; Store register lr on stack

		MOV r0,#1
		MOV r1,#0xE618
		MOVT r1,#0x400F
		str r0,[r1]

		MOV r0,#1
		MOV r1,#0xE608
		MOVT r1,#0x400F
		str r0,[r1]

		MOV r0,#0
		MOV r1,#0xC030
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#8
		MOV r1,#0xC024
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#44
		MOV r1,#0xC028
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#0
		MOV r1,#0xCFC8
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#0x60
		MOV r1,#0xC02C
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#0x301
		MOV r1,#0xC030
		MOVT r1,#0x4000
		str r0,[r1]

		MOV r0,#0x03
		MOV r1,#0x451C
		MOVT r1,#0x4000
		ldr r2,[r1]
		ORR r2,r2,r0
		str r2,[r1]

		MOV r0,#0x03
		MOV r1,#0x4420
		MOVT r1,#0x4000
		ldr r2,[r1]
		ORR r2,r2,r0
		str r2,[r1]

		MOV r0,#0x11
		MOV r1,#0x452C
		MOVT r1,#0x4000
		ldr r2,[r1]
		ORR r2,r2,r0
		str r2,[r1]

 	LDMFD sp!, {lr}
	mov pc, lr

; initializes onboard RGB LED and SW1 for GPIO use
init_gpio:
	STMFD sp!, {lr, r0-r1}
		MOV r0,#0xE000
		MOVT r0,#0x400F
		LDR r1, [r0, #0x608]
		ORR r1, r1, #0x20		; enable clock for gpio port F
		STRB r1, [r0, #0x608]
		MOV r0, #0x5000			; move r1 to GPIO port F base address
		MOVT r0, #0x4002
		LDR r1, [r0, #0x400]
		ORR r1, r1, #0xE		; 1110 for pin directions
		STR r1, [r0, #0x400] 	; set direction for each pin
		LDR r1, [r0, #0x51C]
		ORR r1, r1, #0xFF	 	; digital io pin enable
		STR r1, [r0, #0x51C] 	; configure pins for digital io
		LDR r1, [r0, #0x510]
		ORR r1, r1, #0x10		; enable pull-up resistor for pin4 (sw1)
		STR r1, [r0, #0x510] 	; configure pins for digital io
	LDMFD sp!, {lr, r0-r1}
	MOV pc, lr

; input: momentary button press from onboard SW1
; output: r0 (1 if pressed, 0 if not)
read_from_push_btn:
	STMFD SP!,{lr, r1-r3}	; Store register lr on stack
		MOV r0, #0
		MOV r1, #0x53FC		; move r1 to GPIO port F data register
		MOVT r1, #0x4002
		LDR r2, [r1]
		AND r3, r2, #0x10 	; check pin4 value
		CMP r3, #0x0
		BNE RFPB_DONE
		MOV r0, #1			; if pin4=0, r0=1
RFPB_DONE:
	LDMFD sp!, {lr, r1-r3}
	MOV pc, lr

; input: integer in r0
; output: onboard RGB LED color output
; uses r0-r3
illuminate_RGB_LED:
	STMFD SP!,{lr, r0-r3}
		  ; encoding: RGB, 001=red, 010=blue, 100=green,
		  ; 011=purple, 101=yellow, 110=cyan, 111=white
		  MOV r1, #0x53FC	; move r1 to GPIO port F data register
		  MOVT r1, #0x4002

		  AND r2, r0, #0x1 	; check bit1
		  CMP r2, #0x1
		  BNE AFTER_RED
		  LDR r3, [r1]
		  ORR r3, #0x2 		; set pin1 to 1 for red on
		  STR r3, [r1]
AFTER_RED:
		  AND r2, r0, #0x2 	; check bit2
		  CMP r2, #0x2
		  BNE AFTER_BLUE
		  LDR r3, [r1]
		  ORR r3, #0x4 		; set pin2 to 1 for blue on
		  STR r3, [r1]
AFTER_BLUE:
		  AND r2, r0, #0x4 	; check bit3
		  CMP r2, #0x4
		  BNE AFTER_GREEN
		  LDR r3, [r1]
		  ORR r3, #0x8 		; set pin3 to 1 for green on
		  STR r3, [r1]
AFTER_GREEN:
	LDMFD sp!, {lr, r0-r3}
	MOV pc, lr

; input: integer in r0
; output: length of integer in r0
; uses r0-r3
num_digits:
 	STMFD sp!, {lr}
 	STMFD sp!, {r1-r3}
 		CMP r0, #0 		; r0=i, check if i is negative
 		BGE ND_START
 		MOV r1, #-1
 		MUL r0, r1 		; if so, make positive
ND_START:
 		MOV r2, #0 		; r2=n, initialize n=0
ND_LOOP:
		MOV r3, #10
		UDIV r0, r0, r3 ; i=i/10
		ADD r2, r2, #1 	; n=n+1
		CMP r0, #0 		; exit if i=0
		BNE ND_LOOP
		MOV r0, r2 		; return n in r0
	LDMFD sp!, {r1-r3}
 	LDMFD sp!, {lr}
 	MOV pc, lr

; input: string starting at r1
; output: integer in r0
; uses r0-r4
str2int:
 	STMFD sp!, {lr}
 	STMFD sp!, {r1-r4}
		MOV r0, #0		; r0=i, initialize i=0
		LDRB r2, [r1] 	; load 1st char to see if int is negative
		MOV r3, #1
		CMP r2, #0x2D 	; compare 1st char with ASCII'-'
		BNE S2I_LOOP
		MOV r3, #-1 	; if first char is '-', r3=-1
		ADD r1, r1, #1	; move ptr to 2nd char (start of int)
S2I_LOOP:
		LDRB r2, [r1] 	; r2=char, load char from str ptr
		CMP r2, #0x0 	; if char=NULL, exit
		BEQ S2I_DONE
		MOV r4, #10
		MULT r0,r0,r4 	; r0=i, i=i*10
		SUB r2,r2,#0x30 ; r2=dig, dig=ASCII'dig'-ASCII'0'
		ADD r0,r0,r2 	; i=i+dig
		ADD r1,r1,#1 	; increment ptr
		B S2I_LOOP
S2I_DONE:
		MULT r0, r3 	; restore int sign if negative
	LDMFD sp!, {r1-r4}
	LDMFD sp!, {lr}
	MOV pc, lr

; input: integer in r0, integer length in r2
; output: string of the integer starting at r1
; uses r0-r6
int2str:
	STMFD sp!, {lr}
	STMFD sp!, {r2-r6}
		ADD r1,r1,r2	; add num of digits to str ptr, r1=r1+r2
		MOV r2,#0		; r2 is placeholder for '-' character
		CMP r0,#0		; check to see if int is negative
		BGE I2S_START
		ADD r1,r1,#1 	; add another "digit" to account for '-'
		MOV r3,#-1
		MULT r0,r0,r3 	; make int positive
		MOV r3,#0x2D 	; store ASCII'-' in r3 to add to str later
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
		CMP r3,#0x2D 	; check to see if '-' still needs to be in str
		BNE I2S_DONE
		SUB r1,r1,#1 	; go to front of string
		STRB r3,[r1] 	; store '-' at front of string
I2S_DONE:
	LDMFD sp!, {r2-r6}
	LDMFD sp!, {lr}
	MOV pc, lr

; formats a newline after a prompt is answered
; uses r0-r2
do_newline:
	STMFD sp!, {lr}
		MOV r0, #0xA 				; ASCII newline
		BL output_character 		; output newline in terminal
		MOV r0, #0xD 				; ASCII CR(enter), formats newline to front
		BL output_character 		; fix newline to front
	LDMFD sp!, {lr}
	MOV pc, lr


.end
