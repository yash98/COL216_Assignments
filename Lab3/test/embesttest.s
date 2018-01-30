    .text
mov r0,#2
mov r1,#0
mov r2,#'W
swi 0x207
mov r0,#7
mov r1,#12
ldr r2,=AA
swi 0x204


    .data
Message: .asciz "Hello There"
AA: .word 'W', 23



