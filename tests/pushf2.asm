.module m0
.pseg
    irmovl $100, %esp
    pushf
    subl %eax, %eax
	halt
.end
