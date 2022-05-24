.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "A equals 10"
STR1: 	.asciz "B is greater than -15"
STR2: 	.asciz "B is smaller than or equal to -15"


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
	subq $16, %rsp
	# begin assignment of a
	movq $10, %rax
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq %rax, -8(%rbp)
	# begin assignment of b
	movq $18446744073709551601, %rax
	# address for b (local_var_1) is -16(%rbp) because func->nparms of while_test is 0
	movq %rax, -16(%rbp)
	xor %eax, %eax
	# address for a (local_var_0) is -8(%rbp) because func->nparms of while_test is 0
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
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
	jne .L0
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	jmp .E0
.L0:
.E0:
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
	jle .L1
	# beginning rhs of > relation
	movq $18446744073709551601, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for b (local_var_1) is -16(%rbp) because func->nparms of while_test is 0
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .L2
	xor %eax, %eax
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	jmp .E2
.L2:
	xor %eax, %eax
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
.E2:
	jmp .E1
.L1:
.E1:
	movq $0, %rax
	leave
	ret
