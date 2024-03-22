.include "mac_syscall.asm"
.text
main:
call read_number
mv s0, a0
call read_number
mv a1, s0
call multiply
call print_number
exiti 0

.include "fun_console_hex.asm"
.include "fun_multiply.asm"
.include "fun_convert_number.asm"
