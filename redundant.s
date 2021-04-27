Menu: 
    ;Menu stuff
    ldr r0,ptr_to_CUR_SAV ;store current cursor position
    BL output_string

    ldr r0,ptr_to_clear   ;clear Screen
    BL output_string

    ldr r0,ptr_to_center    ;move cursor to center
    BL output_string

    ldr r0,ptr_to_pause     ; print pause screen message
    BL output_string
    
    ldr r0,ptr_to_next      ; move cursor to next line 
    BL output_string

    ldr r0,ptr_to_Message   ; print message
    BL output_string