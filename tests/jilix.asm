.module entry_code
.pseg
.org 0

test:
    irmovl $100000, %esp
	call j_init

	irmovl $1, %eax
	irmovl $f0000, %ebx
	irmovl thread1, %ecx
	call j_thread

	irmovl $2, %eax
    irmovl $e0000, %ebx
    irmovl thread2, %ecx
    call j_thread

    irmovl $3, %eax
    irmovl $d0000, %ebx
    irmovl thread3, %ecx
    call j_thread
LOOP:
    irmovl $666, %ebx
	call j_schedule
	jmp LOOP

thread1:
    irmovl $112358, %ecx
    call j_schedule
    jmp thread1

thread2:
    irmovl $f0f0, %esi
    call j_schedule
    ret

thread3:
    irmovl $1, %ecx
INF:
    irmovl $9, %ebx
    subl %ecx, %ebx
    je FORA
    irmovl $1, %esi
    addl %esi, %ecx
    call j_schedule
    jmp INF
FORA:
    ret


;%eax: endereço base 
;%ebx: offset
;%ecx: valor
set_vector:
	pushl %edx
	irmovl $2, %edx
	shll %edx, %ebx
	addl %ebx, %eax
	rmmovl %ecx, 0(%eax)
	popl %edx
	ret

;%eax: endereço base
;%ebx: offset
get_vector:
	pushl %ecx
	irmovl $2, %ecx
	shll %ecx, %ebx
	addl %ebx, %eax
	mrmovl 0(%eax), %eax
	popl %ecx
	ret

j_exit:
	;achando NEXT[tid]
	irmovl _NEXT, %eax
	irmovl $0, %ebx
	mrmovl _TID(%ebx), %ebx
	rrmovl %ebx, %ebp ;criando uma copia do tid da thread que sera deletada
	call get_vector

	;tid= NEXT[tid] 
	irmovl $0, %ebx
	rmmovl %eax, _TID(%ebx)

	;%edx = NEXT[tid]
	rrmovl %eax, %edx

	;Achar thread k tal que NEXT[k] = tid. 
	irmovl $0, %ecx
BLOCK:
	irmovl _NEXT, %eax
	rrmovl %ecx, %ebx
	call get_vector
	subl %ebp, %eax
	je END_LOOP
	irmovl $1, %eax
	addl %eax, %ecx
	jmp BLOCK
END_LOOP:
	;Fazer NEXT[k] = NEXT[tid]. k está guardado em %ecx
	irmovl _NEXT, %eax
	rrmovl %ecx, %ebx
	rrmovl %edx, %ecx
	call set_vector

	;carregando o pŕoximo %esp de _ESP
	irmovl _ESP, %eax
	rrmovl %edx, %ebx
	call get_vector
	rrmovl %eax, %esp

	;restaurando registradores
	popl %eax
	popl %ebx
	popl %ecx
	popl %edx
	popl %ebp
	popl %esi
	popl %edi
	popf

	ret

;%eax: thread_id
;%ebx: stack pointer
;%ecx: function_ptr
j_thread:
	;salvando registradores
	pushf
	pushl %edi
	pushl %esi
	pushl %ebp

	pushl %edx
	pushl %ecx
	pushl %ebx
	pushl %eax

	;carregando o _TID
	irmovl $0, %edx
	mrmovl _TID(%edx), %edx

	;_TID = tid
	irmovl $0, %ecx
	rmmovl %eax, _TID(%ecx)

	;achando NEXT[old_tid]
	irmovl _NEXT, %eax
	rrmovl %edx, %ebx
	call get_vector

	;NEXT[tid] = NEXT[old_tid]
	rrmovl %eax, %ecx
	irmovl _NEXT, %eax
	popl %ebx ;obtendo %eax original que corresponde ao thread id passado como parâmetro
	rrmovl %ebx, %ebp ;criando uma cópia pois seu conteudo será destruido durante a execução da função set_vector
	call set_vector
	pushl %ebx

	;NEXT[old_tid] = tid
	irmovl _NEXT, %eax
	rrmovl %edx, %ebx
	rrmovl %ebp, %ecx ;%ebp = tid
	call set_vector

	;ESP[old_tid] = %esp
	irmovl _ESP, %eax
	rrmovl %edx, %ebx
	rrmovl %esp, %ecx
	call set_vector

	;removendo %eax do stack
	popl %eax 

	;recuperando stack_pointer passado como argumento 
	popl %ebx

	;recuperando function pointer passado como argumento
	popl %ecx

	;setando o novo %esp
	rrmovl %ebx, %esp

	;adicionando o destino de retorno da função (j_exit)
	irmovl j_exit, %eax
	pushl %eax

	;chamando a função passada como argumento
	pushl %ecx
	ret

j_init:
	pushl %eax

	;setando _TID como 0
	irmovl $0, %eax
	rmmovl %eax, _TID(%eax)

	;setando _NEXT[0] como 0
	rmmovl %eax, _NEXT(%eax)

	popl %eax

	ret

j_schedule:
	;salvando registradores
	pushf
	pushl %edi
	pushl %esi
	pushl %ebp
	pushl %edx
	pushl %ecx
	pushl %ebx
	pushl %eax

	;guardando %esp no vetor _ESP
	irmovl _ESP, %eax
	irmovl _TID, %ebx
	mrmovl 0(%ebx), %ebx
	rrmovl %esp, %ecx
	call set_vector

	;achando o próximo _TID
	irmovl _NEXT, %eax
	irmovl _TID, %ebx
	mrmovl 0(%ebx), %ebx
	call get_vector

	;alterando o _TID
	irmovl _TID, %ebx
	rmmovl %eax, 0(%ebx)

	;carregando o pŕoximo %esp de _ESP
	rrmovl %eax, %ebx
	irmovl _ESP, %eax
	call get_vector
	rrmovl %eax, %esp

	;restaurando registradores
	popl %eax
	popl %ebx
	popl %ecx
	popl %edx
	popl %ebp
	popl %esi
	popl %edi
	popf

	ret

.dseg
.global _TID
.blk 4
.global _NEXT
.blk 40		
.global _ESP
.blk 40	

.end
