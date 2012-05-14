.module entry_code
.pseg
.org 0
        irmovl $c, %eax
        irmovl $6, %edx
        andl %eax, %edx
        halt
.end
