.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "foobar"
STR1: 	.asciz "Skip..."


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
	call	_while_test
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_while_test:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	subq $8, %rsp
	# begin assignment of a
	movq $20, %rax
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq %rax, -8(%rbp)
	xor %eax, %eax
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# beginning rhs of > relation
	movq $0, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .L0
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	jmp .E0
.L0:
.E0:
B1:	# beginning rhs of > relation
	movq $0, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .E1
	# beginning rhs of = relation
	movq $10, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of = expresion
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jne .L2
	# begin assignment of a
	# beginning rhs of - expression
	movq $1, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq %rax, -8(%rbp)
	xor %eax, %eax
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	jmp .E2
.L2:
	# begin assignment of a
	# beginning rhs of - expression
	movq $1, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq %rax, -8(%rbp)
.E2:
	xor %eax, %eax
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	jmp B1
.E1:
	movq $0, %rax
	leave
	ret
