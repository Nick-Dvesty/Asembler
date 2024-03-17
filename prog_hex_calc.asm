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
.include "fun_console_hex.asm"
