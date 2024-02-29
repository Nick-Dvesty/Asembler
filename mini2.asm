.text

.macro syscall %n
  li a7 %n
  ecall
.end_macro

.macro printch %n
li a0 %n
 syscall 11
.end_macro

.macro printchreg %n
mv a0 %n
syscall 11
.end_macro

.macro readch
 syscall 12
.end_macro

.macro exit
syscall 93
.end_macro

main:
li t0 10
while:
readch
beq t0 a0 end
printchreg a0
J while
end:
exit

