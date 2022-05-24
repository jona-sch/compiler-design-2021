.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "a:"
STR1: 	.asciz "b:"
STR2: 	.asciz "c:"
STR3: 	.asciz "d:"
STR4: 	.asciz "e:"
STR5: 	.asciz "f:"
STR6: 	.asciz "g:"
STR7: 	.asciz "h:"
STR8: 	.asciz "i:"
STR9: 	.asciz "j:"
STR10: 	.asciz "k:"
STR11: 	.asciz "l:"


.globl main
.text
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1, %rdi
	cmpq	$12,%rdi
	jne ABORT
	cmpq $0, %rdi
	jz SKIP_ARGS
	movq %rdi, %rcx
	addq $96, %rsi
PARSE_ARGV:
	pushq %rcx
	pushq %rsi
	movq (%rsi), %rdi
	movq $0, %rsi
	movq $10, %rdx
	call strtol
	popq %rsi
	popq %rcx
	pushq %rax
	subq $8, %rsi
	loop PARSE_ARGV
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	popq	%r8
	popq	%r9
SKIP_ARGS:
	call	_main
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_main:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	subq $96, %rsp
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (param_2) is -24(%rbp).
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR3(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for d (param_3) is -32(%rbp).
	movq -32(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR4(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for e (param_4) is -40(%rbp).
	movq -40(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR5(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for f (param_5) is -48(%rbp).
	movq -48(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR6(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for g (param_6) is 16(%rbp).
	movq 16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR7(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for h (param_7) is 24(%rbp).
	movq 24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR8(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for i (param_8) is 32(%rbp).
	movq 32(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR9(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for j (param_9) is 40(%rbp).
	movq 40(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR10(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for k (param_10) is 48(%rbp).
	movq 48(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR11(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for l (param_11) is 56(%rbp).
	movq 56(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
