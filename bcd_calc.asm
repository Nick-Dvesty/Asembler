# IN PROGRESS, NOT RWORK
.include "mac_syscall.asm"

.text
main:
call read_number
exiti 0


#--------
read_number: #int read_number ()
		#writes a number from the console to the a0 register
		addi 	sp, sp, -12
		sw	ra, 0(sp)
		sw	s0, 4(sp)
		sw	s1, 8(sp)
		
		
		li 	s0, 0
		li 	s1, 7
		li 	s2, 0
while_rn:	readch
		mv 	a1, a0
		li 	t0, 10
		beq 	a1, t0, end_rn
		
		beq 	a1, t0, minus
		beqz	s1, error_rn_1

		li 	a2, 0x30
		li 	a3, 0x39
		li 	a4, -0x30
		call	convert_number
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

.include "fun_convert_number.asm"
