.data 
     message1: .asciiz "Enter Length of Text : "
     message2: .asciiz "\nEnter The Text : "
     message3: .asciiz "\n Palindrome."
     message4: .asciiz "\n Not Palindrome."
     n: .asciiz "\n"
     userInput: .space 20
     revInput : .space 20

.text
main:
    
    li $v0 , 4
    la $a0 , message1    
    syscall
    
    li $v0 , 5
    syscall

    addi $t1 , $v0 , 0
    
    li $v0 , 4
    la $a0 , message2
    syscall

    li $v0 , 8
    la $a0 , userInput
    #li $a1 , 20
    syscall
    
    li $v0 , 4
    la $a0 , n
    syscall
   
    li $t0 , 0
    addi $t2 , $t1 , 0
    addi $t2 , $t2 , -1

RevText:
    beq $t0 , $t1 , printRev
    
    lb $t3 , userInput($t2)
    sb $t3 , revInput($t0)

    addi $t0 , $t0 , 1
    addi $t2 , $t2 , -1

    j RevText

printRev:
    li $v0 , 4
    la $a0 , revInput
    syscall

li $t0 , 0

check:
    bne $t6 , $t7 , NotPlandrome
    beq $t0 , $t1 , ChPlandrome
    
    lw $t6 , userInput($t0)
    lw $t7 , revInput($t0)
    
    addi $t0 , $t0 , 1
    j check

NotPlandrome:
    li $v0 , 4
    la $a0 , message4
    syscall
    b Exit

ChPlandrome:
    bne $t6 , $t7 , NotPlandrome
    beq $t6 , $t7 , Plandrome

Plandrome:
    li $v0 , 4
    la $a0 , message3
    syscall 
    b Exit

Exit:
    li $v0 , 10
    syscall    
.end main