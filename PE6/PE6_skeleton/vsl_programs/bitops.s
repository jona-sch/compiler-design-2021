.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "a is"
STR1: 	.asciz "and b is"
STR2: 	.asciz "~"
STR3: 	.asciz "="
STR4: 	.asciz "|"
STR5: 	.asciz "="
STR6: 	.asciz "^"
STR7: 	.asciz "="
STR8: 	.asciz "&"
STR9: 	.asciz "="
STR10: 	.asciz "<<"
STR11: 	.asciz "="
STR12: 	.asciz ">>"
STR13: 	.asciz "="


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
	call	_bitwise_operators
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_bitwise_operators:
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
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
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
	# begin assignment of c
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	not %rax
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq %rax, -24(%rbp)
	xor %eax, %eax
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR3(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of c
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
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq %rax, -24(%rbp)
	xor %eax, %eax
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR4(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR5(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of c
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
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq %rax, -24(%rbp)
	xor %eax, %eax
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR6(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR7(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of c
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
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq %rax, -24(%rbp)
	xor %eax, %eax
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR8(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR9(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of c
	# beginning rhs of < expression
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of < expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	movq %r10, %rcx
	shl %cl, %rax
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq %rax, -24(%rbp)
	xor %eax, %eax
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR10(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR11(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of c
	# beginning rhs of > expression
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	movq %r10, %rcx
	shr %cl, %rax
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq %rax, -24(%rbp)
	xor %eax, %eax
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR12(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR13(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (local_var_0) is -24(%rbp) because func->nparms of bitwise_operators is 2
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
