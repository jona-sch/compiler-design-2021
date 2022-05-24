.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Testing plain call/return and expression evaluation"
STR1: 	.asciz "The deftion returned y:="
STR2: 	.asciz "My parameters are a:="
STR3: 	.asciz "and b:="
STR4: 	.asciz "Their sum is c:="
STR5: 	.asciz "Their difference is c:="
STR6: 	.asciz "Their product is c:="
STR7: 	.asciz "Their ratio is c:="
STR8: 	.asciz "(-c):="
STR9: 	.asciz "The sum of their squares is "


.globl main
.text
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1, %rdi
	cmpq	$1,%rdi
	jne ABORT
	cmpq $0, %rdi
	jz SKIP_ARGS
	movq %rdi, %rcx
	addq $8, %rsi
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
	subq $32, %rsp
	subq $8, %rsp
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of x
	movq $15, %rax
	# address for x (local_var_0) is -16(%rbp) because func->nparms of main is 1
	movq %rax, -16(%rbp)
	# begin assignment of z
	movq $5, %rax
	# address for z (local_var_2) is -32(%rbp) because func->nparms of main is 1
	movq %rax, -32(%rbp)
	# begin assignment of y
	# address for x (local_var_0) is -16(%rbp) because func->nparms of main is 1
	movq -16(%rbp), %rax
	movq %rax, %rdi
	# address for z (local_var_2) is -32(%rbp) because func->nparms of main is 1
	movq -32(%rbp), %rax
	movq %rax, %rsi
	callq _test
	# address for y (local_var_1) is -24(%rbp) because func->nparms of main is 1
	movq %rax, -24(%rbp)
	xor %eax, %eax
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for y (local_var_1) is -24(%rbp) because func->nparms of main is 1
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
_test:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	subq $24, %rsp
	subq $8, %rsp
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
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of c
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
	# address for c (local_var_0) is -24(%rbp) because func->nparms of test is 2
	movq %rax, -24(%rbp)
	xor %eax, %eax
	leaq STR4(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (local_var_0) is -24(%rbp) because func->nparms of test is 2
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of c
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
	# address for c (local_var_0) is -24(%rbp) because func->nparms of test is 2
	movq %rax, -24(%rbp)
	xor %eax, %eax
	leaq STR5(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (local_var_0) is -24(%rbp) because func->nparms of test is 2
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of c
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
	# address for c (local_var_0) is -24(%rbp) because func->nparms of test is 2
	movq %rax, -24(%rbp)
	xor %eax, %eax
	leaq STR6(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (local_var_0) is -24(%rbp) because func->nparms of test is 2
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of c
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
	# address for c (local_var_0) is -24(%rbp) because func->nparms of test is 2
	movq %rax, -24(%rbp)
	xor %eax, %eax
	leaq STR7(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (local_var_0) is -24(%rbp) because func->nparms of test is 2
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR8(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for c (local_var_0) is -24(%rbp) because func->nparms of test is 2
	movq -24(%rbp), %rax
	neg %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR9(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# beginning rhs of + expression
	# beginning rhs of * expression
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of * expresion
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
	imulq %r10, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of + expresion
	# beginning rhs of * expression
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of * expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	imulq %r10, %rax
	# end of lhs
	popq %r10
	addq %r10, %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
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
	leave
	ret
