.include "mac_syscall.asm"

.text
main:
		call	read_number
		mv 	s0, a0
		call	read_number
		mv 	s1, a0
		readch
		mv 	a2, a0
		mv 	a0, s0
		mv 	a1, s1
		call 	hex_calc
		mv 	s2, a0
		printchi '\n'
		mv 	a0, s2
		call 	print_number
exit:		exit 	a0
#--------
read_number: #int read_number ()
		#writes a number from the console to the a0 register
		addi 	sp, sp, -12
		sw	ra, 0(sp)
		sw	s0, 4(sp)
		sw	s1, 8(sp)
		
		li 	s0, 0
		li 	s1, 8
while_rn:	readch
		li 	t0, 10
		beq 	a0, t0, end_rn
		beqz	s1, error_rn_1
cap_char_rn:	li	a1, 0x61
		li 	a2, 0x66
		li 	a3, -0x57
		blt 	a0, a1, not_cap_char_rn
		j	general_rn
not_cap_char_rn:li 	a1, 0x41
		li 	a2, 0x46
		li 	a3, -0x37
	 	blt 	a0, a1 not_sm_char_rn
	 	j 	general_rn
not_sm_char_rn: li 	a1, 0x30
		li 	a2, 0x39
		li 	a3, -0x30
general_rn:	call	convert_number
		slli	s0, s0, 4
		add	s0, s0, a0
		addi	s1, s1, -1
		j 	while_rn	
		
end_rn:		mv	a0, s0
		lw	ra, 0(sp)
		lw	s0, 4(sp)
		lw	s1, 8(sp)
		addi	sp, sp, 12
 		ret
error_rn_1: error "\nERROR: variable overflow", a0
#--------
print_number:#void print_number (int a0)
		#outputs the number in a0 to the console
		addi 	sp, sp, -12
		sw	ra, 0(sp)
		sw	s0, 4(sp)
		sw	s1, 8(sp)
		
		mv 	s0, a0
		li 	s1, 32
do_while_pn:	beqz	s1, end_pn	
		addi	s1,s1,-4 
		srl 	a0, s0,s1
		andi 	a0, a0, 15
		li 	a1, 0
		li 	a2, 9
		li 	a3, 0x30
		ble	a0, a2 general_pn 
		li 	a1, 10
		li 	a2, 15
		li 	a3, 0x37
general_pn:	call 	convert_number
		printch a0
		j 	do_while_pn
		
end_pn:		lw	ra, 0(sp)
		lw	s0, 4(sp)
		lw	s1, 8(sp)
		addi	sp, sp, 12
		ret
#--------
hex_calc:# int hex_calc(int a0, int a1, char a2)
		#performs various operations on a0 and a1 depending on a2. The result is written to a0
		li 	t0, '+'
		beq	a2, t0, calc_add
		li 	t0, '-'
		beq 	a2, t0, calc_sub
		li 	t0, '|'
		beq 	a2, t0, calc_dis
		li 	t0, '&'
		beq 	a2, t0, calc_con
		error "ERROR: This operation is not defined", a2
calc_add:	add 	a0, a0, a1
		ret
calc_sub:	sub 	a0, a0, a1
		ret
calc_dis:	or 	a0, a0, a1
		ret
calc_con:	and	a0, a0, a1
		ret

.include "fun_convert_number.asm"
