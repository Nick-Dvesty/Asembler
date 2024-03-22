.text
div_start: 
addi sp, sp, -12
sw ra, 0(sp)
sw s0, 4(sp)
sw s1, 8(sp)

mv s0, a0
call division
mv s1, a0
call multiply
ble a0, s0, general_ds
addi s1, s1, 1 
general_ds: 	mv a0, s1
lw ra, 0(sp)
lw s0, 4(sp)
lw s1, 8(sp)
addi sp, sp, 12
ret
division:#(input: int a0, output: int a0, int a1)
		addi sp, sp, -8
		sw ra 0(sp)
		sw s1 4(sp)
		li t0, 10
		blt a0, t0, less_10_divr
		srli s1, a0, 2
		srli a0, a0, 1
		call division
		sub a0, s1, a0
		srli a0, a0, 1
		j general_divr
less_10_divr:	li a0, 0
general_divr: 	lw ra 0(sp)
		lw s1 4(sp)
		addi sp, sp, 8
		ret

remains:
addi sp, sp, -4
sw ra, 0(sp)
call division
mv a0, a1
lw ra, 0(sp)
addi sp, sp, 4
ret
