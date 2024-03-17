.macro syscall %d
li a7, %d
ecall
.end_macro

.macro readch
syscall 12
.end_macro

.macro printch %r
mv a0, %r
syscall 11
.end_macro

.macro printchi %d
li a0, %d
syscall 11
.end_macro

.macro exit %r
mv a0, %r
syscall 93
.end_macro

.macro exiti %d
li a0, %d
syscall 93
.end_macro

.macro error %s %r1
.data
std: .asciz %s
.text
la, a0, std
syscall 4
exit %r1
.end_macro

.macro swap %r1 %r2
xor %r1, %r1, %r2
xor %r2, %r1, %r2
xor %r1, %r1, %r2
.end_macro
