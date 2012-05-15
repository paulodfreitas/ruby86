.module entry_code
.pseg
.org 0
        irmovl $33, %edx
        irmovl $2, %ecx
        shrl %ecx, %edx
        shll %ecx, %edx
        shrl %ecx, %edx
        halt
.end
