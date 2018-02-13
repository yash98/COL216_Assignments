    .equ SWI_Exit, 0x11
    .equ SWI_Blue, 0x203
    .equ SWI_Black, 0x202
    .equ SWI_DispChar, 0x207
    .equ SWI_DispStr, 0x204
    .equ SWI_DispInt, 0x205

    .text


    mov r9,#0
    mov r8,#0
spacealloc:
    ldr r7,=Board
    str r8,[r7]
    add r9,r9,#4
    add r7,r7,#4
    cmp r9,#256
    blt spacealloc
    bge display





display:
    swi 0x206
    stmfd sp!, {lr, r4, r5, r6}
    ldr r4,=Board
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
    ldr r2,[r4]
    swi SWI_DispInt
    add r0,r0,#1
    add r4,r4,#4

    cmp r0,#9
    addeq r1,r1,#1
    moveq r0,#0
    beq y

    b loop1

exiting:
    ldmfd sp!, {lr, r4, r5, r6}
    mov pc,lr





    .data
    Board: .space 256
    Xaxis: .word 0,1,2,3,4,5,6,7
    Yaxis: .word 0,1,2,3,4,5,6,7,0


