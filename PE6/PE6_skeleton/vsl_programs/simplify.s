.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"


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
	call	_f
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_f:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	movq $0, %rax
	leave
	ret
_h:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	subq $24, %rsp
	subq $8, %rsp
	# begin assignment of x
	movq $5, %rax
	# address for x (local_var_0) is -24(%rbp) because func->nparms of h is 2
	movq %rax, -24(%rbp)
	# begin assignment of x
	movq $1, %rax
	# address for x (local_var_0) is -24(%rbp) because func->nparms of h is 2
	movq %rax, -24(%rbp)
	# begin assignment of x
	movq $4, %rax
	# address for x (local_var_0) is -24(%rbp) because func->nparms of h is 2
	movq %rax, -24(%rbp)
	# begin assignment of x
	movq $2, %rax
	# address for x (local_var_0) is -24(%rbp) because func->nparms of h is 2
	movq %rax, -24(%rbp)
	# begin assignment of x
	movq $18446744073709551610, %rax
	# address for x (local_var_0) is -24(%rbp) because func->nparms of h is 2
	movq %rax, -24(%rbp)
	# begin assignment of x
	movq $4, %rax
	# address for x (local_var_0) is -24(%rbp) because func->nparms of h is 2
	movq %rax, -24(%rbp)
	movq $0, %rax
	leave
	ret
_g:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	pushq %rdx
	subq $72, %rsp
	# begin assignment of u
	movq $1, %rax
	# address for u (local_var_0) is -32(%rbp) because func->nparms of g is 3
	movq %rax, -32(%rbp)
	# begin assignment of v
	movq $2, %rax
	# address for v (local_var_1) is -40(%rbp) because func->nparms of g is 3
	movq %rax, -40(%rbp)
	# begin assignment of w
	# beginning rhs of + expression
	movq $1, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of + expresion
	# address for x (local_var_3) is -56(%rbp) because func->nparms of g is 3
	movq -56(%rbp), %rax
	# end of lhs
	popq %r10
	addq %r10, %rax
	movq %rax, %rdi
	# beginning rhs of + expression
	movq $2, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of + expresion
	# address for y (local_var_4) is -64(%rbp) because func->nparms of g is 3
	movq -64(%rbp), %rax
	# end of lhs
	popq %r10
	addq %r10, %rax
	movq %rax, %rsi
	# beginning rhs of + expression
	movq $3, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of + expresion
	# address for z (local_var_5) is -72(%rbp) because func->nparms of g is 3
	movq -72(%rbp), %rax
	# end of lhs
	popq %r10
	addq %r10, %rax
	movq %rax, %rdx
	callq _g
	# address for w (local_var_2) is -48(%rbp) because func->nparms of g is 3
	movq %rax, -48(%rbp)
	xor %eax, %eax
	# address for u (local_var_0) is -32(%rbp) because func->nparms of g is 3
	movq -32(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	# address for v (local_var_1) is -40(%rbp) because func->nparms of g is 3
	movq -40(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	# address for w (local_var_2) is -48(%rbp) because func->nparms of g is 3
	movq -48(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
