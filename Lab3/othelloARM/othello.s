    .equ SWI_Exit, 0x11
    .equ SWI_Blue, 0x203
    .equ SWI_Black, 0x202
    .equ SWI_DispChar, 0x207
    .equ SWI_DispStr, 0x204
    .equ SWI_ClearStr, 0x208
    .equ SWI_DispInt, 0x205
    .text

main:
    @ init
    bl clearScr
    bl othello

    mov r3, #'B
    mov r4, #1
    mov r5, #1
    mov r6, #4
    mov r8, #0
    mov r9, #2
    mov r9, #2

    @ game begin
main_while1:
    /* 
    r3 = chance 
    r4 = notStale
    r5 = prevNotStaRope U - nkit descision
le
    r6 = movesDone
    r7 = bool store for conditionals
    r8 = rightMove
    r9 = wScore
    r10 = bScore
     */

    @ while(movesDone<=64)
    cmp r6, #64
    bgt main_end

    @ normal board display
    bl display
    @ swap chances 
    cmp r3, #'W
    moveq r3, #'B
    movne r3, #'W

    @ update prevNotStale
    mov r5, r4

    bl obtainPlaces
    /* bool returned r0 */
    mov r4, r0

    @ check stale
    orr r7, r4, r5
    cmp r7, #0
    beq main_end

    cmp r4, #0
    bleq clearP
    @ returns none
    beq main_while1

    @ display board with Ps
    bl display
    @ till right move
main_while2:
    @ while(!rightMove)
    /*  */
    @ show score chance
    @ C
    mov r0, #'C
    mov r1, #35
    mov r2, #10
    swi SWI_DispChar
    @ Chance
    mov r0, r3
    mov r1, #36
    mov r2, #10
    swi SWI_DispChar
     @ W
    mov r0, #'W
    mov r1, #35
    mov r2, #11
    swi SWI_DispChar
    @ wScore
    mov r0, r9
    mov r1, #36
    mov r2, #11
    swi SWI_DispChar
    @ B
    mov r0, #'B
    mov r1, #35
    mov r2, #12
    swi SWI_DispChar
    @ bSocre
    mov r0, r10
    mov r1, #36
    mov r2, #12
    swi SWI_DispChar
    @ X
    mov r0, #'X
    mov r1, #36
    mov r2, #13
    swi SWI_DispChar

    bl input_keyboard
    mov r1, r0

    mov r0, r1
    mov r1, #36
    mov r2, #14
    swi SWI_DispChar

    @ Y
    mov r0, #'Y
    mov r1, #38
    mov r2, #13
    swi SWI_DispChar

    bl input_keyboard
    mov r2, r0

    mov r0, r2
    mov r1, #36
    mov r2, #14
    swi SWI_DispChar

    mov r0, r3
    bl moveIt
    @ return if input right r0
    mov r8, r0

    @ clear displaying inputs
    mov r0, #13
    swi SWI_ClearStr
    mov r0, #14
    swi SWI_ClearStr

    @ end while(!rightMove)
    cmp r8, #0
    @ !rightmove
    ldreq r2, =wrongPlace
    ldreq r2, [r2]
    moveq r0, #0
    moveq r1, #11
    swieq SWI_DispStr
    beq main_while2

    @ update score returned by moveIt 
    add r6, r6, #1
    cmp r3, #'W
    addeq r9, r9, r1
    subeq r10, r10, r2
    subne r9, r9, r1
    addne r10, r10, r2

    mov r8, #0
    b main_while1

main_end:
    /*  */
    ldreq r2, =gameEnd
    ldreq r2, [r2]
    moveq r0, #0
    moveq r1, #11
    swieq SWI_DispStr
    swi SWI_Exit

input_keyboard:
    /* 
    r4 = store input code
    r5 = number input
    r6 = 0x1 constant */
    stmfd sp!, {r4, r5, r6, r7}
    swi SWI_Black
    cmp r0, #1
    beq main
    mov r4, #0
    mov r5, #0
    mov r6, #0x1
    swi SWI_Blue

input_for1:
    mov r4, r6, lsl r5
    cmp r0, r4
    moveq r7, r5
    add r5, r5, #1
    cmp r5, #8
    blt input_for1

    cmp r0, #0x0
    beq input_keyboard
    @ if r0 != 0
    mov r0, r7
    ldmfd sp!, {r4, r5, r6, r7}
    mov pc, lr

othello:
    @ board constructor
    ldr r2, =board
    mov r0, #0
    mov r4, #0

othello_board_while1:
    cmp r0, #63
    moveq pc, lr
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
    b othello_board_while1

obtainPlaces:
    /*
    r3 = x
    r4 = y
    r5 = anyPlace
    r6 = chance
    r7 = board
    r8 = m
    r9 = tx
    r10 = ty
    r11 = movement */
    stmfd sp!, {lr, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12}
    mov r5, #0
    mov r6, r0
    ldr r7, =board
    ldr r11, =movement

    mov r3, #0
