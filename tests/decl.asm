.module entry_code
.pseg
.org 0
        irmovl $3, %edx
        decl %edx
        decl %edx
        decl %edx
        decl %edx
        decl %edx
        halt
.end
