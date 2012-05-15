.module entry_code
.pseg
.org 0
        irmovl $33, %eax
        irmovl $3000, %ebx
        rrmovl %eax, %ecx
        rmmovl %eax, 3(%ebx)
        mrmovl 3(%ebx), %edx
        halt
.end
