.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Parameter s is"
STR1: 	.asciz "t is "


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
	call	_defall
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_defall:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	subq $8, %rsp
	# begin assignment of x
	movq $5, %rax
	movq %rax, %rdi
	movq $10, %rax
	movq %rax, %rsi
	callq _my_deftion
	# address for x (local_var_0) is -8(%rbp) because func->nparms of defall is 0
	movq %rax, -8(%rbp)
	movq $0, %rax
	leave
	ret
_my_deftion:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	subq $16, %rsp
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for s (param_0) is -8(%rbp).
	movq -8(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	# address for t (param_1) is -16(%rbp).
	movq -16(%rbp), %rax
	movq %rax, %rsi
	leaq intout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
