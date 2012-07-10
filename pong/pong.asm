.module pong
.pseg

    jmp core_1
    jmp core_2

init_vars:
    irmovl $90000, %edi
    irmovl $b4, %eax
    rmmovl %eax, $0(%edi) ; bola.x = 180 = 360 / 2
    irmovl $78, %eax
    rmmovl %eax, $4(%edi) ; bola.y = 120 = 240 / 2
    irmovl $1, %eax
    rmmovl %eax, $8(%edi) ; velocidade.x = 1
    rmmovl %eax, $c(%edi) ; velocidade.y = 1
    irmovl $60, %eax
    rmmovl %eax, $10(%edi); pa_esquerda = 96
    rmmovl %eax, $14(%edi); pa_direita  = 96
    irmovl $1, %eax
    rmmovl %eax, $18(%edi); ready = 1
    ret

wait_init:
    irmovl $90000, %edi
    irmovl $1, %eax
wait_loop:
    mrmovl $18(%edi), %ebx
    subl %eax, %ebx
    jne wait_loop
    ret

desenha_bola:
    ; bola.y * 360 + bola.x
    mrmovl $4(%edi), %eax   ;bola.y
    irmovl $0, %ebx         ;i = 0
    irmovl $0, %ecx         ;mem_des = 0
    irmovl $168, %edx       ;mem_inc = 360
loop_multicacao:
    subl %eax, %ebx
    je exit_loop_mul        ; bola.y == i
    addl %eax, %ebx

    addl %edx, %ecx         ;mem_des += mem_inc
    incl %ebx               ;i++
    jmp loop_multicacao
exit_loop_mul:

    mrmovl $0(%edi), %eax   ;bola.x
    addl %eax, %ecx         ;mem_des += bola.x

    irmovl $ffffff, %eax    ;branco
    rmmovl %eax, $100000(%ecx)

    ret

passo_bola:
    ;call apaga_bola

                            ;anda eixo x
    mrmovl $0(%edi), %eax   ;bola.x
    mrmovl $8(%edi), %ecx   ;velocidade.x
    addl %ecx, %eax         ;bola.x += velocidade.x
    rmmovl %eax, $0(%edi)
                            ;anda eixo y
    mrmovl $4(%edi), %eax   ;bola.y
    mrmovl $c(%edi), %ecx   ;velocidade.y
    addl %ecx, %eax         ;bola.y += velocidade.y
    rmmovl %eax, $4(%edi)

    call desenha_bola
    ret

inverte_direcao:
    irmovl $1, %ebx
    subl %eax, %ebx
    je seta_um_neg         ; %eax == 1 ? %eax = -1 : %eax = 1
    ;jmp seta_um_pos       ; jmp nao necessario
seta_um_pos:
    irmovl $1, %eax
    ret
seta_um_neg:
    irmovl $0, %eax        ; nao sei escrever -1
    decl %eax
    ret

ver_col_borda:
    ;pega valor do eixo y da bola
    mrmovl $4(%edi), %eax

    ;borda superior
    irmovl $0, %ebx     ;0
    subl %eax, %ebx
    je colide_borda  ;bola.y == 0  'teto'

    ;borda inferior
    irmovl $d7, %ebx    ;215 = 240 - 1 - 24
    subl %eax, %ebx
    je colide_borda     ;bola.y == 215  'chao'

    ;sem colisoes
    ret

colide_borda:
    mrmovl $c(%edi), %eax
    call inverte_direcao
    rmmovl %eax, $c(%edi)
    ret

ver_col_pas:
    ;pega valor do eixo x da bola
    mrmovl $0(%edi), %eax

    ;pa esquerda
    irmovl $30, %ebx    ;48 = 2*24
    subl %eax, %ebx
    je colide_com_pa    ;bola.x == 48  pa_esquerda

    ;pa direita
    irmovl $137, %ebx   ;311 = 360 - 48 - 1
    subl %eax, %ebx
    je colide_com_pa    ;bola.x == 311  pa_direita

    ;sem colisoes
    ret

colide_com_pa:
    mrmovl $8(%edi), %eax
    call inverte_direcao
    rmmovl %eax, $8(%edi)
    ret

colisoes:
    call ver_col_borda
    call ver_col_pas
    ret


pa_sobe:
    incl %eax
    ret

pa_desce:
    irmovl $d7, %ecx
    subl %eax, %ecx
    je return_desce
    decl %eax
return_desce:
    ret

passo_pa:
    mrmovl $4(%edi), %ebx   ;bola.y
    subl %eax, %ebx
    je return
    jg call_pa_sobe
    jl call_pa_desce

call_pa_sobe:
    call pa_sobe
    ret
call_pa_desce:
    decl %eax
return:
    ret

;%eax pa.y
;%esi pa.x
desenha_pa:
    ; bola.y * 360 + bola.x
    irmovl $0, %ebx         ;i = 0
    irmovl $0, %ecx         ;mem_des = 0
    irmovl $168, %edx       ;mem_inc = 360
loop_mult2:
    subl %eax, %ebx
    je exit_loop_mlt       ; bola.y == i
    addl %eax, %ebx

    addl %edx, %ecx         ;mem_des += mem_inc
    incl %ebx               ;i++
    jmp loop_mult2
exit_loop_mlt:

    addl %esi, %ecx         ;mem_des += pa.x

    irmovl $ffffff, %eax    ;branco
    rmmovl %eax, $100000(%ecx)

    ret

passo_pa_esq:
    mrmovl $10(%edi), %eax  ;pa_esq.pos
    call passo_pa
    rmmovl %eax, $10(%edi)
    irmovl $18, %esi
    call desenha_pa
    ret

passo_pa_dir:
    mrmovl $14(%edi), %eax  ;pa_dir.pos
    call passo_pa
    rmmovl %eax, $14(%edi)
    irmovl $138, %esi
    call desenha_pa
    ret

core_1:
    irmovl $c0000, %esp
    call init_vars
    jmp loop_core_1
    halt

loop_core_1:
    call passo_bola
    call passo_pa_esq
    call colisoes
    jmp loop_core_1

loop_core_2:
    call passo_pa_dir
    jmp loop_core_2
    ;halt


core_2:
    irmovl $f0000, %esp
    irmovl $90000, %edi
    call wait_init
    jmp loop_core_2
    ;halt

.end
