.module m0
.pseg
        irmovl $100, %esp
	pushl %esp  
	popl  %eax
	halt

.end
