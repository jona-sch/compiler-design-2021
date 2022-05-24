.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "a is"
STR1: 	.asciz "and b is"
STR2: 	.asciz "a/(-b) is"
STR3: 	.asciz "10/(-2) is"


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
	call	_negatives
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_negatives:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	# begin assignment of a
	movq $100, %rax
	# address for a (local_var_0) is -8(%rbp) because func->nparms of negatives is 0
	movq %rax, -8(%rbp)
	# begin assignment of b
	movq $20, %rax
	# address for b (local_var_1) is -16(%rbp) because func->nparms of negatives is 0
	movq %rax, -16(%rbp)
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (local_var_0) is -8(%rbp) because func->nparms of negatives is 0
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for b (local_var_1) is -16(%rbp) because func->nparms of negatives is 0
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# beginning rhs of / expression
	# address for b (local_var_1) is -16(%rbp) because func->nparms of negatives is 0
	movq -16(%rbp), %rax
	neg %rax
	# end rhs
	pushq %rax
	#beginning of lhs of / expresion
	# address for a (local_var_0) is -8(%rbp) because func->nparms of negatives is 0
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cqto
	idivq %r10
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR3(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $18446744073709551611, %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
