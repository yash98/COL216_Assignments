    .text
mov r0,#2
mov r1,#0
mov r2,#
swi 0x207
mov r0,#2
mov r1,#35
ldr r2,=AA
swi 0x204


    .data
Message: .asciz "Hello There\n"
AA: .word 'W', 23



