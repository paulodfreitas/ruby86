.module entry_code
.pseg
.org 0
        irmovl $11235, %eax
        irmovl $0, %edx
        orl %eax, %edx
        halt
.end
