@ use_gdb.s
.section .data
.section .text
.global  _start
_start:
mov r1, #5
cmp r1, #4
sub r1, r1, #1
cmp r1, #4
sub r1, r1, #1
cmp r1, #4

mov r0, r1
mov r7, #1
svc #0
.end
