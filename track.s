	.data
;512 byte allocation for current game board
board: .space 512
; there should be an allocation for game data (state, time, levels completed)

; ANSI Escape Sequence strings for cursor control and board printing
LINE1:		.string 27,"[1;0H",0
LINE2:		.string 27,"[2;0H",0
CUR: 		.string 27,"[3;0H",0
CUR_SAV: 	.string 27,"[s",0
CUR_RES: 	.string 27,"[u",0
CUR_U:		.string 27,"[1A",0
CUR_D:		.string 27,"[1B",0
CUR_R:		.string 27,"[1C",0
CUR_L:		.string 27,"[1D",0
CLEAR:		.string 27,"[2J",0
X_LINE:		.string 27,"[s",27,"[37mXXXXXXXXX",27,"[u",27,"[1B",0
; start board sequence		.string 27,"[s",27,"[37mX",
; next line sequence 		27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",
; end board sequence		27,"[37mX",27,"[u",27,"[1B",0
; colored circle sequence 	27,"[31mO",
BOARD1: 	.string 27,"[s",27,"[37mX",27,"[32mO","    ",27,"[31mO",27,"[34mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[33mO",27,"[32mO"," ",27,"[33mO","  ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX"," ",27,"[31mO","    ",27,"[34mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","      ",27,"[36mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[36mO","     ",27,"[35mO",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX","       ",27,"[37mX",27,"[u",27,"[1B",27,"[s",27,"[37mX",27,"[37mO","  ",27,"[37mO",27,"[35mO","  ",27,"[37mX",27,"[u",27,"[1B",0
Board_simple_1:	.string "smrsssssswbsbsssgsssssscysgsssssycssswssssssmrsss"
; strings for other data/prompts
TIME:			.string "Time: 0000",0xA,0xD,0
CONNECTIONS: 	.string "Completed: 0/7",0xA,0xD,0
PAUSE:			.string "Game Paused",0xA,0xD,0
RESTART_NEW:	.string "(1) Restart New Board",0xA,0xD,0
RESTART_CUR:	.string "(2) Restart Current Board",0xA,0xD,0
RESUME:			.string "(SW1) Resume Current Board",0xA,0xD,0


	.text
; Library Subroutines
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

ptr_to_board: 	.word board
ptr_to_LINE1:	.word LINE1
ptr_to_LINE2:	.word LINE2
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
ptr_to_TIME:	.word TIME
ptr_to_CONNECTIONS: .word CONNECTIONS
ptr_to_PAUSE:	.word PAUSE
ptr_to_RESTART_NEW: .word RESTART_NEW
ptr_to_RESTART_CUR:	.word RESTART_CUR
ptr_to_RESUME:	.word RESUME
ptr_to_board_simple:	.word Board_simple_1


lab6:
	STMFD SP!,{r0-r12,lr}
	; initializations
 	BL uart_init
 	BL gpio_init
	BL interrupt_init
	BL timer_init

	; check resume flag
	; if restart current flag 1 then load current_board otherwise load new board
	; also set resstart current flag to 0


	; print time and connections headers
	LDR r0, ptr_to_CONNECTIONS
	BL output_string
	LDR r0, ptr_to_TIME
	BL output_string
	; print game board
	LDR r0, ptr_to_CUR		; initialize cursor
	BL output_string
	LDR r0, ptr_to_X_LINE	; top X line
	BL output_string
	LDR r0, ptr_to_BOARD1	; board
	BL output_string
	LDR r0, ptr_to_X_LINE	; bottom X line
	BL output_string

	; testing Count_Spaces
	LDR r0, ptr_to_BOARD1
	BL Count_Spaces
	MOV r0, #0

loop:
	;LDR r0, ptr_to_LINE2
	;BL output_string
	;LDR r0, ptr_to_TIME
	;BL output_string
	mov r0, #1
	CMP r0, #0
	BNE loop


    



	LDMFD sp!, {r0-r12,lr}
 	MOV pc, lr
