.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Inner a is "
STR1: 	.asciz "Outer a is "
STR2: 	.asciz "Global k is "

_j: .zero 8
_i: .zero 8
_k: .zero 8

.globl main
.text
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1, %rdi
	cmpq	$3,%rdi
	jne ABORT
	cmpq $0, %rdi
	jz SKIP_ARGS
	movq %rdi, %rcx
	addq $24, %rsi
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
SKIP_ARGS:
	call	_nesting_scopes
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_nesting_scopes:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	pushq %rdx
	subq $88, %rsp
	# begin assignment of a
	movq $21, %rax
	# address for a (local_var_0) is -32(%rbp) because func->nparms of nesting_scopes is 3
	movq %rax, -32(%rbp)
	# begin assignment of a
	movq $42, %rax
	# address for a (local_var_6) is -80(%rbp) because func->nparms of nesting_scopes is 3
	movq %rax, -80(%rbp)
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (local_var_6) is -80(%rbp) because func->nparms of nesting_scopes is 3
	movq -80(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for a (local_var_0) is -32(%rbp) because func->nparms of nesting_scopes is 3
	movq -32(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for k (global) is _k(%rip).
	movq _k(%rip), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
