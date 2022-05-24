.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "t is"
STR1: 	.asciz "This never executes"


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
	call	_hello
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_hello:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $64, %rax
	movq %rax, %rdi
	callq _test
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
	subq $32, %rsp
	subq $8, %rsp
	# begin assignment of x
	movq $32, %rax
	# address for x (local_var_0) is -16(%rbp) because func->nparms of test is 1
	movq %rax, -16(%rbp)
	# begin assignment of y
	movq $20, %rax
	# address for y (local_var_1) is -24(%rbp) because func->nparms of test is 1
	movq %rax, -24(%rbp)
	# begin assignment of x
	movq $64, %rax
	# address for x (local_var_2) is -32(%rbp) because func->nparms of test is 1
	movq %rax, -32(%rbp)
	# beginning rhs of + expression
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of + expresion
	# address for x (local_var_2) is -32(%rbp) because func->nparms of test is 1
	movq -32(%rbp), %rax
	# end of lhs
	popq %r10
	addq %r10, %rax
	leave
	ret
	xor %eax, %eax
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
