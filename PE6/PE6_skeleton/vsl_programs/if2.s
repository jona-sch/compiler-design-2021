.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Bigger"
STR1: 	.asciz "Smaller"
STR2: 	.asciz "Equal"


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
	call	_test
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_test:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $8, %rsp
	xor %eax, %eax
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# beginning rhs of > relation
	movq $10, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of > expresion
	# address for a (param_0) is -8(%rbp).
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
	# beginning rhs of < relation
	movq $10, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of < expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jge .L1
	xor %eax, %eax
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	jmp .E1
.L1:
.E1:
	# beginning rhs of = relation
	movq $10, %rax
	# end rhs
	pushq %rax
	#beginning of lhs of = expresion
	# address for a (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	# end of lhs
	popq %r10
cmpq %r10, %rax
	jne .L2
	xor %eax, %eax
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	jmp .E2
.L2:
.E2:
	movq $0, %rax
	leave
	ret
