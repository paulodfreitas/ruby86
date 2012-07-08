.dseg
.global _ESP
.blk 40
.global _TID
.block 4
.global _N_THREADS
.block 4

jilix_pushall:
	pushl %eax
	pushl %ebx
	pushl %ecx
	pushl %edx
	pushl %ebp
	pushl %esi
	pushl %edi
	pushf
	ret

jilix_popall:
	popf
	popl %edi
	popl %esi
	popl %ebp
	popl %edx
	popl %ecx
	popl %ebx
	popl %eax
	ret


jilix_save_context:
	call jilix_pushall

	;saving old %esp into _ESP
	irmovl _ESP, %eax
	irmovl $0, %ebx
	mrmovl _TID(%ebx), %ebx
	irmovl $2, %ecx
	shrl %ecx, %ebx
	addl %ebx, %eax
	rmmovl %esp, (%eax)
	ret

jilix_change_tid:
	irmovl _TID, %eax
	mrmovl (%eax), %eax
	irmovl $1, %ebx
	addl %ebx, %eax
	rrmovl %eax, %ecx
	irmovl _N_THREADS, %edx
	mrmovl (%edx), %edx
	subl %edx, %ecx
	jne END
	irmovl $0, %eax
 END:
 	irmovl _TID, %ebx
 	rmmovl %eax, (%ebx)
 	ret

jilix_load_context:
	irmovl _ESP, %eax
	irmovl $0, %ebx
	mrmovl _TID(%ebx), %ebx
	irmovl $2, %ecx
	shrl %ecx, %ebx
	addl %ebx, %eax
	mrmovl (%eax), %esp

	call jilix_popall
	ret

jilix_schedule:
	jilix_save_context
	jilix_change_tid
	jilix_load_context
	ret

jilix_init:
	irmovl _N_THREADS, %eax
	irmovl $0, %ebx
	rmmovl %ebx, (%eax)

	irmovl _TID, %eax
	irmovl $0, %ebx
	rmmovl %ebx, (%eax)

	ret


;receives the new stack pointer in %esi and the function to be called in %edi
jilix_thread:
	irmovl $4, %eax
	subl %eax, %esp
	call jilix_save_context


	irmovl _N_THREADS, %eax
	mrmovl (%eax), %ecx
	irmovl $1, %ebx
	addl %ebx, %ecx
	rmmovl %ecx, (%eax)

	call jilix_change_tid

	rrmovl %esi, %esp
	pushl %edi
	ret