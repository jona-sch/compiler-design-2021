.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Outer x is"
STR1: 	.asciz "y is"
STR2: 	.asciz "parm is"
STR3: 	.asciz "Inner x is"
STR4: 	.asciz "y is"
STR5: 	.asciz "parm is"
STR6: 	.asciz "Outer x is"
STR7: 	.asciz "y is"
STR8: 	.asciz "parm is"


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
	subq $8, %rsp
	subq $8, %rsp
	# begin assignment of t
	movq $42, %rax
	movq %rax, %rdi
	callq _test
	# address for t (local_var_0) is -8(%rbp) because func->nparms of hello is 0
	movq %rax, -8(%rbp)
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
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for x (local_var_0) is -16(%rbp) because func->nparms of test is 1
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for y (local_var_1) is -24(%rbp) because func->nparms of test is 1
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of x
	movq $64, %rax
	# address for x (local_var_2) is -32(%rbp) because func->nparms of test is 1
	movq %rax, -32(%rbp)
	xor %eax, %eax
	leaq STR3(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for x (local_var_2) is -32(%rbp) because func->nparms of test is 1
	movq -32(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR4(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for y (local_var_1) is -24(%rbp) because func->nparms of test is 1
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR5(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR6(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for x (local_var_0) is -16(%rbp) because func->nparms of test is 1
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR7(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for y (local_var_1) is -24(%rbp) because func->nparms of test is 1
	movq -24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR8(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
