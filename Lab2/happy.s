    .equ SWI_Exit, 0x11
	.text

    mov r4, #1 @ num checked for happy ; i in main
    mov r5, #1 @ this stores BCD Form of r4 ; x
    mov r6, #0 @ copy of r5 ; y
    mov r7, #0 @ s temporary sum of digit

MAIN:
    mov r6, r5 @ copy x to y
    bl GT_ONE
    bl HAPPY
    add r4, r4, #1
    bl ADD_ONE
    cmp r4, #9999
    ble MAIN
    swi SWI_Exit

GT_ONE:
    cmp r6, #0x10 @ 16
    movlt pc, lr
    mov r7, #0

    stmfd sp!, {lr}
    bl SUM_SQUARE
    ldmfd sp!, {lr}

    mov r6, r7
    mov pc, lr


SUM_SQUARE:
    @ load digit's squares in r0 r1 r2 r3
    and r0, r6, #0xf000
    mov r0, r0, lsr #12
    mul r0, r0, r0

    stmfd sp!, {lr, r0}
    mov r0, #0
    mov r1, #0
    bl TO_BCD
    ldmfd sp!, {lr, r0}
    mov r0, r0

    and r1, r6, #0x0f00
    mov r1, r1, lsr #8
    mul r1, r1, r1

    stmfd sp!, {lr, r0, r1}
    mov r0, #0
    mov r1, #0
    bl TO_BCD
    ldmfd sp!, {lr, r0, r1}
    mov r1, r0

    and r2, r6, #0x00f0
    mov r2, r1, lsr #4
    mul r2, r2, r2

    stmfd sp!, {lr, r0, r1}
    mov r0, #0
    mov r1, #0
    bl TO_BCD
    ldmfd sp!, {lr, r0, r1}
    mov r2, r0

    and r3, r6, #0x000f
    mul r3, r3, r3

    stmfd sp!, {lr, r0, r1}
    mov r0, #0
    mov r1, #0
    bl TO_BCD
    ldmfd sp!, {lr, r0, r1}
    mov r3, r0

    add r7, r0, r1
    add r7, r7, r2
    add r7, r7, r3

    stmfd sp!, {lr}
    bl FORMAT
    ldmfd sp!, {lr}

    movlt pc, lr

@ converts 2 digit decimal to bcd
@ uses r1 and return in r0
TO_BCD:
    cmp r0, #10
    subgt r0, r0, #10
    addgt r1, r1, #0x10
    bgt TO_BCD

    add r0, r0, r1

    mov pc, lr

@ uses r0, r1, r2, r3 edits r7
FORMAT:
    mov r0, #0
    and r1, r7, #0x00f0
    mov r1, r1, lsr #4
    and r2, r7, #0x000f

FORMATLOOP:
    mov r3, #0

    cmp r1, #10
    subgt r1, r1, #10
    addgt r0, r0, #1
    mov r3, #1

    cmp r2, #10
    subgt r2, r2, #10
    addgt r1, r1, #1
    mov r3, #1

    cmp r3, #0
    bne FORMATLOOP

    add r7, r2, r1, lsl #4
    add r7, r7, r0, lsl #8

    mov pc, lr

HAPPY:
    cmp r6, #1
    beq PRINT
    cmp r6, #7
    beq PRINT
    mov pc, lr

ADD_ONE:
    add r5, r5, #1

    and r0, r5, #0x000f
    cmp r0, #10
    subge r5, r5, #0x000a
    addge r5, r5, #0x0010

    and r0, r5, #0x00f0
    cmp r0, #10
    subge r5, r5, #0x00a0
    addge r5, r5, #0x0100

    and r0, r5, #0x0f00
    cmp r0, #10
    subge r5, r5, #0x0a00
    addge r5, r5, #0x1000

    mov pc, lr

PRINT:
    