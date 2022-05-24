.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Calling my_deftion with parameters"
STR1: 	.asciz "The returned result is"
STR2: 	.asciz "The other returned result is"
STR3: 	.asciz "Parameter s is"
STR4: 	.asciz "Parameter t is"
STR5: 	.asciz "The sum of their squares is"


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
	call	_defall
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_defall:
	pushq %rbp
	movq %rsp, %rbp
	subq $24, %rsp
	subq $8, %rsp
	# begin assignment of x
	movq $5, %rax
	# address for x (local_var_0) is -8(%rbp) because func->nparms of defall is 0
	movq %rax, -8(%rbp)
	# begin assignment of y
	movq $10, %rax
	# address for y (local_var_1) is -16(%rbp) because func->nparms of defall is 0
	movq %rax, -16(%rbp)
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for x (local_var_0) is -8(%rbp) because func->nparms of defall is 0
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	# address for y (local_var_1) is -16(%rbp) because func->nparms of defall is 0
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of z
	# address for x (local_var_0) is -8(%rbp) because func->nparms of defall is 0
	movq -8(%rbp), %rax
	movq %rax, %rdi
	# address for y (local_var_1) is -16(%rbp) because func->nparms of defall is 0
	movq -16(%rbp), %rax
	movq %rax, %rsi
	callq _my_deftion
	# address for z (local_var_2) is -24(%rbp) because func->nparms of defall is 0
	movq %rax, -24(%rbp)
	xor %eax, %eax
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for z (local_var_2) is -24(%rbp) because func->nparms of defall is 0
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of z
	callq _my_other_deftion
	# address for z (local_var_2) is -24(%rbp) because func->nparms of defall is 0
	movq %rax, -24(%rbp)
	xor %eax, %eax
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for z (local_var_2) is -24(%rbp) because func->nparms of defall is 0
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
_my_other_deftion:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	subq $8, %rsp
	# begin assignment of x
	movq $42, %rax
	# address for x (local_var_0) is -8(%rbp) because func->nparms of my_other_deftion is 0
	movq %rax, -8(%rbp)
	# address for x (local_var_0) is -8(%rbp) because func->nparms of my_other_deftion is 0
	movq -8(%rbp), %rax
	leave
	ret
_my_deftion:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	subq $24, %rsp
	subq $8, %rsp
	# begin assignment of u
	# beginning rhs of + expression
	# beginning rhs of * expression
	# address for t (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of * expresion
	# address for t (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
	imulq %r10, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of + expresion
	# beginning rhs of * expression
	# address for s (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of * expresion
	# address for s (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	imulq %r10, %rax
	# end of lhs
	popq %r10
	addq %r10, %rax
	# address for u (local_var_0) is -24(%rbp) because func->nparms of my_deftion is 2
	movq %rax, -24(%rbp)
	xor %eax, %eax
	leaq STR3(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for s (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR4(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for t (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR5(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for u (local_var_0) is -24(%rbp) because func->nparms of my_deftion is 2
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# address for u (local_var_0) is -24(%rbp) because func->nparms of my_deftion is 2
	movq -24(%rbp), %rax
	leave
	ret
