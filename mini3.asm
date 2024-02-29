.text
.macro exit %ecode
 li a0, %ecode
 li a7, 12 # a7 holds syscall number
 ecall
 li a7, 11 # a7 holds syscall number
 ecall
.end_macro
main: # entry point
 exit 0
