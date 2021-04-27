; need three modes
; mode 1: Pause Menu message- no movement using wasd keys
; mode 2: pause menu selection
; mode 3: edit mode
; mode 4: edit mode
; In the pause menu  r: SW1  ,  n:new game ,  e: restart 
mode: 		.string "1",0
current_board:  .string "1",0
restart_flag: .string "0",0 
;one_string: .string "1"
; two_string: .string "2"
; three_string: .string "3"
Pause:  .string "Welcome to the Pause Screen!",0
Message:    .string "To resume press 'SW1'     To start a new board press 'n'       To restart same board press 'r'",0
CUR_SAV: 	.string 27,"[s",0
CUR_RES: 	.string 27,"[u",0
Clear_screen: 	.string 27,"[2J",0
center: .string 27,"[12;35H",0
next:   .string 27,"[13;30H",0



ptr_to_mode: .word mode
ptr_to_pause: 	.word Pause
ptr_to_Message: .word Message 
ptr_to_CUR_SAV: .word CUR_SAV
ptr_to_CUR_RES: .word CUR_RES
ptr_to_clear: 	.word Clear_screen
ptr_to_center: .word center
ptr_to_next: .word next
ptr_to_curent: .word current_board
ptr_to_restart_flag: .word restart_flag



UART0_Handler:
	STMFD SP!,{r0-r12,lr} ; Store register lr on stack
	; clear UART interrupt
	MOV r4, #0xC000
	MOVT r4, #0x4000 ; base address of UART0
	LDR r5, [r4, #0x44] ; load UARTICR
	ORR r5, r5, #0x10 ; set bit 4 (RXIM)
	STR r5, [r4, #0x44]

	; load uart data (char input)
	LDR r6, [r4]

    ldr r1, ptr_to_mode
    BL str2int
    mov r7,r0 ; r7 used to store mode value
    cmp r7,#1
    BEQ Menu 
    cmp r7,#2
    BEQ Selection 
    B Edit

Menu:

    cmp r6,#0x32 ; check for restart new 
    BNE Restart_current
    mov r0,ptr_to_clear
    BL output_string
    BL lab6 ;print new board
    B Exit_UART

Restart_current:

  ;  mov r0,#0x1    ; convert 1 to string 
  ;  BL num_digits
  ;  mov r2,r0
 ;   mov r0,#0x1
  ;  BL int2str

    mov r1,#0x31
    ldr r2,ptr_to_restart_flag  ; store 1 in restart_flag
    str r1,[r2]

    mov r0,ptr_to_clear  ; clear screen
    BL output_string
    
    BL lab6    ; print board
    B Exit_UART ; exit interrupt

Selection:
	; check for cursor movement with wasd
	CMP r6, #0x77 			; check if char is ASCII 'w'
	IT EQ					; if so, move cursor up
	LDREQ r0, ptr_to_CUR_U
	CMP r6, #0x73 			; check if char is ASCII 's'
	IT EQ					; if so, move cursor down
	LDREQ r0, ptr_to_CUR_D
	CMP r6, #0x61 			; check if char is ASCII 'a'
	IT EQ					; if so, move cursor left
	LDREQ r0, ptr_to_CUR_L
	CMP r6, #0x64 			; check if char is ASCII 'd'
	IT EQ					; if so, move cursor right
	LDREQ r0, ptr_to_CUR_R
	BL output_string

    CMP r6, #0x20  ;check for spacebar
    ; loop 


    B Exit_UART

Edit:


Exit_UART:
	LDMFD sp!, {r0-r12,lr}
	BX lr



BL num_dig