    .equ SWI_Exit, 0x11
    .equ SWI_Blue, 0x203
    .equ SWI_Black 0x202


main:

    
    
    

preset:
    mov r0, #0
    mov r4, #0
    mov r5, #'W
    b reset
    ldr r2, =Board

reset:
    cmp r0, #63
    beq main
    mov r1, #'O
    str r1, [r2]
    cmp r0, #27
    moveq r1, #'W
    streq r1 , [r2]
    cmp r0, #28
    moveq r1, #'B
    streq r1, [r2]
    cmp r0, #36
    moveq r1, #'W
    streq r1 , [r2]
    cmp r0, #35
    moveq r1, #'B
    streq r1, [r2]
    add r0, r0, #1
    add r2, r2, #4


input_keyboard:
    swi SWI_Blue
    cmp r0, #0x0
    b input_keyboard
    cmp r0, #0x1
    moveq r0, #0
    cmp r0, #0x10
    moveq r0, #1
    cmp r0, #0x100
    moveq r0, #2
    cmp r0, #0x1000
    moveq r0, #3
    cmp r0, #0x10000
    moveq r0, #4
    cmp r0, #0x100000
    moveq r0, #5
    cmp r0, #0x1000000
    moveq r0, #6
    cmp r0, #0x10000000
    moveq r0, #7
    swi SWI_Black
    cmp r0, #1
    beq preset

    mov pc, lr

move:




    .data
    Board: .space 256
    Movement: .word 1,0, 1,1, 0,1, -1,1, -1,0, -1,-1, 0,-1, 1,-1