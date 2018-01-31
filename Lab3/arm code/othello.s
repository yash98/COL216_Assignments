    .equ SWI_Exit, 0x11
    .equ SWI_Blue, 0x203
    .equ SWI_Black, 0x202
    .equ SWI_DispChar, 0x207
    .equ SWI_DispStr, 0x204

    mov r3, #'W
main:
    @ provide to callee
    @ r3 char
    @ r1 x
    @ r2 y
    cmp r3, #'W
    moveq r3, #'B
    movne r3, #'W

stale_check:
    bl possible_places_wrapper
    ldr r10, =Skip
    ldr r0, r10
    cmp r0, r11
    blne stale_mate
    mvn r0, r11
    str r0, =Skip
    cmp r11, #0
    b main
    mov r11, #0

chance:



    mov r0,#38
    mov r1,#14
    mov r2, r3
    swi SWI_PrintChar
    mov r0,#39
    mov r1,#14
    mov r2, #'X
    swi SWI_PrintChar
    bl input_keyboard
    mov r1, r0
    mov r0, #39
    mov r1, #14
    mov r2, #'Y
    swi SWI_PrintChar
    bl input_keyboard
    mov r2, r0


    
stale_mate:
    mov r0, #0
    mov r1, #14
    ldr r2, =Stale
    swi SWI_DispStr
    b input_keyboard
    swi SWI_Exit
    

preset:
    mov r0, #0
    mov r4, #0
    
    b reset
    ldr r2, =Board

reset:
    cmp r0, #63
    moveq r0, #0
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
    cmp r0, #0x0
    b input_keyboard

    mov pc, lr

move:





possible_places_wrapper:
    stmfd sp!, {lr, r4, r5}
    bl possible_places
    ldmfd sp!, {lr, r4, r5}

    mov pc, lr

possible_places:
    @ places p at possible places
    @ returns
    @ r0 = 1 if moves possible
    cmp r1, #8
    moveq pc, lr
    cmp r2, #8
    moveq r2, #0
    addeq r1, r1, #1

    ldr r6, =Board
    bl toOneD

    add r6, r6, r0, lsr #2
    ldr r0, [r6]
    cmp r0, r3
    
    bleq combination_around_wrapper

    add r2, r2, #1

    b possible_places


combination_around_wrapper:
    stmfd sp!, {lr}
    ldr r7, =Movement
    add r9, r7, #64
    bl combination_around
    ldmfd sp!, {lr}

    mov pc, lr


combination_around:
    cmp r8, r9
    moveq pc, lr
    ldr r6, =Board
    moveq r4, r1
    moveq r5, r2
    ldr r8, [r7], #4
    add r4, r4, r8
    ldr r8, [r7], #4
    add r5, r5, r8

    stmfd sp!, {lr, r1, r2}
    mov r1, r4
    mov r2, r5
    bl toOneD
    ldmfd sp!, {lr, r1, r2}

    add r6, r6, r0
    ldr r0, [r6]

    cmp r0, #'O
    stmfd sp!, {lr, r1, r2}
    mov r1, r4
    mov r2, r5
    bleq check_legal_wrapper
    ldmfd sp!, {lr, r1, r2}

    b combination_around

check_legal_wrapper:
    stmfd sp!, {lr, r1, r2, r4, r5, r6, r7, r8, r9}
    ldr r8, =Movement
    mov r6, r8
    add r7, r8, #8
    add r9, r7, #64

clw_for:
    add r4, r4, r6
    add r5, r5, r7
    
    mov r0, #0
    cmp r4, #0
    orrlt r0, r0, #1
    cmp r5, #7
    orrgt r0, r0, #1
    cmp r5, #0
    orrlt r0, r0, #1
    cmp r5, #7
    orrgt r0, r0, #1
    cmp r0, #1
    beq clw_for_cond

    stmfd sp!, {lr, r1, r2}
    mov r1, r4
    mov r2, r5
    bl toOneD
    ldmfd sp!, {lr, r1, r2}

    ldr r10, =Board
    add r10, r10, r0
    ldr r0, [r10]

    cmp r3, #'W
    cmpeq r0, #'B
    bleq check_same
    cmp r3, #'B
    cmpeq r0, #'W
    bleq check_same

clw_for_cond:
    mov r4, r1
    mov r5, r2
    cmp r7, r9
    blt clw_for


    ldmfd sp!, {lr, r1, r2, r4, r5, r6, r7, r8, r9}
    mov pc, lr

check_same:
    add r4, r4, r6
    add r5, r5, r7

    mov r0, #0
    cmp r4, #0
    orrlt r0, r0, #1
    cmp r5, #7
    orrgt r0, r0, #1
    cmp r5, #0
    orrlt r0, r0, #1
    cmp r5, #7
    orrgt r0, r0, #1
    cmp r0, #1
    moveq pc, lr

    stmfd sp!, {lr, r1, r2}
    mov r1, r4
    mov r2, r5
    bl toOneD
    ldmfd sp!, {lr, r1, r2}

    ldr r10, =Board
    add r10, r10, r0
    ldr r0, [r10]


    cmp r3, #'W
    cmpeq r0, #'B
    beq check_same
    cmp r3, #'B
    cmpeq r0, #'W
    beq check_same

    cmp r0, r3
    movne r0, #0
    movne pc, lr
    
set_p:
    stmfd sp!, {lr, r1, r2}
    mov r1, r4
    mov r2, r5
    bl toOneD
    ldmfd sp!, {lr, r1, r2}

    ldr r10, =Board
    add r10, r10, r0
    mov r0, #'P
    str r0, [r10]
    mov r11, #1

    mov pc, lr

clear_p_wrapper:
    stmfd sp!, {lr, r0, r9, r10}
    mov r0, #0
    ldr r10, =Board
    bl clear_p
    stmfd sp!, {lr, r0, r9, r10}
    mov pc, lr

clear_p:
    cmp r0, #63
    moveq pc, lr
    ldr r9, [r10, r0]
    cmp r9, #'P
    moveq r9, #'O
    str r9, [r10, r0]

toOneD:
    stmfd sp!, {lr, r4}
    mov r4, #8
    mul r0, r2, r4
    add r0, r0, r1 
    ldmfd sp!, {lr, r4}

    mov pc, lr

    .data
    Board: .space 256
    Movement: .word 1,0, 1,1, 0,1, -1,1, -1,0, -1,-1, 0,-1, 1,-1
    wscore: .word 2
    bscore: .word 2
    Skip: .word 0
    Stale: .asciz "Game Stale or finished\n"