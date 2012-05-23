.module entry_code
.pseg
.org 0
    irmovl $100, %esp
    call Proc
    irmovl $10, %edx
    halt
Proc:
    ret
    rrmovl %edx, %ebx
.end
