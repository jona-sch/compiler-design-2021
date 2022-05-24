.data
intout: .asciz "%ld "
strout: .asciz "%s "
errout: .asciz "Wrong number of arguments"
STR0: 	.asciz "Testing if printf format codes are left alone."
STR1: 	.asciz "\nOutput *should* contain percent characters, but no integers."
STR2: 	.asciz "\tHello, world! %d %d"
STR3: 	.asciz "Adding a splash of ANSI color codes - This will only work in a color terminal"
STR4: 	.asciz "\t\033[31mRed"
STR5: 	.asciz "\t\033[32mGreen"
STR6: 	.asciz "\t\033[34mBlue"
STR7: 	.asciz "\033[0m"


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
	call	_escapecodes
	jmp END
ABORT:
	leaq errout(%rip), %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_escapecodes:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	xor %eax, %eax
	leaq STR0(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	leaq STR1(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	# begin assignment of a
	movq $64, %rax
	# address for a (local_var_0) is -8(%rbp) because func->nparms of escapecodes is 0
	movq %rax, -8(%rbp)
	# begin assignment of b
	movq $42, %rax
	# address for b (local_var_1) is -16(%rbp) because func->nparms of escapecodes is 0
	movq %rax, -16(%rbp)
	xor %eax, %eax
	leaq STR2(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR3(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR4(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR5(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	xor %eax, %eax
	leaq STR6(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	leaq STR7(%rip), %rsi
	leaq strout(%rip), %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
