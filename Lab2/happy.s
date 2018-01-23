    .equ SWI_Exit, 0x11
    .equ SWI_Open, 0x66
    .equ SWI_Close, 0x68
    .equ SWI_PrInt, 0x6b
    .equ SWI_PrStr, 0x69

	.text

    ldr r0, =OutFileName
    mov r1, #1 @ output mode
    swi SWI_Open
    ldr r1, =OutFileHandle
    str r0, [r1]

    ldr r10, =AA

    mov r4, #1 @ num checked for happy ; i in START
    mov r5, #1 @ this stores BCD Form of r4 ; x
    mov r6, #0 @ copy of r5 ; y
    mov r7, #0 @ s temporary sum of digit
    mov r9, #1000
    mov r8, #10
    mul r9, r8, r9
    sub r9, r9, #1

START:
    mov r6, r5 @ copy x to y
    bl GT_ONE
    bl HAPPY
    add r4, r4, #1
    bl ADD_ONE
    cmp r4, r9
    ble START
    b EXIT

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
    mov r8, r0
    mul r0, r8, r8

    stmfd sp!, {lr, r0}
    mov r0, #0
    mov r1, #0
    bl TO_BCD
    ldmfd sp!, {lr, r0}
    mov r0, r0

    and r1, r6, #0x0f00
    mov r1, r1, lsr #8
    mov r8, r1
    mul r1, r8, r8

    stmfd sp!, {lr, r0, r1}
    mov r0, #0
    mov r1, #0
    bl TO_BCD
    ldmfd sp!, {lr, r0, r1}
    mov r1, r0

    and r2, r6, #0x00f0
    mov r2, r1, lsr #4
    mov r8, r2
    mul r2, r8, r8

    stmfd sp!, {lr, r0, r1}
    mov r0, #0
    mov r1, #0
    bl TO_BCD
    ldmfd sp!, {lr, r0, r1}
    mov r2, r0

    and r3, r6, #0x000f
    mov r8, r3
    mul r3, r8, r8

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
    stmfd sp!, {lr}
    cmp r6, #1
    bleq PRINT
    cmp r6, #7
    bleq PRINT
    ldmfd sp!, {lr}
    mov pc, lr

ADD_ONE:
    add r5, r5, #1

    and r0, r5, #0x000f
    cmp r0, #10
    subge r5, r5, #0x000a
    addge r5, r5, #0x0010
    mov r0, #0

    and r0, r5, #0x00f0
    cmp r0, #0xa0
    subge r5, r5, #0x00a0
    addge r5, r5, #0x0100
    mov r0, #0

    and r0, r5, #0x0f00
    cmp r0, #0xa00
    subge r5, r5, #0x0a00
    addge r5, r5, #0x1000
    mov r0, #0

    mov pc, lr

PRINT:
    str r4, [r10, #4]!
    ldr r0, =OutFileHandle
    ldr r0, [r0]
    mov r1, r4
    swi SWI_PrInt
    ldr r1, =NextLine
    swi SWI_PrStr
    mov pc, lr

EXIT:
    @load the file handle
    ldr r0,=OutFileHandle
    ldr r0,[r0]
    swi SWI_Close
    swi SWI_Exit

    .data
    OutFileName: .asciz "~/Desktop/Outfile.txt"
    OutFileError: .asciz "Unable to open output file\n"
    NextLine: .asciz "\n"
    .align
    OutFileHandle: .word 0

    AA: .space  400


