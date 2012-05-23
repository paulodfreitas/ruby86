.module entry_code
.pseg
.org 0
        irmovl $3000, %eax
        subl %eax, %eax
        jne if
else:
        irmovl $1, %ecx
        jmp end
if:
        irmovl $0, %ecx
end:
        halt
.end
