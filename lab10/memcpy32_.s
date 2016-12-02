@ === void memcpy32(void *dst, const void *src, uint wdcount)
IWRAM_CODE;
@ r0, r1: dst, src
@ r2: wdcount, then wdcount>>3
@ r3-r10: data buffer
@ r12: wdn&7
	.section .iwram, "ax", %progbits
	.align 2
	.code 32
	.global memcpy32
	.type memcpy32 STT_FUNC
memcpy32:
	and r12, r2, #7
	movs r2, r2, lsr #3
	beq .Lres_cpy32
	push {r4-r10}
.Lmain_cpy32:
	ldmia r1!, {r3-r10}
	stmia r0!, {r3-r10}
	subs r2, #1
	bne .Lmain_cpy32
	pop {r4-r10}
.Lres_cpy32:
	subs r12, #1
	ldrcs r3, [r1], #4
	strcs r3, [r0], #4
	bcs .Lres_cpy32
bx lr