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

apaga_bola:
    mrmovl $0(%edi), %eax   ;bola.x
    mrmovl $4(%edi), %ebx   ;bola.y
    call des_qua_x_y
    ret

desenha_bola:
    mrmovl $0(%edi), %eax   ;bola.x
    mrmovl $4(%edi), %ebx   ;bola.y
    call cor_qua_x_y
    ret


passo_bola:
    call apaga_bola

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
    irmovl $120, %ebx   ;288 = 360 - 72
    subl %eax, %ebx
    je colide_com_pa    ;bola.x == 288  pa_direita

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

;proxie to des_ret_x_y
apaga_pa:
    jmp des_ret_x_y

;proxie to cor_ret_x_y
desenha_pa:
    jmp cor_ret_x_y

passo_pa_esq:
    irmovl $18, %eax        ;pa.x = 24
    mrmovl $10(%edi), %ebx  ;pa.y
    call apaga_pa

    mrmovl $10(%edi), %eax  ;pa_esq.pos
    call apaga_pa
    call passo_pa
    rmmovl %eax, $10(%edi)

    irmovl $18, %eax        ;pa.x = 24
    mrmovl $10(%edi), %ebx  ;pa.y
    call desenha_pa
    ret

passo_pa_dir:
    irmovl $138, %eax       ;pa.x = 360 - 48 = 312
    mrmovl $14(%edi), %ebx  ;pa.y
    call apaga_pa

    mrmovl $14(%edi), %eax  ;pa_dir.pos
    call passo_pa
    rmmovl %eax, $14(%edi)

    irmovl $138, %eax       ;pa.x = 360 - 48 = 312
    mrmovl $14(%edi), %ebx  ;pa.y
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

;%eax = x
;%ebx = y
;%edx = pos = 4(360y + x)
init_position:

    irmovl $0, %edx ; %ecx = 0
    addl %eax, %edx ; %ecx = x

    irmovl $3, %ecx
    shll %ecx, %ebx ; %ebx = 8y
    addl %ebx, %edx ; %edx = 8y + x

    irmovl $2, %ecx
    shll %ecx, %ebx ; %ebx = 4(8y) = 32y
    addl %ebx, %edx ; %edx = 32y + 8y + x = 40y +x

    irmovl $1, %ecx
    shll %ecx, %ebx ; %ebx = 2(32y) = 64y
    addl %ebx, %edx ; %edx = 40y + 64y + x = 104y + x

    irmovl $2, %ecx
    shll %ecx, %ebx ; %ebx = 4(64y) = 256y
    addl %ebx, %edx ; %edx = 104y + 256y + z = 360y + x

    shll %ecx, %edx ; %edx = 4(360y + x)    ;4 bytes = 1pixel

    irmovl $8, %ecx
    shrl %ecx, %ebx ; %ebx = 256y/256 = y

    ret

;%ecx = cor
;%edx = mem_init_dest
;%esi = nr_cols || row length
colore_ecx_edx:
    rmmovl %ecx, $100000(%edx)
    rmmovl %ecx, $100004(%edx)
    rmmovl %ecx, $100008(%edx)
    rmmovl %ecx, $10000c(%edx)
    rmmovl %ecx, $100010(%edx)
    rmmovl %ecx, $100014(%edx)
    rmmovl %ecx, $100018(%edx)
    rmmovl %ecx, $10001c(%edx)
    rmmovl %ecx, $100020(%edx)
    rmmovl %ecx, $100024(%edx)
    rmmovl %ecx, $100028(%edx)
    rmmovl %ecx, $10002c(%edx)
    rmmovl %ecx, $100030(%edx)
    rmmovl %ecx, $100034(%edx)
    rmmovl %ecx, $100038(%edx)
    rmmovl %ecx, $10003c(%edx)
    rmmovl %ecx, $100040(%edx)
    rmmovl %ecx, $100044(%edx)
    rmmovl %ecx, $100048(%edx)
    rmmovl %ecx, $10004c(%edx)
    rmmovl %ecx, $100050(%edx)
    rmmovl %ecx, $100054(%edx)
    rmmovl %ecx, $100058(%edx)
    rmmovl %ecx, $10005c(%edx)


    addl %esi, %edx
    ret

;%ecx = cor
;%edx = mem_init_dest
colore_quadrado:
    irmovl $5a0, %esi   ; %esi = 4*(360) = 1440

    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    call colore_ecx_edx
    ret

;eax = x
;ebx = y
descolore_x_y:
    call init_position      ;%edx = mem_pos
    irmovl $000000, %ecx    ; preto
    call colore_quadrado
    ret

;eax = x
;ebx = y
colore_x_y:
    call init_position      ;%edx = mem_pos
    irmovl $ffffff, %ecx    ; branco
    call colore_quadrado
    ret

cor_qua_x_y:
    jmp colore_x_y

des_qua_x_y:
    jmp descolore_x_y

cor_ret_x_y:
    call colore_x_y

    irmovl $18, %ecx
    addl %ecx, %ebx     ;y += 24
    call colore_x_y

    irmovl $18, %ecx
    addl %ecx, %ebx
    call colore_x_y
    ret

des_ret_x_y:
    call descolore_x_y

    irmovl $18, %ecx
    addl %ecx, %ebx     ;y += 24
    call descolore_x_y

    irmovl $18, %ecx
    addl %ecx, %ebx
    call descolore_x_y
    ret


.end
