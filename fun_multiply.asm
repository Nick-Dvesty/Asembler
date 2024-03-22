#--------
multiply:# int multiply(int a0, int a1, int a2, int a3)
		li a2, 0
		li t1, 1
while:		beqz	a1, end_while
		andi	t0, a1, 1
		beqz	t0, general_m
		add 	a2, a2, a0
general_m:	srli	a1, a1, 1
		slli 	a0, a0, 1
		j 	while
end_while: 	mv	a0, a2
ret