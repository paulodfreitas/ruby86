.module m0
.pseg
;Teste da semantica da instrução Popf para o Y86
	irmovl $100,%esp
	irmovl $3,%eax
	pushf
	pushl %eax
	irmovl $80000000, %eax
	irmovl $ffffffff, %ebx
	addl %eax, %ebx
	popl %ecx
	popf
	halt
.end
