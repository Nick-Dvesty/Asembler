.include "mac_syscall.asm"
.text
main:
		call	read_number
		mv 	s0, a0
		call 	read_number
		mv 	s1, a0
		readch
		mv 	a2, a0
		mv 	a0, s0
		mv 	a1, s1
		call 	bcd_calc
		mv 	s2, a0
		printchi '\n'
		mv 	a0, s2
		call 	print_number
		exit 	a0

bcd_calc:# int bcd_calc(int a0, int a1,char a2)
		#performs various operations on a0 and a1 depending on a2. The result is written to a0
		li 	t0, '+'
		beq	a2, t0, calc_prog_sum
		li 	t0, '-'
		beq 	a2, t0, calc_prog_sub
		error "ERROR: This operation is not defined", a3
end_calc: exit a0
#--------
calc_prog_sum:  #int calc_prog_sum(int a0, int a1)
		addi sp, sp -12
		sw ra, 0(sp)
		sw s0, 4(sp)
		sw s1, 8(sp)
		
		srli s0, a0, 28
		srli s1, a1, 28
		slli s0, s0, 28
		slli s1, s1, 28
		slli a0, a0, 4
		slli a1, a1, 4
		srli a0, a0, 4
		srli a1, a1, 4
		beq s0, s1, eq_cps
		beqz s0, a1_less_cps
		
a0_less_cps:	swap a0, a1
		call calc_prog_sub
		j end_cps
a1_less_cps:	call calc_prog_sub
		j end_cps
eq_cps:		call calc_add
		add a0, a0, s0 
		j end_cps
		
end_cps: 	lw ra, 0(sp)
		lw s0, 4(sp)
		lw s1, 8(sp)
		addi sp, sp 12
		ret

#----------------
calc_prog_sub:  #int calc_prog_sub(int a0, int a1)
		addi 	sp, sp -12
		sw 	ra, 0(sp)
		sw 	s0, 4(sp)
		sw 	s1, 8(sp)
		
		srli 	s0, a0, 28
		srli 	s1, a1, 28
		slli 	s0, s0, 28
		slli 	s1, s1, 28
		slli 	a0, a0, 4
		slli 	a1, a1, 4
		srli 	a0, a0, 4
		srli 	a1, a1, 4
		
		beqz 	s0, pm 
mm:		beqz 	s1, mp
		swap 	a0, a1
		call 	calc_sub
		j 	end_cpsu
mp:		call 	calc_add
		add  	a0, a0, s0		
		j 	end_cpsu
pm:		beqz 	s1, pp
		call 	calc_add
		j 	end_cpsu
pp:		call 	calc_sub
		j 	end_cpsu
		
end_cpsu: 	lw 	ra, 0(sp)
		lw 	s0, 4(sp)
		lw 	s1, 8(sp)
		addi 	sp, sp 12
		ret
calc_add: #int calc_add(int a0, int a1)
		#
		li 	t0, 8 # - счётчик
		li 	t1, 0 # - счётчик сдвига
		li 	t2, 0 # - переход на следующий разряд
		li 	a2, 0 # - результат
for_ca:		beqz 	t0, for_end_ca
		srl	t3, a0, t1
		srl	t4, a1, t1
		andi 	t3, t3, 15
		andi 	t4, t4, 15
		add 	t5, t3, t4
		add	t5, t5, t2
		slti	t2, t5, 10
		xor	t2, t2,	1 
		beqz	t2, general_ca	
		addi	t5, t5, -10	
general_ca:	sll 	t5, t5, t1
		add 	a2, a2, t5
		addi 	t0, t0, -1
		addi	t1, t1, 4
		j	for_ca
for_end_ca: 	
		li 	t0, 0x10000000
		bge 	a2, t0, error_ca_1
		mv 	a0, a2
		ret
error_ca_1:	error "\nERROR: register overflow", a2
	
#-------- 
calc_sub: #int calc_sub(int a0, int a1)
		#
		li 	t0, 8 # - счётчик
		li 	t1, 0 # - счётчик сдвига
		li 	t2, 0 # - переход на следующий разряд
		li 	a2, 0 # - результат
		
		li	a3, 0
		slli	a1, a1, 4
		slli	a2, a2, 4	
		srli	a1, a1, 4
		srli	a2, a2, 4
		bge	a0, a1, for_cb
		swap 	a0, a1
		li 	a3, 0x80000000
						
for_cb:		beqz 	t0, for_end_cb
		srl	t3, a0, t1
		srl	t4, a1, t1
		andi 	t3, t3, 15
		andi 	t4, t4, 15
		sub 	t5, t3, t4
		sub	t5, t5, t2
		slti	t2, t5, 0
		beqz	t2, general_cb	
		addi	t5, t5, 10	
general_cb:	sll 	t5, t5, t1
		add 	a2, a2, t5
		addi 	t0, t0, -1
		addi	t1, t1, 4
		j	for_cb
for_end_cb: 
		add 	a0, a2, a3
		ret

.include "fun_convert_number.asm"
.include "fun_console_bcd.asm"
