.module entry_code
.pseg
.org 0
        irmovl $0, %ecx
        jmp l1
        irmovl $1, %ecx
l1:
        irmovl $1, %eax
        irmovl $2, %ebx
        subl %ebx, %eax
        jle l2
        irmovl $2, %ecx
l2:
        irmovl $1, %eax
        irmovl $2, %ebx
        subl %ebx, %eax
        jl l3
        irmovl $3, %ecx
l3:
        subl %ebx, %ebx
        je l4
        irmovl $4, %ecx
l4:
        irmovl $1, %eax
        irmovl $2, %ebx
        subl %ebx, %eax
        jne l5
        irmovl $5, %ecx
l5:
        irmovl $1, %eax
        irmovl $2, %ebx
        subl %eax, %ebx
        jge l6
        irmovl $6, %ecx
l6:
        irmovl $1, %eax
        irmovl $2, %ebx
        subl %eax, %ebx
        jg l7
        irmovl $7, %ecx
l7:
        halt
.end
