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
    b PASSED

SWAP:
    str r4, [r2] @ store reverse as loaded
    str r3, [r2, #4]
    orr r0, r0, #1 @ pass variable to 1 if swap required
    b CONTINUE

PASSED:
    sub r5, r5, #4
    cmp r0, #0
    bne VALUE
    swi SWI_Exit
    
	.data
AA: .word   11, 9, 8, 5, 6, 20, 4, 3, 2, 11, 1
	.end