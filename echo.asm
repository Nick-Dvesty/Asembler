.include "mac_syscall.asm"

.text
main:
		call echo
exit:		exiti 0

#--------
echo: #void echo()
		li 	t0, 10
		li 	t1, 127
while_e:	readch
		beq 	a0, t0, end_e
		bne	a0, t0, not_overflow
		li 	a0, 0
not_overflow:	printch a0
		addi 	a0, a0, 1
		printch a0
		j 	while_e
end_e:		ret
