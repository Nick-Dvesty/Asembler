#--------
read_number: #int read_number ()
		#writes a number from the console to the a0 register and write to a1 signed
		addi 	sp, sp, -16
		sw	ra, 0(sp)
		sw	s0, 4(sp)
		sw	s1, 8(sp)
		sw	s2, 12(sp)
		
		li 	s0, 0
		li 	s1, 7
		li 	s2, 0
while_rn:	readch
		li 	t0, 10
		beq 	a0, t0, end_rn
		li 	t0, '-'
		beq 	a0, t0, minus_rn
		beqz	s1, error_rn_1

		li 	a1, 0x30
		li 	a2, 0x39
		li 	a3, -0x30
		call	convert_number
		slli	s0, s0, 4
		add	s0, s0, a0
		addi	s1, s1, -1
		j 	while_rn
minus_rn:	li 	t0, 7
		bne	s1, t0, error_rn_2
		bnez	s2, error_rn_2
		li	s2, 0x80000000
		j	while_rn
		
end_rn:		add	a0, s0, s2
		lw	ra, 0(sp)
		lw	s0, 4(sp)
		lw	s1, 8(sp)
		lw	s2, 12(sp)
		addi	sp, sp, 16
 		ret
error_rn_1: error "\nERROR: variable overflow", a0
error_rn_2: error "\nERROR: invalid value entered", a0

#--------
print_number:#void print_number (int a0, int a1)
		#outputs the number in a0 to the console
		addi 	sp, sp, -16
		sw	ra, 0(sp)
		sw	s0, 4(sp)
		sw	s1, 8(sp)
		sw	s2, 12(sp)
		
		mv 	s0, a0
		srli	a1, a0, 28
		li 	s1, 28
		beqz	a1, do_while_pn
		printchi '-'
do_while_pn:	beqz	s1, end_pn	
		addi	s1,s1,-4 
		srl 	a0, s0,s1
		andi 	a0, a0, 15
		li 	a1, 0
		li 	a2, 9
		li 	a3, 0x30
general_pn:	call 	convert_number
		printch a0
		j 	do_while_pn
		
end_pn:		lw	ra, 0(sp)
		lw	s0, 4(sp)
		lw	s1, 8(sp)
		lw	s2, 12(sp)
		addi	sp, sp, 16
		ret
