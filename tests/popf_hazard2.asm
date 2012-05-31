.module m0
.pseg
    irmovl $100, %esp
    subl %eax, %eax
    popf
    pushf
	halt
.end
