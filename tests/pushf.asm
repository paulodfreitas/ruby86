.module m0
.pseg
;Teste da semantica da instrução Popf para o Y86
	irmovl $100,%esp
	irmovl $3,%eax
	pushl %eax
	pushf
	irmovl $80000000, %eax
	irmovl $ffffffff, %ebx
	addl %eax, %ebx
	popf
	popl %eax
	halt
.end
