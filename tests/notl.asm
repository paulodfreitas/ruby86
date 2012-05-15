.module entry_code
.pseg
.org 0
        irmovl $3, %edx
        notl %edx
        halt
.end
