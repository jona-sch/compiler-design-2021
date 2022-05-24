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
	call	_fibonacci_iterative
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_fibonacci_iterative:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $40, %rsp
	# begin assignment of w
	# address for n (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# address for w (local_var_0) is -16(%rbp) because func->nparms of fibonacci_iterative is 1
	movq %rax, -16(%rbp)
	# begin assignment of x
	movq $1, %rax
	# address for x (local_var_1) is -24(%rbp) because func->nparms of fibonacci_iterative is 1
	movq %rax, -24(%rbp)
	# begin assignment of y
	movq $1, %rax
	# address for y (local_var_2) is -32(%rbp) because func->nparms of fibonacci_iterative is 1
	movq %rax, -32(%rbp)
	# begin assignment of f
	movq $1, %rax
	# address for f (local_var_3) is -40(%rbp) because func->nparms of fibonacci_iterative is 1
	movq %rax, -40(%rbp)
	# beginning rhs of > relation
	movq $0, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for w (local_var_0) is -16(%rbp) because func->nparms of fibonacci_iterative is 1
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .L0
	# beginning rhs of > relation
	movq $1, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for w (local_var_0) is -16(%rbp) because func->nparms of fibonacci_iterative is 1
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .L1
	# beginning rhs of > relation
	movq $2, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for w (local_var_0) is -16(%rbp) because func->nparms of fibonacci_iterative is 1
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .L2
B3:	# beginning rhs of > relation
	movq $3, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for w (local_var_0) is -16(%rbp) because func->nparms of fibonacci_iterative is 1
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jle .E3
	# begin assignment of f
	# beginning rhs of + expression
	# address for x (local_var_1) is -24(%rbp) because func->nparms of fibonacci_iterative is 1
	movq -24(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of + expresion
	# address for y (local_var_2) is -32(%rbp) because func->nparms of fibonacci_iterative is 1
	movq -32(%rbp), %rax
	# end of lhs
	popq %r10
	addq %r10, %rax
	# address for f (local_var_3) is -40(%rbp) because func->nparms of fibonacci_iterative is 1
	movq %rax, -40(%rbp)
	# begin assignment of x
	# address for y (local_var_2) is -32(%rbp) because func->nparms of fibonacci_iterative is 1
	movq -32(%rbp), %rax
	# address for x (local_var_1) is -24(%rbp) because func->nparms of fibonacci_iterative is 1
	movq %rax, -24(%rbp)
	# begin assignment of y
	# address for f (local_var_3) is -40(%rbp) because func->nparms of fibonacci_iterative is 1
	movq -40(%rbp), %rax
	# address for y (local_var_2) is -32(%rbp) because func->nparms of fibonacci_iterative is 1
	movq %rax, -32(%rbp)
	# begin assignment of w
	# beginning rhs of - expression
	movq $1, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of - expresion
	# address for w (local_var_0) is -16(%rbp) because func->nparms of fibonacci_iterative is 1
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
	subq %r10, %rax
	# address for w (local_var_0) is -16(%rbp) because func->nparms of fibonacci_iterative is 1
	movq %rax, -16(%rbp)
	jmp B3
.E3:
	jmp .E2
.L2:
.E2:
	jmp .E1
.L1:
.E1:
	jmp .E0
.L0:
	# begin assignment of f
	movq $0, %rax
	# address for f (local_var_3) is -40(%rbp) because func->nparms of fibonacci_iterative is 1
	movq %rax, -40(%rbp)
.E0:
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
	# address for f (local_var_3) is -40(%rbp) because func->nparms of fibonacci_iterative is 1
	movq -40(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