obtainPlaces_for1:

    mov r4, #0
obtainPlaces_for2:
    mov r0, r4
    mov r1, r5
    stmfd sp!, {lr}
    bl to1D
    ldmfd sp!, {lr}
    @ board[oneD] == 'W' || board[oneD] == 'B'
    mov r8, #0
    cmp r0, #'W
    beq obtainPlaces_for3 
    cmp r0, #'B
    beq obtainPlaces_for3

obtainPlaces_for3:
    ldr r9, [r11, r8]
    add r9, r9, r3
    add r8, r8, #1

    ldr r10, [r11, r8]
    add r10, r10, r4
    add r8, r8, #1

    @ char at tx, ty
    mov r0, r9
    mov r1, r10
    stmfd sp!, {lr}
    bl to1D
    ldmfd sp!, {lr}

    @ cond to send to checkPlace
    ldr r0, [r0, r7]
    cmp r0, #'O
    moveq r0, r6
    moveq r1, r9
    moveq r2, r10
    beq checkPlace

    orr r5, r5, r0

    @ for 3 end
    cmp r8, #16
    blt obtainPlaces_for3 

    @ for 2 end
    add r4, r4, #1
    cmp r4, #8
    blt obtainPlaces_for2

    @ for 1 end
    add r3, r3, #1
    cmp r3, #8
    blt obtainPlaces_for1

    mov r0, r5
    ldmfd sp!, {lr, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12}
    mov pc, lr

checkPlace:
    /*
    r2 = opposite
    r3 = mx
    r4 = my
    r5 = tx
    r6 = ty
    r7 = chance
    r8 = x
    r9 = y
    r10 = m
    r11 = board
    r12 = movement */
    stmfd sp!, {lr, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12}
    mov r8, r1
    mov r9, r2
    mov r7, r0
    ldr r11, =board
    ldr r12, =movement

    cmp r7, #'W
    moveq r2, #'B
    movne r2, #'W

    mov r10, #0
checkPlace_for1:
    @ load tx, ty
    ldr r3, [r12, r10]
    add r5, r8, r3
    add r10, r10, #1

    ldr r4, [r12, r10]
    add r6, r9, r4
    add r10, r10, #1

    @ oneD = to1D(tx, ty)
    stmfd sp!, {lr, r1}
    mov r0, r5
    mov r1, r6
    bl to1D
    ldmfd sp!, {lr, r1}

    ldr r0, [r11, r0]
    cmp r0, r1
    bne checkPlace_while_end

checkPlace_while:
    @ cond while 0<=tx && tx<=7 && 0<=ty && ty<=7
    cmp r5, #0
    blt checkPlace_while_end
    cmp r5, #7
    bge checkPlace_while_end
    cmp r6, #0
    blt checkPlace_while_end
    cmp r6, #7
    bge checkPlace_while_end

    @ oneD = to1D(tx, ty)
    stmfd sp!, {lr}
    mov r0, r5
    mov r1, r6
    bl to1D
    ldmfd sp!, {lr}

    @ this.board[oneD] == '0' || this.board[oneD] == 'P'
    ldr r0, [r11, r0]
    cmp r0, #'O
    beq checkPlace_while_end
    cmp r0, #'P
    beq checkPlace_while_end

    cmp r0, r7
    beq checkPlace_itsPossible

    add r5, r5, r8
    add r6, r6, r9
    b checkPlace_while


checkPlace_itsPossible:
    @ toOneD(x, y)
    stmfd sp!, {lr}
    mov r0, r8
    mov r1, r9
    bl to1D
    ldmfd sp!, {lr}

    add r0, r0, r11
    mov r1, #'P
    str r1, [r0]
    mov r0, #1
    ldmfd sp!, {lr, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12}
    mov pc, lr

checkPlace_while_end:
    cmp r8, #16
    blt checkPlace_for1

    mov r0, #0
    ldmfd sp!, {lr, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12}
    mov pc, lr

to1D:
    add r0, r0, r1, lsl #3
    mov pc, lr

moveIt:
    /* 
    r0 = chance
    r1 = x
    r2 = y
    r3 = mx
    r4 = my
    r5 = tx
    r6 = ty
    r7 = m
    r8 = wScore
    r9 = bScore
    r10 = movement
    r11 = board
    r12 = OneD store */
    stmfd sp!, {lr, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12}
    
    mov r9, #0
    mov r10, #0

    stmfd sp!, {lr, r0, r1, r2}
    @ toOneD(x, y)
    mov r0, r1
    mov r1, r2
    bl to1D
    ldr r0, [r0, r11]
    @ if board[x, y] = 'P' 
    cmp r0, #'P
    ldmfd sp!, {lr, r0, r1, r2}
    beq moveIt_OnP
    
    @ else return false
    stmfd sp!, {lr, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12}
    mov r0, #0
    mov r1, r8
    mov r2, r9
    mov pc, lr

