.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Fibonacci number #"
STR1: 	.asciz "is"


.globl main
.text
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1, %rdi
	cmpq	$1,%rdi
	jne ABORT
	cmpq $0, %rdi
	jz SKIP_ARGS
	movq %rdi, %rcx
	addq $8, %rsi
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
SKIP_ARGS:
	call	_fibonacci_recursive
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_fibonacci_recursive:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $16, %rsp
	subq $8, %rsp
	# begin assignment of f
	# address for n (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rdi
	callq _fibonacci_number
	# address for f (local_var_0) is -16(%rbp) because func->nparms of fibonacci_recursive is 1
	movq %rax, -16(%rbp)
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for n (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for f (local_var_0) is -16(%rbp) because func->nparms of fibonacci_recursive is 1
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
_fibonacci_number:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $16, %rsp
	subq $8, %rsp
	# begin assignment of y
	movq $0, %rax
	# address for y (local_var_0) is -16(%rbp) because func->nparms of fibonacci_number is 1
	movq %rax, -16(%rbp)
	# beginning rhs of > relation
	movq $2, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for n (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .L0
	# begin assignment of y
	# beginning rhs of + expression
	# beginning rhs of - expression
	movq $2, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for n (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	movq %rax, %rdi
	callq _fibonacci_number
	# end rhs
	pushq %rax
	#beginning of lhs of + expresion
	# beginning rhs of - expression
	movq $1, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for n (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	movq %rax, %rdi
	callq _fibonacci_number
	# end of lhs
	popq %r10
	addq %r10, %rax
	# address for y (local_var_0) is -16(%rbp) because func->nparms of fibonacci_number is 1
	movq %rax, -16(%rbp)
	jmp .E0
.L0:
	# begin assignment of y
	movq $1, %rax
	# address for y (local_var_0) is -16(%rbp) because func->nparms of fibonacci_number is 1
	movq %rax, -16(%rbp)
.E0:
	# address for y (local_var_0) is -16(%rbp) because func->nparms of fibonacci_number is 1
	movq -16(%rbp), %rax
	leave
	ret
