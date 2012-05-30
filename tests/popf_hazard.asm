.module m0
.pseg
    irmovl $100, %esp
    pushf
	subl %eax, %eax
	popf
	je if
else:
    irmovl $1, %ecx
    jmp end
if:
    irmovl $0, %ecx
end:
	halt
.end
