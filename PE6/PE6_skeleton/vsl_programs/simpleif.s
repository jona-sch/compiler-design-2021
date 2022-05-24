.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Equal!"


.globl main
.text
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1, %rdi
	cmpq	$7,%rdi
	jne ABORT
	cmpq $0, %rdi
	jz SKIP_ARGS
	movq %rdi, %rcx
	addq $56, %rsi
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
	call	_dingdong
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_dingdong:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	subq $64, %rsp
	subq $8, %rsp
	# begin assignment of x
	movq $42, %rax
	# address for x (local_var_0) is -56(%rbp) because func->nparms of dingdong is 6
	movq %rax, -56(%rbp)
	xor %eax, %eax
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	# address for b (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	# address for c (param_2) is -24(%rbp).
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	# address for d (param_3) is -32(%rbp).
	movq -32(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	# address for e (param_4) is -40(%rbp).
	movq -40(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	# address for f (param_5) is -48(%rbp).
	movq -48(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	# address for g (param_6) is 16(%rbp).
	movq 16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# beginning rhs of = relation
	movq $42, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of = expresion
	# address for x (local_var_0) is -56(%rbp) because func->nparms of dingdong is 6
	movq -56(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jne .L0
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of x
	movq $43, %rax
	# address for x (local_var_0) is -56(%rbp) because func->nparms of dingdong is 6
	movq %rax, -56(%rbp)
	jmp .E0
.L0:
	# begin assignment of x
	movq $44, %rax
	# address for x (local_var_0) is -56(%rbp) because func->nparms of dingdong is 6
	movq %rax, -56(%rbp)
.E0:
B1:	# beginning rhs of > relation
	movq $0, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for x (local_var_0) is -56(%rbp) because func->nparms of dingdong is 6
	movq -56(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .E1
	xor %eax, %eax
	# address for x (local_var_0) is -56(%rbp) because func->nparms of dingdong is 6
	movq -56(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of x
	# beginning rhs of - expression
	movq $1, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for x (local_var_0) is -56(%rbp) because func->nparms of dingdong is 6
	movq -56(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	# address for x (local_var_0) is -56(%rbp) because func->nparms of dingdong is 6
	movq %rax, -56(%rbp)
	jmp B1
.E1:
	# address for x (local_var_0) is -56(%rbp) because func->nparms of dingdong is 6
	movq -56(%rbp), %rax
	leave
	ret
