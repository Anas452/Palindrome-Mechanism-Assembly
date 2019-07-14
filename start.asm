.data 

    msg: .asciiz "maham"
    # try_msg: .asciiz "the lenght of string"
    # msg1: .asciiz "IT is Palondrome"
    # msg2: .asciiz "it is not a palondrome"

.text
 
.globl main
.ent main
main:
    # li $v0, 4
    # la $a0, msg
    # syscall
    la $a0, msg
    # li $v0, 5
    # move $a0,$v0
    jal palondrome

    # move $t1, $v0

    # li $v0,4
    # la $a0,try_msg
    # syscall

    # li $v0,1
    # move $a0,$t1
    # syscall

    move  $a0,    $v0                         #set a0 to palindrom return value
    li  $v0,    1                           #set 1 to v0 - as this is system call for print int
    syscall 

    li $v0,10
    syscall
    jr $ra

.end main

strl:
    li $v0 ,0

strlenght:

    lb $t0, 0($a0)

    beq $t0 ,$0,strlenght_exit

    addi $a0, $a0, 1
    addi $v0, $v0, 1

    j strlenght 

strlenght_exit:
    # move $v0,$t2
    jr $ra

palondrome:

    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)

    jal strl

    move $t0 , $v0
    lw $a0, 4($sp)

    move $t1, $a0

    addi $t2, $t2, 1

    li $v0, 1

    div $t3, $t0, 2
    addi $t3, $t3, 1
    
pal_loop:

    bge $t2, $t3 pal_exit
    la $t5, 0($a0)

    sub $t5, $t0, $t2
    add $t6 ,$t5, $t1

    lb $t7, 0($t6)

    beq $t5, $t7, pal_cont
    li $v0, 0
    j pal_exit

pal_cont:

    addi $a0, $a0, 1
    addi $t2, $t2, 1
    j pal_loop

pal_exit:

    lw $ra,0($sp)
    addi $sp,$sp,8
    jr $ra



    
    