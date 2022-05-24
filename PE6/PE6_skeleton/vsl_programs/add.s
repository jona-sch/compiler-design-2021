.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "a + b ="
STR1: 	.asciz "a - b ="
STR2: 	.asciz "a * b ="
STR3: 	.asciz "a / b ="
STR4: 	.asciz "a | b ="
STR5: 	.asciz "a ^ b ="
STR6: 	.asciz "a & b ="
STR7: 	.asciz "-a ="
STR8: 	.asciz "~a ="
STR9: 	.asciz "my friend"
STR10: 	.asciz "(-2) is: "


.globl main
.text
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1, %rdi
	cmpq	$2,%rdi
	jne ABORT
	cmpq $0, %rdi
	jz SKIP_ARGS
	movq %rdi, %rcx
	addq $16, %rsi
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
	subq $24, %rsp
	subq $8, %rsp
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# beginning rhs of + expression
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of + expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	addq %r10, %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# beginning rhs of - expression
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# beginning rhs of * expression
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of * expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	imulq %r10, %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR3(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# beginning rhs of / expression
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of / expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cqto
	idivq %r10
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR4(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# beginning rhs of | expression
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of | expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	or %r10, %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR5(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# beginning rhs of ^ expression
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of ^ expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	xor %r10, %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR6(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# beginning rhs of & expression
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of & expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	and %r10, %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR7(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	neg %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR8(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	not %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR9(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR10(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $18446744073709551611, %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
