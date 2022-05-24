.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "is a prime factor"


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
	call	_main
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_factor:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $24, %rsp
	# begin assignment of f
	# beginning rhs of / expression
	movq $2, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of / expresion
	# address for n (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cqto
	idivq %r10
	# address for f (local_var_0) is -16(%rbp) because func->nparms of factor is 1
	movq %rax, -16(%rbp)
B0:	# beginning rhs of > relation
	movq $0, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# beginning rhs of - expression
	# beginning rhs of * expression
	# beginning rhs of / expression
	# address for f (local_var_0) is -16(%rbp) because func->nparms of factor is 1
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of / expresion
	# address for n (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cqto
	idivq %r10
	# end rhs
	pushq %rax
	#beginning of lhs of * expresion
	# address for f (local_var_0) is -16(%rbp) because func->nparms of factor is 1
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
	imulq %r10, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for n (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .E0
	# begin assignment of f
	# beginning rhs of - expression
	movq $1, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for f (local_var_0) is -16(%rbp) because func->nparms of factor is 1
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	# address for f (local_var_0) is -16(%rbp) because func->nparms of factor is 1
	movq %rax, -16(%rbp)
	jmp B0
.E0:
	# beginning rhs of > relation
	movq $0, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# beginning rhs of - expression
	movq $1, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for f (local_var_0) is -16(%rbp) because func->nparms of factor is 1
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .L1
	# begin assignment of r
	# address for f (local_var_0) is -16(%rbp) because func->nparms of factor is 1
	movq -16(%rbp), %rax
	movq %rax, %rdi
	callq _factor
	# address for r (local_var_1) is -24(%rbp) because func->nparms of factor is 1
	movq %rax, -24(%rbp)
	# begin assignment of r
	# beginning rhs of / expression
	# address for f (local_var_0) is -16(%rbp) because func->nparms of factor is 1
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of / expresion
	# address for n (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cqto
	idivq %r10
	movq %rax, %rdi
	callq _factor
	# address for r (local_var_1) is -24(%rbp) because func->nparms of factor is 1
	movq %rax, -24(%rbp)
	jmp .E1
.L1:
	xor %eax, %eax
	# address for n (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
.E1:
	movq $0, %rax
	leave
	ret
_main:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	movq $1836311903, %rax
	movq %rax, %rdi
	callq _factor
	leave
	ret
