	.file	"memcpy32.c"
	.text
	.globl	memcpy32
	.type	memcpy32, @function
memcpy32:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -68(%rbp)
	movl	-68(%rbp), %eax
	shrl	$3, %eax
	movl	%eax, -40(%rbp)
	movl	-68(%rbp), %eax
	andl	$7, %eax
	movl	%eax, -36(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -24(%rbp)
	cmpl	$0, -40(%rbp)
	je	.L5
	movq	-56(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -8(%rbp)
	jmp	.L3
.L4:
	movq	-16(%rbp), %rax
	leaq	32(%rax), %rdx
	movq	%rdx, -16(%rbp)
	movq	-8(%rbp), %rdx
	leaq	32(%rdx), %rcx
	movq	%rcx, -8(%rbp)
	movq	(%rdx), %rcx
	movq	%rcx, (%rax)
	movq	8(%rdx), %rcx
	movq	%rcx, 8(%rax)
	movq	16(%rdx), %rcx
	movq	%rcx, 16(%rax)
	movq	24(%rdx), %rdx
	movq	%rdx, 24(%rax)
.L3:
	movl	-40(%rbp), %eax
	leal	-1(%rax), %edx
	movl	%edx, -40(%rbp)
	testl	%eax, %eax
	jne	.L4
	movq	-16(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, -24(%rbp)
	jmp	.L5
.L6:
	movq	-32(%rbp), %rax
	leaq	4(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movq	-24(%rbp), %rdx
	leaq	4(%rdx), %rcx
	movq	%rcx, -24(%rbp)
	movl	(%rdx), %edx
	movl	%edx, (%rax)
.L5:
	movl	-36(%rbp), %eax
	leal	-1(%rax), %edx
	movl	%edx, -36(%rbp)
	testl	%eax, %eax
	jne	.L6
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	memcpy32, .-memcpy32
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
