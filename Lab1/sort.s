    .equ SWI_Exit, 0x11
	.text

    mov r1, #11 @ no. of words
    ldr r5, =AA @ final address
    sub r1, r1, #1 @ n-1 transversals required for sorting
    add r5, r5 ,r1 , lsl #2 @ =AA + 4*(n-1)
    mov r6, #0 @ counts no. of time traversed over list

VALUE:
    mov r0, #0 @ pass for sorted
    ldr r2, =AA @ address incrementor(incm)

LOOP:
    ldr r3, [r2] @ load incrementor's address
    ldr r4, [r2, #4] @ load next of incm
    cmp r3, r4 
    bgt SWAP

CONTINUE:
    add r2, r2, #4
    cmp r2, r5
    blt LOOP
    b AGAIN

SWAP:
    str r4, [r2] @ store reverse as loaded
    str r3, [r2, #4]
    orr r0, r0, #1 @ pass variable to 1 if swap required
    b CONTINUE

AGAIN:
    add r6, r6, #1
    cmp r6, r1
    blt PASSED
    swi SWI_Exit

PASSED:
    cmp r0, #0
    bne VALUE
    swi SWI_Exit
    
	.data
AA: .word   1, 9, 8, 2, 6, 4, 4, 3, 2, 11, 1
	.end