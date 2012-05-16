.module entry_code
.pseg
.org 0
        irmovl $7fffffff, %edx
        incl %edx
        incl %edx
        incl %edx
        halt
.end
