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

    mov r4, #1  @ maintain number check count
    mov r7, #1000
    mov r8, #10
    mul r6, r7, r8 
    
start:
    mov r5, r4
    bl check_happy
    add r4, r4, #1
    cmp r4, r6
    blt start

    ldr r0,=OutFileHandle
    ldr r0,[r0]
    swi SWI_Close
    swi SWI_Exit


check_happy:
    stmfd sp!, {lr}
    
    cmp r5, #10
    blge sum_square
    bllt one_or_seven

    cmp r5, #10
    bge check_happy

    ldmfd sp!, {lr}
    mov pc, lr

one_or_seven:
    stmfd sp!, {lr}
    cmp r5, #1
    bleq print
    cmp r5, #7
    bleq print

    ldmfd sp!, {lr}
    mov pc, lr

print:
    ldr r0, =OutFileHandle
    ldr r0, [r0]
    mov r1, r4
    swi SWI_PrInt
    ldr r1, =NextLine
    swi SWI_PrStr

    mov pc, lr

sum_square:
    stmfd sp!, {lr}

    mov r0, #0
    mov r1, #0
    mov r2, #0
    mov r3, #0
    bl sep_digit

    mov r5, r0
    mul r0, r5, r5
    mov r5, r1
    mul r1, r5, r5
    mov r5, r2
    mul r2, r5, r5
    mov r5, r3
    mul r5, r3, r3

    add r5, r5, r2
    add r5, r5, r1
    add r5, r5, r0

    ldmfd sp!, {lr}
    mov pc, lr


sep_digit:
    cmp r5, #1000
    bge septhree
    cmplt r5, #100
    bge septwo
    cmplt r5, #10
    bge sepone
    movlt r0, r5

    movlt pc, lr

septhree:
    sub r5, r5, #1000
    add r3, r3, #1
    cmp r5, #1000
    blt sep_digit
    bge septhree

septwo:
    sub r5, r5, #100
    add r2, r2, #1
    cmp r5, #100
    blt sep_digit
    bge septwo

sepone:
    sub r5, r5, #10
    add r1, r1, #1
    cmp r5, #10
    blt sep_digit
    bge sepone


    .data
    OutFileName: .asciz "Outfile.txt"
    OutFileError: .asciz "Unable to open output file\n"
    NextLine: .asciz "\n"
    .align
    OutFileHandle: .word 0
