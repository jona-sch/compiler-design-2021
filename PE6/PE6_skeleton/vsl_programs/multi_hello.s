.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Morna"

_x: .zero 8
_z: .zero 8
_w: .zero 8
_y: .zero 8

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
	# begin assignment of w
	movq $1, %rax
	movq %rax, %rdi
	movq $2, %rax
	movq %rax, %rsi
	movq $3, %rax
	movq %rax, %rdx
	movq $4, %rax
	movq %rax, %rcx
	movq $5, %rax
	movq %rax, %r8
	movq $6, %rax
	movq %rax, %r9
	movq $8, %rax
	pushq %rax
	movq $7, %rax
	pushq %rax
	callq _goodbye
	# address for w (global) is _w(%rip).
	movq %rax, _w(%rip)
	xor %eax, %eax
	# address for w (global) is _w(%rip).
	movq _w(%rip), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# address for w (global) is _w(%rip).
	movq _w(%rip), %rax
	leave
	ret
_goodbye:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	subq $64, %rsp
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
	# address for h (param_7) is 24(%rbp).
	movq 24(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $1, %rax
	movq %rax, %rdi
	callq _tralala
	leave
	ret
_tralala:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $40, %rsp
	# begin assignment of x
	movq $3, %rax
	# address for x (local_var_0) is -16(%rbp) because func->nparms of tralala is 1
	movq %rax, -16(%rbp)
	# begin assignment of y
	movq $5, %rax
	# address for y (local_var_1) is -24(%rbp) because func->nparms of tralala is 1
	movq %rax, -24(%rbp)
	# begin assignment of z
	movq $2, %rax
	# address for z (local_var_2) is -32(%rbp) because func->nparms of tralala is 1
	movq %rax, -32(%rbp)
	# begin assignment of w
	movq $4, %rax
	# address for w (local_var_3) is -40(%rbp) because func->nparms of tralala is 1
	movq %rax, -40(%rbp)
	# begin assignment of wang
	movq $42, %rax
	# address for wang (param_0) is -8(%rbp).
	movq %rax, -8(%rbp)
	xor %eax, %eax
	# address for wang (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	# beginning rhs of * expression
	# address for y (local_var_1) is -24(%rbp) because func->nparms of tralala is 1
	movq -24(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of * expresion
	# address for x (local_var_0) is -16(%rbp) because func->nparms of tralala is 1
	movq -16(%rbp), %rax
	# end of lhs
	popq %r10
	imulq %r10, %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	# beginning rhs of * expression
	# address for w (local_var_3) is -40(%rbp) because func->nparms of tralala is 1
	movq -40(%rbp), %rax
	# end rhs
	pushq %rax
	#beginning of lhs of * expresion
	# address for z (local_var_2) is -32(%rbp) because func->nparms of tralala is 1
	movq -32(%rbp), %rax
	# end of lhs
	popq %r10
	imulq %r10, %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $1, %rax
	leave
	ret
