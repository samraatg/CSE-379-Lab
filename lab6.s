	.data

; game data allocations
board: .space 512	; 512 byte allocation for current game board
time:		.int 0	; time playing level value
paused:		.int 0	; flag for paused game state
board_num:	.int 0	; int corresponding to current board number
; ANSI Escape Sequence strings for cursor control and board printing
LINE1:		.string 27,"[1;0H",0
LINE2:		.string 27,"[2;0H",0
LINE3:		.string 27,"[3;0H",0
CUR: 		.string 27,"[7;5H",0
CUR_SAV: 	.string 27,"[s",0
CUR_RES: 	.string 27,"[u",0
CUR_U:		.string 27,"[1A",0
CUR_D:		.string 27,"[1B",0
CUR_R:		.string 27,"[1C",0
CUR_L:		.string 27,"[1D",0
CLEAR:		.string 27,"[2J",0
X_LINE:		.string 27,"[s",27,"[37mXXXXXXXXX",27,"[u",27,"[1B",0
; start of board sequence	.string 27,"[s",27,"[37mX",
; next line sequence 		27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",
; end of board sequence		27,"[37mX",27,"[u",27,"[1B",0
; colored circle sequence 	27,"[31mO",
BOARD1: 	.string 27,"[s",27,"[37mX",27,"[32mO","    ",27,"[31mO",27,"[34mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[33mO",27,"[32mO"," ",27,"[33mO","  ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[31mO","    ",27,"[34mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","      ",27,"[36mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[36mO","     ",27,"[35mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[37mO","  ",27,"[37mO",27,"[35mO","  ",27,"[37mX",27,"[u",27,"[1B",0
BOARD2: 	.string 27,"[s",27,"[37mX",27,"[36mO",27,"[37mO","    ",27,"[37mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","      ",27,"[31mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[36mO"," ",27,"[33mO","   ",27,"[34mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","    ",27,"[34mO","  ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[32mO"," ",27,"[32mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[33mO","   ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[31mO",27,"[35mO"," ",27,"[35mO",27,"[37mX",27,"[u",27,"[1B",0
BOARD3:		.string 27,"[s",27,"[37mX",27,"[36mO"," ",27,"[32mO",27,"[33mO",27,"[37mO","  ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","     ",27,"[31mO",27,"[37mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[36mO","     ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","     ",27,"[34mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[33mO","   ",27,"[35mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[34mO","   ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[32mO","  ",27,"[35mO","  ",27,"[31mO",27,"[37mX",27,"[u",27,"[1B",0
BOARD4: 	.string 27,"[s",27,"[37mX","      ",27,"[32mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","     ",27,"[31mO",27,"[32mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[31mO",27,"[35mO"," ",27,"[33mO",27,"[34mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[36mO",27,"[35mO",27,"[33mO",27,"[37mO","  ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[37mO","    ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[36mO",27,"[34mO","    ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",0
BOARD5:		.string 27,"[s",27,"[37mX","      ",27,"[34mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[33mO",27,"[33mO",27,"[32mO","  ",27,"[36mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","     ",27,"[37mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[34mO","    ",27,"[37mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[32mO","      ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[31mO","     ",27,"[36mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[35mO"," ",27,"[35mO","   ",27,"[31mO",27,"[37mX",27,"[u",27,"[1B",0
BOARD6:		.string 27,"[s",27,"[37mX",27,"[32mO",27,"[33mO",27,"[37mO",27,"[36mO","  ",27,"[35mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[33mO","     ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[32mO",27,"[37mO","    ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[31mO","      ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[34mO",27,"[34mO",27,"[31mO",27,"[36mO",27,"[35mO","  ",27,"[37mX",27,"[u",27,"[1B",0
BOARD7:		.string 27,"[s",27,"[37mX","  ",27,"[33mO",27,"[33mO",27,"[37mO","  ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","     ",27,"[34mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[36mO"," ",27,"[37mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[32mO","    ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[32mO",27,"[31mO","   ",27,"[35mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[31mO"," ",27,"[34mO","   ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[36mO",27,"[35mO","     ",27,"[37mX",27,"[u",27,"[1B",0
BOARD8:		.string 27,"[s",27,"[37mX",27,"[33mO","      ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[32mO"," ",27,"[31mO",27,"[32mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[33mO"," ",27,"[31mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[36mO","   ",27,"[34mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[37mO","  ",27,"[35mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[36mO",27,"[37mO",27,"[35mO"," ",27,"[34mO","  ",27,"[37mX",27,"[u",27,"[1B",0
BOARD9:		.string 27,"[s",27,"[37mX",27,"[35mO","     ",27,"[36mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[33mO"," ",27,"[33mO",27,"[35mO",27,"[36mO",27,"[31mO",27,"[31mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[34mO","     ",27,"[34mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","    ",27,"[37mO",27,"[32mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[32mO","    ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[37mO","      ",27,"[37mX",27,"[u",27,"[1B",0
BOARD10:	.string 27,"[s",27,"[37mX",27,"[31mO",27,"[31mO",27,"[36mO",27,"[32mO",27,"[37mO"," ",27,"[33mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[32mO",27,"[36mO","  ",27,"[35mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","      ",27,"[33mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[34mO","     ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[37mO",27,"[34mO",27,"[35mO"," ",27,"[37mX",27,"[u",27,"[1B",0
BOARD11:	.string 27,"[s",27,"[37mX",27,"[33mO","      ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[33mO","      ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[37mO",27,"[36mO",27,"[36mO",27,"[31mO",27,"[32mO","  ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[37mO",27,"[31mO","     ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[32mO","      ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[34mO",27,"[35mO",27,"[35mO","  ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","    ",27,"[34mO","  ",27,"[37mX",27,"[u",27,"[1B",0
BOARD12:	.string 27,"[s",27,"[37mX","  ",27,"[33mO",27,"[32mO","  ",27,"[34mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[36mO","    ",27,"[37mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[33mO","  ",27,"[34mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[36mO","      ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[32mO","    ",27,"[37mO",27,"[31mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[31mO",27,"[35mO","    ",27,"[35mO",27,"[37mX",27,"[u",27,"[1B",0
BOARD13:	.string 27,"[s",27,"[37mX","  ",27,"[33mO",27,"[32mO",27,"[36mO","  ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","     ",27,"[35mO",27,"[36mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","     ",27,"[35mO",27,"[31mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","    ",27,"[32mO","  ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[34mO","  ",27,"[33mO"," ",27,"[37mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[31mO","     ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[34mO",27,"[37mO","  ",27,"[37mX",27,"[u",27,"[1B",0
BOARD14:	.string 27,"[s",27,"[37mX","  ",27,"[31mO",27,"[32mO","  ",27,"[32mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","      ",27,"[31mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[34mO","     ",27,"[34mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[37mO",27,"[36mO",27,"[35mO","  ",27,"[33mO",27,"[33mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[36mO","   ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[37mO",27,"[35mO","  ",27,"[37mX",27,"[u",27,"[1B",0
BOARD15:	.string 27,"[s",27,"[37mX"," ",27,"[32mO",27,"[36mO",27,"[32mO","   ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[35mO"," ",27,"[31mO","   ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[34mO"," ",27,"[31mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[37mO",27,"[34mO",27,"[33mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[35mO",27,"[36mO",27,"[37mO"," ",27,"[33mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",0
BOARD16:	.string 27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","     ",27,"[31mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[32mO",27,"[32mO",27,"[36mO",27,"[31mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[37mO",27,"[33mO"," ",27,"[34mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","  ",27,"[37mO",27,"[33mO",27,"[34mO",27,"[35mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","     ",27,"[35mO"," ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","   ",27,"[36mO","   ",27,"[37mX",27,"[u",27,"[1B",0
; strings for other data/prompts
TIME_HEADER:	.string "Time: 0   ",0
CONN_HEADER: 	.string "Completed: 0/7",0
PAUSE:			.string "Game Paused",0xA,0xD,0
RESTART_NEW:	.string "(1) Restart New Board",0xA,0xD,0
RESTART_CUR:	.string "(2) Restart Current Board",0xA,0xD,0
RESUME:			.string "(SW1) Resume Current Board",0xA,0xD,0


	.text

; library subroutines
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler
	.global lab6
	.global uart_init
	.global gpio_init
	.global interrupt_init
	.global timer_init
	.global illuminate_RGB_LED
	.global output_character
	.global output_string
	.global int2str
	.global str2int
	.global num_digits
; game data pointers
ptr_to_board: 	.word board
ptr_to_time: 	.word time
ptr_to_paused:	.word paused
ptr_to_board_num:	.word board_num
; string pointers
ptr_to_LINE1:	.word LINE1
ptr_to_LINE2:	.word LINE2
ptr_to_LINE3:	.word LINE3
ptr_to_CUR: 	.word CUR
ptr_to_CUR_SAV: .word CUR_SAV
ptr_to_CUR_RES: .word CUR_RES
ptr_to_CUR_U: 	.word CUR_U
ptr_to_CUR_D: 	.word CUR_D
ptr_to_CUR_R: 	.word CUR_R
ptr_to_CUR_L: 	.word CUR_L
ptr_to_X_LINE: 	.word X_LINE
ptr_to_CLEAR: 	.word CLEAR
ptr_to_BOARD1: 	.word BOARD1
ptr_to_BOARD2: 	.word BOARD2
ptr_to_BOARD3: 	.word BOARD3
ptr_to_BOARD4: 	.word BOARD4
ptr_to_BOARD5: 	.word BOARD5
ptr_to_BOARD6: 	.word BOARD6
ptr_to_BOARD7: 	.word BOARD7
ptr_to_BOARD8: 	.word BOARD8
ptr_to_BOARD9: 	.word BOARD9
ptr_to_BOARD10:	.word BOARD10
ptr_to_BOARD11: .word BOARD11
ptr_to_BOARD12: .word BOARD12
ptr_to_BOARD13: .word BOARD13
ptr_to_BOARD14: .word BOARD14
ptr_to_BOARD15: .word BOARD15
ptr_to_BOARD16: .word BOARD16
ptr_to_TIME_HEADER:	.word TIME_HEADER
ptr_to_CONN_HEADER: .word CONN_HEADER
ptr_to_PAUSE:	.word PAUSE
ptr_to_RESTART_NEW: .word RESTART_NEW
ptr_to_RESTART_CUR:	.word RESTART_CUR
ptr_to_RESUME:	.word RESUME


; main routine
lab6:
	STMFD SP!,{r0-r12,lr}
	; initializations
 	BL uart_init
 	BL gpio_init
	BL interrupt_init
	BL timer_init

	; clear screen in case of leftover junk
	LDR r0, ptr_to_CLEAR
	BL output_string

	; print headers
	LDR r0, ptr_to_TIME_HEADER
	BL output_string
	LDR r0, ptr_to_LINE2
	BL output_string
	LDR r0, ptr_to_CONN_HEADER
	BL output_string

	; use random number generator to pick board
	; a%b = a - (b*(a/b))
 	MOV r5,#16
	MOV r4, #0x0050
	MOVT r4, #0x4003
    LDR r4, [r4]
    UDIV r6,r4,r5
    MUL r6,r5,r6
    SUB r5,r4,r6			; r5 = board number
	LDR r4, ptr_to_board_num
	STR r5, [r4]			; store board number

	; initialize current board
	LDR r0, ptr_to_board
	LDR r4, [r4]
	CMP r4, #0
	IT EQ
	LDREQ r1, ptr_to_BOARD1
	CMP r4, #1				; load board into r1 based on board_num
	IT EQ
	LDREQ r1, ptr_to_BOARD2
	CMP r4, #2
	IT EQ
	LDREQ r1, ptr_to_BOARD3
	CMP r4, #3
	IT EQ
	LDREQ r1, ptr_to_BOARD4
	CMP r4, #4
	IT EQ
	LDREQ r1, ptr_to_BOARD5
	CMP r4, #5
	IT EQ
	LDREQ r1, ptr_to_BOARD6
	CMP r4, #6
	IT EQ
	LDREQ r1, ptr_to_BOARD7
	CMP r4, #7
	IT EQ
	LDREQ r1, ptr_to_BOARD8
	CMP r4, #8
	IT EQ
	LDREQ r1, ptr_to_BOARD9
	CMP r4, #9
	IT EQ
	LDREQ r1, ptr_to_BOARD10
	CMP r4, #10
	IT EQ
	LDREQ r1, ptr_to_BOARD11
	CMP r4, #11
	IT EQ
	LDREQ r1, ptr_to_BOARD12
	CMP r4, #12
	IT EQ
	LDREQ r1, ptr_to_BOARD13
	CMP r4, #13
	IT EQ
	LDREQ r1, ptr_to_BOARD14
	CMP r4, #14
	IT EQ
	LDREQ r1, ptr_to_BOARD15
	CMP r4, #15
	IT EQ
	LDREQ r1, ptr_to_BOARD16
	BL strcpy		; copy starter board into current board

	; print game board
	LDR r0, ptr_to_LINE3	; start of board location
	BL output_string
	LDR r0, ptr_to_X_LINE	; top X line
	BL output_string
	LDR r0, ptr_to_board	; board
	BL output_string
	LDR r0, ptr_to_X_LINE	; bottom X line
	BL output_string
	LDR r0, ptr_to_CUR		; move cursor to board center
	BL output_string


loop:
	mov r0, #1
	CMP r0, #0
	BNE loop

	LDMFD sp!, {r0-r12,lr}
 	MOV pc, lr

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
	LDMFD sp!, {r0-r12,lr}
	BX lr

Switch_Handler:
	STMFD SP!,{r0-r12,lr}
	; clear SW1 interrupt
	MOV r4, #0x5000
	MOVT r4, #0x4002 ; base address of GPIOF
	LDR r5, [r4, #0x41C] ; load GPIOICR
	ORR r5, r5, #0x10 ; set bit 4 (SW1) to clear
	STR r5, [r4, #0x41C]
	; handler body
	LDR r4, ptr_to_paused		; load paused flag
	LDR r5, [r4]
	CMP r5, #0					; skip pause behavior if already paused
	BNE SW_UNPAUSE
	; pause game, hide board, print pause option prompts
	LDR r0, ptr_to_CLEAR		; clear screen
	BL output_string
	LDR r0, ptr_to_LINE1		; move cursor to line1
	BL output_string
	LDR r0, ptr_to_PAUSE		; print paused prompt
	BL output_string
	LDR r0, ptr_to_RESTART_NEW	; print restart and resume prompts
	BL output_string
	LDR r0, ptr_to_RESTART_CUR
	BL output_string
	LDR r0, ptr_to_RESUME
	BL output_string
SW_UNPAUSE:
	CMP r5, #1				; if game was resumed, exit
	BNE SW_EXIT
	; reprint game screen
	LDR r0, ptr_to_CLEAR		; clear screen
	BL output_string
	LDR r0, ptr_to_TIME_HEADER	; print headers
	BL output_string
	LDR r0, ptr_to_LINE2
	BL output_string
	LDR r0, ptr_to_CONN_HEADER
	BL output_string
	LDR r0, ptr_to_LINE3		; print game board
	BL output_string
	LDR r0, ptr_to_X_LINE
	BL output_string
	LDR r0, ptr_to_board
	BL output_string
	LDR r0, ptr_to_X_LINE
	BL output_string
	LDR r0, ptr_to_CUR		; move cursor to board center
	BL output_string
SW_EXIT:
	EOR r5, #1					; swap flag between 0 and 1
	STR r5, [r4]
	LDMFD sp!, {r0-r12,lr}
	BX lr

Timer_Handler:
	STMFD SP!,{r0-r12,lr}
	; clear timer interrupt
	MOV r4, #0x0000
 	MOVT r4, #0x4003 ; T0 base address
 	LDR r5, [r4, #0x024] ; GPTMICR offset
 	ORR r5, r5, #0x1 ; set bit0 to 1 (TATOCINT)
 	STR r5, [r4, #0x024]
 	; check if game is paused
 	LDR r6, ptr_to_paused
 	LDR r6, [r6]
 	CMP r6, #0		; exit handler if game is paused
 	BNE TH_EXIT
	; increase time
	LDR r5, ptr_to_time
	LDR r4, [r5]
	ADD r4, r4, #1
	MOV r0, r4
	STR r4, [r5]
	; update time in header
	BL num_digits
	MOV r2, r0
	MOV r0, r4
	LDR r1, ptr_to_TIME_HEADER
	ADD r1, r1, #6
	BL int2str
	; reprint time header
	LDR r0, ptr_to_CUR_SAV		; save cursor
	BL output_string
	LDR r0, ptr_to_LINE1		; move to time header line
	BL output_string
	LDR r0, ptr_to_TIME_HEADER	; print time header
	BL output_string
	LDR r0, ptr_to_CUR_RES		; restore cursor
	BL output_string
TH_EXIT:
	LDMFD sp!, {r0-r12,lr}
	BX lr

; routine to count remaining spaces in a game board
; input: string (r0)
; output: number of space characters in string (r0)
Count_Spaces:
	STMFD sp!,{lr, r4-r11}
	MOV r5, #0
CS_LOOP:
	LDRB r4, [r0], #1	; load string into r4 and increment
	CMP r4, #0x0 		; check for end of string
	BEQ CS_EXIT			; exit if char = NULL
	CMP r4, #0x20		; check for space
	IT EQ
	ADDEQ r5, r5, #1	; add 1 to space count
	B CS_LOOP
CS_EXIT:
	MOV r0, r5
 	LDMFD sp!, {lr, r4-r11}
	mov pc, lr

; copy string (base address r1) to new destination (base address r0)
strcpy:
	STMFD sp!,{lr, r4-r11}
SC_LOOP:
	LDRB r4, [r1], #1	; load char from string
	CMP r4, #0x0			; exit if char = NULL
	BEQ SC_EXIT
	STRB r4, [r0], #1	; copy char to destination
	B SC_LOOP
SC_EXIT:
	LDMFD sp!, {lr, r4-r11}
	mov pc, lr
.end
