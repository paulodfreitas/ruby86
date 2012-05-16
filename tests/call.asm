.module m0
.pseg
	irmovl $100,%esp
	irmovl $5, %eax
	irmovl $10, %ebx
	call my_func
	irmovl $3, %ebx
	call my_func
	halt

my_func:
    addl %ebx, %eax
    ret
.end