moveIt_OnP:
    bl clearP
    stmfd sp!, {lr, r0, r1, r2}
    @ toOneD(x, y)
    mov r0, r1
    mov r1, r2
    bl to1D
    add r12, r0, r11
    ldmfd sp!, {lr, r0, r1, r2}
    str r0, [r12]

    @ 1 score inc
    cmp r0, #'W
    addeq r8, r8, #1
    addne r9, r9, #1

    mov r7, #0
move_It_OnP_for:
    @ load mx tx my ty
    ldr r3, [r10, r7]
    add r5, r3, r1
    add r7, r7, #1

    ldr r4, [r10, r7]
    add r6, r4, r2
    add r7, r7, #1

move_It_OnP_while1:
    @ cond while 0<=tx && tx<=7 && 0<=ty && ty<=7
    cmp r5, #0
    blt move_It_OnP_while1_end
    cmp r5, #7
    bge move_It_OnP_while1_end
    cmp r6, #0
    blt move_It_OnP_while1_end
    cmp r6, #7
    bge move_It_OnP_while1_end

    @ toOneD(tx, ty)
    stmfd sp!, {lr, r0, r1, r2}
    mov r0, r1
    stmfd sp!, {lr, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12}

    mov r1, r2
    bl to1D
    ldr r12, [r0, r11]
    ldmfd sp!, {lr, r0, r1, r2}

    cmp r12, #'O
    beq move_It_OnP_while1_end

    cmp r12, r0
    bne move_It_OnP_while2_end

    sub r5, r5, r3
    sub r6, r6, r4
move_It_OnP_while2:
    @ cond !(tx==x && ty==y)
    cmp r5, r1
    cmpeq r6, r2
    @ due to break just after while 2 ends
    beq move_It_OnP_while1_end

    @ toOneD(tx, ty)
    stmfd sp!, {lr, r0, r1, r2}
    mov r0, r1
    mov r1, r2
    bl to1D
    add r12, r0, r11
    ldmfd sp!, {lr, r0, r1, r2}
    str r0, [r12]

    @ score exchange
    cmp r0, #'W
    addeq r8, r8, #1
    addeq r9, r9, #1

    cmp r0, #'B
    addeq r8, r8, #1
    addeq r9, r9, #1

    sub r5, r5, r3
    sub r6, r6, r4
    b move_It_OnP_while2

move_It_OnP_while2_end:
    @ tx += mx;
    add r5, r5, r3
    add r6, r6, r4

move_It_OnP_while1_end:
    @ end for
    cmp r7, #16
    blt move_It_OnP_for

    @ successful move
    mov r0, #1
    mov r1, r8
    mov r2, r9
    ldmfd sp!, {lr, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12}
    mov pc, lr

clearP:
    stmfd sp!, {r4, r5, r6, r7, r8}
    ldr r5, =board
    mov r4, #0
    mov r8, #'O

clearP_for:
    add r7, r4, r5
    ldr r6, [r7]
    cmp r6, #'P
    streq r8, [r7]
    add r4, r4, #1

    @ end for
    cmp r4, #81
    blt clearP_for

    ldmfd sp!, {r4, r5, r6, r7, r8}
    mov pc, lr


display:
    stmfd sp!, {lr, r0, r1, r2, r4, r5, r6}
    swi 0x206
    ldr r4,=board
    ldr r5,=Xaxis
    ldr r6,=Yaxis 
    mov r0,#1
    mov r1,#0
    b x

x:
    ldr r2,[r5]
    swi SWI_DispInt
    add r0,r0,#1
    add r5,r5,#4

    cmp r0,#9
    blt x
    b printx

printx:
    mov r2,#'X
    swi SWI_DispChar

    mov r0,#0
    add r1,r1,#1
    b y

y:
    ldr r2,[r6]
    swi SWI_DispInt
    add r0,r0,#1
    add r6,r6,#4

    cmp r1,#9
    beq printy
    b loop1

printy:
    mov r0,#0
    mov r1,#9
    mov r2,#'Y
    swi SWI_DispChar
    b exiting

loop1:
    ldr r2, [r4]
    swi SWI_DispChar
    add r0,r0,#1
    add r4,r4,#4

    cmp r0,#9
    addeq r1, r1, #1
    moveq r0,#0
    beq y

    b loop1

exiting:
    ldmfd sp!, {lr, r0, r1, r2, r4, r5, r6}
    mov pc,lr

clearScr:
    mov r0, #0

clearScr_for:
    swi SWI_ClearStr
    add r0, r0, #1
    cmp r0, #14
    ble clearScr_for
    mov pc, lr

    .data 
    board: .space 256
    wrongPlace: .asciz "Wrong Place\n"
    gameEnd: .asciz "Game End"
    movement: .word 1,0, 1,1, 0,1, -1,1, -1,0, -1,-1, 0,-1, 1,-1
    Xaxis: .word 0,1,2,3,4,5,6,7
    Yaxis: .word 0,1,2,3,4,5,6,7,0
