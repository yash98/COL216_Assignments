    .equ SWI_Exit, 0x11
    .equ SWI_Blue, 0x203
    .equ SWI_Black, 0x202
    .equ SWI_DispChar, 0x207
    .equ SWI_DispStr, 0x204
    .equ SWI_ClearStr, 0x208
    .text

main:
    @ init
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
    r5 = prevNotStale
    r6 = movesDone
    r7 = bool store for conditionals
    r8 = rightMove
    r9 = wScore
    r10 = bScore
     */

    @ while(movesDone<=64)
    cmp r6, #64
    bgt end

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
    beq end

    cmp r4, #0
    bleq celarP
    @ returns none
    beq main_while1

    @ till right move
main_while2:
    @ while(!rightMove)
    /*  */
    @ show score chance
    @ C
    mov r0, #'C
    mov r1, 35
    mov r2, #10
    swi SWI_DispChar
    @ Chance
    mov r0, r3
    mov r1, 36
    mov r2, #10
    swi SWI_DispChar
     @ W
    mov r0, #'W
    mov r1, 35
    mov r2, #11
    swi SWI_DispChar
    @ wScore
    mov r0, r9
    mov r1, 36
    mov r2, #11
    swi SWI_DispChar
    @ B
    mov r0, #'B
    mov r1, 35
    mov r2, #12
    swi SWI_DispChar
    @ bSocre
    mov r0, r10
    mov r1, 36
    mov r2, #12
    swi SWI_DispChar
    @ X
    mov r0, #'X
    mov r1, 36
    mov r2, #13
    swi SWI_DispChar

    bl input_keyboard
    mov r1, r0

    mov r0, r1
    mov r1, 36
    mov r2, #14
    swi SWI_DispChar

    @ Y
    mov r0, #'Y
    mov r1, 38
    mov r2, #13
    swi SWI_DispChar

    bl input_keyboard
    mov r2, r0

    mov r0, r2
    mov r1, 36
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

    mov r8, #0
    b main_while1

main_end:
    /*  */
    ldreq r2, =gameEnd
    ldreq r2, [r2]
    moveq r0, #0
    moveq r1, #11
    swieq SWI_DispStr

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
    beq main
    cmp r0, #0x0
    b input_keyboard
    mov pc, lr


    .data 
board: .space 256
wrongPlace: .asciz "Wrong Place\n"
gameEnd: .asciz "Game End"
