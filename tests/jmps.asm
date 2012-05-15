.module entry_code
.pseg
.org 0
        irmovl $1, %eax
        irmovl $2, %ebx
        jmp l1
        irmovl $2, %eax
l1:
        subl %ebx, %eax
        jle l2
        irmovl $2, %eax
l2:
        halt
.end
