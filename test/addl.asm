.module entry_code
.pseg
.org 0
        irmovl $3, %eax
        irmovl $4, %ebx
        addl %eax, %ebx
        halt
.end
