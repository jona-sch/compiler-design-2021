.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "2*(3-1) := "
STR1: 	.asciz "2*3-1 := "


.globl main
.text
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1, %rdi
	cmpq	$0,%rdi
	jne ABORT
	cmpq $0, %rdi
	jz SKIP_ARGS
	movq %rdi, %rcx
	addq $0, %rsi
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
SKIP_ARGS:
	call	_precedence
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_precedence:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp
	# begin assignment of a
	movq $2, %rax
	# address for a (local_var_0) is -8(%rbp) because func->nparms of precedence is 0
	movq %rax, -8(%rbp)
	# begin assignment of b
	movq $3, %rax
	# address for b (local_var_1) is -16(%rbp) because func->nparms of precedence is 0
	movq %rax, -16(%rbp)
	# begin assignment of c
	movq $1, %rax
	# address for c (local_var_2) is -24(%rbp) because func->nparms of precedence is 0
	movq %rax, -24(%rbp)
	# begin assignment of d
	# beginning rhs of * expression
	# beginning rhs of - expression
	# address for c (local_var_2) is -24(%rbp) because func->nparms of precedence is 0
	movq -24(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for b (local_var_1) is -16(%rbp) because func->nparms of precedence is 0
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of * expresion
	# address for a (local_var_0) is -8(%rbp) because func->nparms of precedence is 0
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	imulq %r10, %rax
	# address for d (local_var_3) is -32(%rbp) because func->nparms of precedence is 0
	movq %rax, -32(%rbp)
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for d (local_var_3) is -32(%rbp) because func->nparms of precedence is 0
	movq -32(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of d
	# beginning rhs of - expression
	# address for c (local_var_2) is -24(%rbp) because func->nparms of precedence is 0
	movq -24(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# beginning rhs of * expression
	# address for b (local_var_1) is -16(%rbp) because func->nparms of precedence is 0
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of * expresion
	# address for a (local_var_0) is -8(%rbp) because func->nparms of precedence is 0
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	imulq %r10, %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	# address for d (local_var_3) is -32(%rbp) because func->nparms of precedence is 0
	movq %rax, -32(%rbp)
	xor %eax, %eax
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for d (local_var_3) is -32(%rbp) because func->nparms of precedence is 0
	movq -32(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
