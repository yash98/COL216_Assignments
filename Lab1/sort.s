    .equ SWI_Exit, 0x11
	.text

    mov r5, [=AA, r1, lsl #2] @ final address
    mov r1, #10 @ no. of words

VALUE:
    mov r0, #0 @ pass for sorted
    mov r2, =AA @ address incrementor

LOOP:
    ldr r3, [r2]
    ldr r4, [r2, #4]
    cmp r3, r4
    bgt SWAP

CONTINUE:
    add r2, r2, #4
    cmp r2, r5
    blt LOOP
    b AGAIN

SWAP:
    str r4, [r2]
    str r3, [r2, #4]
    orr r0, r0, #1
    b CONTINUE

AGAIN:
    cmp r0, #0
    bne VALUE
    swi SWI_Exit
    
	.data
AA: .word =	10, 9, 8, 7, 6, 5, 4, 3, 2, 1
	.end