.module paint
.pseg

    jmp core_1
    jmp core_2

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

loop:
    jmp loop


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

core_1:
    irmovl $c0000, %esp     ;call stack
    irmovl $100000, %ecx    ;video offset

    irmovl $0, %edx         ;%edx = 0
    addl %ecx, %edx

    irmovl $18, %eax        ;x = 24
    irmovl $18, %ebx        ;y = 24
    call cor_ret_x_y;


    jmp loop
    halt

core_2:
    halt

.end
