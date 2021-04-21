   ;Intro Screen
name:   .string "Welcome to Free Flow!!",0
play:   .string "To start the game press enter",0
clear:  .string 27,"[2J",0
center: .string 27,"[12;35H",0
next:   .string 27,"[13;30H",0


ptr_to_name: .word name
ptr_to_play: .word play
ptr_to_clear: .word clear
ptr_to_center: .word center
ptr_to_next: .word next


	;Intro

	ldr r0,ptr_to_clear
    BL output_string

	ldr r0,ptr_to_center
    BL output_string

    ldr r0,ptr_to_name
    BL output_string

    ldr r0,ptr_to_next
    BL output_string

    ldr r0,ptr_to_play
    BL output_string

    MOV r4, #0xC000
	MOVT r4, #0x4000

intro_loop:

    LDR r6, [r4]
    cmp r6,#0xD
    BNE intro_loop