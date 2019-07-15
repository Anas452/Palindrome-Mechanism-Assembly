.data 

    msg: .asciiz "enter the string: "
    var1: .asciiz "testtttt"
    var2: .asciiz "Not a Palindrome"
    var3: .asciiz "it is a palindrome"
    # try_msg: .asciiz "the lenght of string"
    # msg1: .asciiz "IT is Palondrome"
    # msg2: .asciiz "it is not a palondrome"

.text
 
#   $s2 for length
#  $t5 containing string

.globl main
.ent main
main:
    
    li $v0, 4
    # la $a0, msg
    syscall
    
    # la $a0, msg
    li $v0, 8
    la $a0,msg
    syscall


    la $t5,var1


    jal palondrome

    

    li $v0,10
    syscall
    jr $ra

.end main

strl:
    li $s2 ,0


strlenght:

    lbu $t0, 0($t5)

    beq $t0 ,10,strlenght_exit

    addi $t5, $t5, 1
    addi $s2, $s2, 1


    j strlenght 

strlenght_exit:

    li $s4,0
    sub $s4,$t5,$s2

    add $t5,$s4,$s2
    addi $t5,$t5,-1
    # addi  $s4,$t5,0
    # add $t5,$t5,$s2
    # add $t5,$t5,-1

    # move $v0,$t2
    jr $ra

palondrome:

    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)

    jal strl



    addi $t2, $0, 1


    div $t3, $s2, 2

    addi $t3, $t3, 1
    
    li $s6,0

    
pal_loop:

    bge $t2, $t3, validPalindrome

    # add $t5,$t5,$s2
    # sub $t5,$t5,$t2

    
    lbu $t6,0($s4) # increament 
    lbu $t4, 0($t5) # decreament

    # move $a0,$t6
    # li $v0,1
    # syscall

    # move $a0,$t4
    # li $v0,1
    # syscall



    # move $a0,$t6
    # li $v0,1
    # syscall


    beq $t4, $t6, pal_cont

    j pal_exit

pal_cont:


    addi $s4, $s4, 1
    addi $t5,$t5, -1
    addi $t2,$t2,1
    j pal_loop

pal_exit:

    li $v0,4
    la $a0,var2
    syscall

    li $v0,10
    syscall

validPalindrome: 
    li $v0,4
    la $a0,var3
    syscall

    li $v0,10
    syscall


    
    