#--------
convert_number: # int number_recognition(char a1, int a2, int a3, a4) 
		#if the number a1 belongs to the segment from a2 to a3, then add a4 to it
		mv 	t0, a2
		blt 	a1, t0, error_cn_1
		mv 	t0, a3
		bgt 	a1, t0, error_cn_1
		add	a1, a1, a4
		mv	a0, a1
end_cn: 	ret
error_cn_1:	error "\nERROR: char is not number", a1