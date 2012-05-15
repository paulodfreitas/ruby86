.module entry_code
.pseg
.org 0
        irmovl $33, %edx
        irmovl $2, %ecx
        shll %ecx, %edx
        shrl %ecx, %edx
        shll %ecx, %edx
        halt
.end
