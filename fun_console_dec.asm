#.include "mac_syscall.asm"
#main:
#li a0, 237
#call division
#exit a0

read_decimal:
		addi 	sp, sp, -16 
		sw 	s1, 0(sp)
		sw 	s2, 4(sp)
		sw 	s3, 8(sp)
		sw 	ra, 12(sp)
		
		li 	s1, 0 #ответ
		li 	s2, 0 #знак
		li 	s3, 0 
while_rd: 	bgt	s3, s1, error_rd_1
		li	t0, 0xCCCCCCC
		bgt	s1, t0, nw_overflow_rd	 
		readch
		mv 	s3, s1
		li 	t0, '\n'
		beq 	a0, t0, end_while_rd
		li	t0, '-'
		beq	a0, t0, minus
		li 	a1, 0x30
		li	a2, 0x39
		li	a3, -0x30 
		call 	convert_number
		mv 	a1, s1
		mv 	s1, a0
		li	a0, 10
		call	multiply
		add	s1, a0, s1  
		j	while_rd
minus: 		bnez	s1, error_rd_1
		bnez	s2, error_rd_1
		li 	s2, 1
		j	while_rd
nw_overflow_rd: printchi '\n'
end_while_rd:	beqz 	s2, end_rd 	
		xori  	s1, s1, -1
		addi	s1, s1, 1
		
end_rd: 	mv 	a0, s1
		lw	s1, 0(sp)
		lw	s2, 4(sp)
		lw	s3, 8(sp)
		lw 	ra, 12(sp)
		addi	sp, sp, 16 
		ret
error_rd_1: error "ERROR: ", a0


print_decimal:
		addi sp, sp -16
		sw 	s0, 0(sp)
		sw 	s1, 4(sp)
		sw 	s2, 8(sp)
		sw 	ra, 12(sp)
		addi 	sp, sp, -12
		mv   	s0, sp
		mv   	s1, a0
		
		srli 	t0, a0, 31
		beqz 	t0, while_pd
		printchi '-'
		addi 	s1, s1, -1
		xori 	s1, s1, -1
		mv 	a0, s1
while_pd:	beqz 	s1, while_end_pd
		call 	div_start
		mv 	s2, a0
		li 	a1, 10
		call 	multiply
		sub 	a0, s1 ,a0
		li 	a1, 0x0
		li 	a2, 0x9
		li 	a3, 0x30
		call 	convert_number
		sb 	a0 0(s0)
		addi 	s0, s0, 1
		mv 	s1, s2
		mv 	a0, s2
		j 	while_pd
while_end_pd:	mv 	t5, s0
while_print_pd: bgt 	sp, t5, end_pd
		lb 	a0, (t5)
		addi 	t5, t5, -1
		printch a0
		j 	while_print_pd
end_pd: 	addi	sp, sp, 12
		lw 	s0, 0(sp)
		lw 	s1, 4(sp)
		lw 	s2, 8(sp)
		lw 	ra, 12(sp)
		addi 	sp, sp 16 
		ret

.include "fun_convert_number.asm"
.include "fun_multiply.asm"
.include "fun_division.asm"
