.module m0
.pseg
;Teste da semantica da instrução Popl para o Y86
	irmovl $100,%esp  
	irmovl $ABCD,%eax 
	pushl  %eax         
	popl   %esp         
	halt
.end
