	.text
	.global lab4

lab4:
	STMFD SP!,{lr, r0-r2}
		BL init_gpio
		MOV r1, #0
		MOV r2, #0
CHECK_BTN_LOOP:
		BL read_from_push_btn
		ADD r2, r2, r0
		ADD r1, r1, #1
		CMP r1, #10
		BLT CHECK_BTN_LOOP
		MOV r0, r2
		BL illuminate_RGB_LED
	LDMFD sp!, {lr, r0-r2}
	MOV pc, lr

; input: momentary button press from onboard SW1
; output: r0 (1 if pressed, 0 if not)
read_from_push_btn:
	STMFD SP!,{lr, r1-r3}	; Store register lr on stack
		MOV r0, #0
		MOV r1, #0x53FC	; move r1 to GPIO port F data register
		MOVT r1, #0x4002
		LDR r2, [r1]
		AND r3, r2, #0x10 ; check pin4 value
		CMP r3, #0x0
		BNE RFPB_DONE
		MOV r0, #1	; if pin4=0, r0=1
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

		  AND r2, r0, #0x1 ; check bit1
		  CMP r2, #0x1
		  BNE AFTER_RED
		  LDR r3, [r1]
		  ORR r3, #0x2 ; set pin1 to 1
		  STR r3, [r1]
		  ; set gpio output for red
AFTER_RED:
		  AND r2, r0, #0x2 ; check bit2
		  CMP r2, #0x2
		  BNE AFTER_BLUE
		  LDR r3, [r1]
		  ORR r3, #0x4 ; set pin2 to 1
		  STR r3, [r1]
		  ; set gpio output for blue
AFTER_BLUE:
		  AND r2, r0, #0x4 ; check bit3
		  CMP r2, #0x4
		  BNE AFTER_GREEN
		  LDR r3, [r1]
		  ORR r3, #0x8 ; set pin1 to 1
		  STR r3, [r1]
		  ; set gpio output for green
AFTER_GREEN:
	LDMFD sp!, {lr, r0-r3}
	MOV pc, lr

init_gpio:
	STMFD sp!, {lr, r0-r1}

		MOV r0,#0xE000
		MOVT r0,#0x400F

		LDR r1, [r0, #0x608]
		ORR r1, r1, #0x20	; enable clock for gpio port F
		STRB r1, [r0, #0x608]

		MOV r0, #0x5000	; move r1 to GPIO port F base address
		MOVT r0, #0x4002

		LDR r1, [r0, #0x400]
		ORR r1, r1, #0xE	; 1110 for pin directions
		STR r1, [r0, #0x400] ; set direction for each pin

		LDR r1, [r0, #0x51C]
		ORR r1, r1, #0xFF	 ; digital io pin enable
		STR r1, [r0, #0x51C] ; configure pins for digital io

		LDR r1, [r0, #0x510]
		ORR r1, r1, #0x10	; enable pull-up resistor for pin4 (sw1)
		STR r1, [r0, #0x510] ; configure pins for digital io

	LDMFD sp!, {lr, r0-r1}
	MOV pc, lr


	.end
