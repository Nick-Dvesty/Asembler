# IN PROGRESS, NOT RWORK
.include "mac_syscall.asm"

.text
main:
#call read_number
#call print_number
li a0, 0x500
li a1, 0x1
li a2, 1
li a3, 1
call calc_prog_sum
call print_number
exit a0

bcd_calc:# int hex_calc(char a0, int a1, int a2, signed a3, signed a4)
		#performs various operations on a1 and a2 depending on a3. The result is written to a0
		mv s0, a3
		mv s1, a4
		li 	t0, '+'
		#beq	a3, t0, calc_prog
		li 	t0, '-'
		#beq 	a3, t0, calc_sub2
		error "ERROR: This operation is not defined", a3
end_calc: exit a0


#----------
calc_prog_sum:# int hex_calc(int a0, int a1, signed a2, signed a3)
		addi sp, sp -20
		sw ra, 0(sp)
		sw s0, 4(sp)
		sw s1, 8(sp)
		sw s2, 12(sp)
		sw s3, 16(sp)
		
		mv s0, a0
		mv s1, a1
		mv s2, a2
		mv s3, a3
				
		beq s2, s3, eq
		beqz s2, minus_s3
minus_s2:	
		mv a0, s1
		mv a1, s0
		li a2, 0
		call calc_prog_sub
		j exit_cps
minus_s3:		
		li a3, 0
		call calc_prog_sub
		j exit_cps
eq:		
		call calc_add
		mv a1, s2

exit_cps: 	
		lw ra, 0(sp)
		lw s0, 4(sp)
		lw s1, 8(sp)
		lw s2, 12(sp)
		lw s3, 16(sp)
		addi sp, sp 20
		ret

#----------
calc_prog_sub:# int hex_calc(int a0, int a1, signed a2, signed a3)

		addi sp, sp -20
		sw ra, 0(sp)
		sw s0, 4(sp)
		sw s1, 8(sp)
		sw s2, 12(sp)
		sw s3, 16(sp)
		
		mv s0, a0
		mv s1, a1
		mv s2, a2
		mv s3, a3
				
		bnez s2, mp
pp:		bnez s3, pm
		
		j exit_cpss
					
pm:		li a3, 0
		call calc_prog_sum
		li a1, 0
		j exit_cpss
		
mp:		bnez s3, mm
		li a2, 0
		call calc_prog_sum
		li a1, 1
		j exit_cpss
		
mm:		
		j exit_cpss

exit_cpss: 	
		lw ra, 0(sp)
		lw s0, 4(sp)
		lw s1, 8(sp)
		lw s2, 12(sp)
		lw s3, 16(sp)
		addi sp, sp 20
		ret

#--------
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
		slti	t2, t5,10
		not	t2, t2
		andi	t2, t2, 1 
		beqz	t2, general_ca	
		addi	t5, t5, -10	
general_ca:	sll 	t5, t5, t1
		add 	a2, a2, t5
		addi 	t0, t0, -1
		addi	t1, t1, 4
		j	for_ca
for_end_ca: 
		mv 	a0, a2
		ret
#-------- 
calc_sub: #int calc_sub(int a0, int a1)
		#
		li 	t0, 8 # - счётчик
		li 	t1, 0 # - счётчик сдвига
		li 	t2, 0 # - переход на следующий разряд
		li 	a2, 0 # - результат
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
		mv 	a0, a3
		ret

.include "fun_convert_number.asm"
.include "fun_console_bcd.asm"
