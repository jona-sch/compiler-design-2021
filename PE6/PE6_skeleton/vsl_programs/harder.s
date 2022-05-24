.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Parameter a is a:="
STR1: 	.asciz "Outer scope has a:="
STR2: 	.asciz "Inner scope has a:="
STR3: 	.asciz "and b:="
STR4: 	.asciz "b was updated to "
STR5: 	.asciz "in inner scope"
STR6: 	.asciz "Outer scope (still) has a:="
STR7: 	.asciz "Return expression (a-1) using a:="
STR8: 	.asciz "Nested scopes coming up..."
STR9: 	.asciz "x:="


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
	call	_start
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_test_me:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $32, %rsp
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
	movq $'\n', %rdi
	call putchar
	# begin assignment of a
	movq $2, %rax
	# address for a (local_var_0) is -16(%rbp) because func->nparms of test_me is 1
	movq %rax, -16(%rbp)
	xor %eax, %eax
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (local_var_0) is -16(%rbp) because func->nparms of test_me is 1
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of a
	movq $3, %rax
	# address for a (local_var_2) is -32(%rbp) because func->nparms of test_me is 1
	movq %rax, -32(%rbp)
	# begin assignment of b
	movq $4, %rax
	# address for b (local_var_1) is -24(%rbp) because func->nparms of test_me is 1
	movq %rax, -24(%rbp)
	xor %eax, %eax
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (local_var_2) is -32(%rbp) because func->nparms of test_me is 1
	movq -32(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR3(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for b (local_var_1) is -24(%rbp) because func->nparms of test_me is 1
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of b
	movq $5, %rax
	# address for b (local_var_1) is -24(%rbp) because func->nparms of test_me is 1
	movq %rax, -24(%rbp)
	xor %eax, %eax
	leaq STR4(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for b (local_var_1) is -24(%rbp) because func->nparms of test_me is 1
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR5(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR6(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (local_var_0) is -16(%rbp) because func->nparms of test_me is 1
	movq -16(%rbp), %rax
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
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# beginning rhs of - expression
	movq $1, %rax
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
_start:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	subq $8, %rsp
	xor %eax, %eax
	leaq STR8(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of x
	movq $1, %rax
	movq %rax, %rdi
	callq _test_me
	# address for x (local_var_0) is -8(%rbp) because func->nparms of start is 0
	movq %rax, -8(%rbp)
	xor %eax, %eax
	leaq STR9(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for x (local_var_0) is -8(%rbp) because func->nparms of start is 0
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
