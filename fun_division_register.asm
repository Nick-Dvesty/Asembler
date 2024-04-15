.include "mac_syscall.asm"
.text
main:
li a0, 129
li a1, -16
call sdiv
exit a0

sdiv:
		addi	sp, sp, -8
		sw	ra, 0(sp)
		sw	s0, 4(sp)
		
		srli	t0, a0, 31		
		srli	t1, a1, 31
		xor	s0, t0, t1
		beqz	t0, t0_plus
		xori	a0, a0, -1
		addi 	a0, a0, 1
t0_plus:		beqz	t1, t1_plus
		xori	a1, a1, -1
		addi 	a1, a1, 1
t1_plus:		call	udiv
		beqz	s0, general_sdiv
		addi	a0, a0, -1
		xori	a0, a0, -1
		addi	a1, a1, -1
		xori	a1, a1, -1

general_sdiv:	lw	ra, 0(sp)
		lw	s0, 4(sp)
		addi	sp, sp, 8
		ret


udiv:#(private, remainder) udiv (divisible, divisor) 
		li	t0, 0
		li 	t1, 0
		li	a2, 0 
while_udiv2:	bgt	a1, a0, e_while_udiv2
		slli	a1, a1, 1
		addi	t0, t0, 1
		j	while_udiv2
e_while_udiv2:	addi 	t0, t0, 1
while_udiv3:	beqz	t0, e_while_udiv3
		blt	a0, a1, general_udiv
		sub	a0, a0, a1
		srli	a1, a1, 1
		slli	a2, a2, 1
		addi	a2, a2, 1
		addi	t0, t0, -1
		j	while_udiv3
general_udiv:	slli	a2, a2, 1
		srli	a1, a1, 1
		addi	t0, t0, -1
		j 	while_udiv3
e_while_udiv3:	mv	a1, a0
		mv	a0, a2
		ret