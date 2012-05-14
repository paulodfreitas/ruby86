.module entry_code
.pseg
.org 0
        irmovl $3, %edx
        incl %edx
        incl %edx
        incl %edx
        halt
.end
