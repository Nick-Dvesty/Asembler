#--------
convert_number: # int number_recognition(char a0, int a1, int a2, int a3) 
		#if the number a1 belongs to the segment from a2 to a3, then add a4 to it
		blt 	a0, a1, error_cn_1
		bgt 	a0, a2, error_cn_1
		add	a0, a0, a3
end_cn: 	ret
error_cn_1:	error "\nERROR: char is not number", a0
