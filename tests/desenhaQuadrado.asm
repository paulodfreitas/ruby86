.module entry_code
.pseg
.org 0

main:
    irmovl $100, %eax
    irmovl $100, %ebx
    irmovl $50, %ecx
    irmovl $50, %edx
    call dq_branco
LOOP:
    jmp LOOP

;%eax: x
;%ebx: y
;%ecx: largura
;%edx: altura
dq_branco:
	irmovl 0, %edi
	irmovl $10000, %esi
	rmmovl %esi, _VIDEO(%edi)

	;%esi = 256*y
	rrmovl %ebx, %esi
	irmovl $8, %edi
	shll %edi, %esi

	;%edi = 64*y
	rrmovl %ebx, %edi
	irmovl $6, %ebp
	shll %ebp, %edi

	;%esi = 256*y + 64*y + x = 320*y + x. Representa o indice atual.
	addl %edi, %esi
	addl %eax, %esi

	;calculando limite superior do indice do loop externo
	;%edi = 320 * y + 320 * altura + x = %esi + 320 * altura

	;%edi = 64 * altura
	irmovl $6, %ebp
	rrmovl %edx, %edi
	shll %ebp, %edi

	;%ebp = 256 * altura
	pushl %eax
	irmovl $8, %eax
	rrmovl %edx, %ebp
	shll %eax, %ebp
	popl %eax

	;%edi = 320 * y + 320 * altura + x = %esi + 320 * altura
	addl %ebp, %edi
	addl %esi, %edi
	irmovl $1, %ebp
	addl %ebp, %edi
EXTERNO:
	rrmovl %edi, %ebp ;criando uma copia para nao perde-lo na instrução abaixo
	subl %esi, %ebp
	je END
	;calculando o limite da linha. %ebp
	rrmovl %esi, %ebp
	addl %ecx, %ebp
	pushl %eax
	irmovl $1, %eax
	addl %eax, %ebp
	popl %eax
INTERNO:
	pushl %eax
	rrmovl %ebp, %eax
	subl %esi, %eax
	popl %eax
	je ALE
	pushl %eax
	irmovl _VIDEO, %eax
	pushl %esi
	pushl %edi
	irmovl $2, %edi
	shll %edi, %esi
	addl %esi, %eax
	irmovl $abcd, %esi ;cor
	rmmovl %esi, 0(%eax)
	popl %edi
	popl %esi
	popl %eax
ALI:
	pushl %eax
	irmovl $1, %eax
	addl %eax, %esi
	popl %eax
	jmp INTERNO
ALE:
    pushl %eax
    irmovl $140, %eax
	addl %eax, %esi ;aumenta o indice em LARGURA_TELA
	popl %eax
	subl %edx, %esi ;e subtrai a largura de forma a voltar ao inicio da linha
	jmp EXTERNO
END:
	ret

.dseg
.global _VIDEO
.blk 4
.global _LARGURA_TELA
.blk 4

.end
