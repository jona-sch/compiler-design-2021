.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Greatest common divisor of"
STR1: 	.asciz "and"
STR2: 	.asciz "is"
STR3: 	.asciz "and"
STR4: 	.asciz "are relative primes"


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
	call	_euclid
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_gcd:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	subq $24, %rsp
	subq $8, %rsp
	# beginning rhs of > relation
	movq $0, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .L0
	# begin assignment of g
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rdi
	# beginning rhs of - expression
	# beginning rhs of * expression
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of * expresion
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
	# end of lhs
	popq %r10
	imulq %r10, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	movq %rax, %rsi
	callq _gcd
	# address for g (local_var_0) is -24(%rbp) because func->nparms of gcd is 2
	movq %rax, -24(%rbp)
	jmp .E0
.L0:
	# begin assignment of g
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# address for g (local_var_0) is -24(%rbp) because func->nparms of gcd is 2
	movq %rax, -24(%rbp)
.E0:
	# address for g (local_var_0) is -24(%rbp) because func->nparms of gcd is 2
	movq -24(%rbp), %rax
	leave
	ret
_euclid:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	subq $16, %rsp
	# beginning rhs of < relation
	movq $0, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of < expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jge .L1
	# begin assignment of a
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	neg %rax
	# address for a (param_0) is -8(%rbp).
	movq %rax, -8(%rbp)
	jmp .E1
.L1:
.E1:
	# beginning rhs of < relation
	movq $0, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of < expresion
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jge .L2
	# begin assignment of b
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	neg %rax
	# address for b (param_1) is -16(%rbp).
	movq %rax, -16(%rbp)
	jmp .E2
.L2:
.E2:
	# beginning rhs of > relation
	movq $1, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rdi
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	callq _gcd
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .L3
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
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rdi
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	callq _gcd
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	jmp .E3
.L3:
	xor %eax, %eax
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR3(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR4(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
.E3:
	movq $0, %rax
	leave
	ret
