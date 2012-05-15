.module entry_code
.pseg
.org 0
        irmovl $3, %edx
        irmovl $c, %ebx
        xorl %edx, %ebx
        halt
.end
