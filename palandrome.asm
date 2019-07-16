.data 

    msg: .asciiz "\nEnter Any String:  "
    string_input: .space 256
    msg1: .asciiz "\nIt is Palidrome"
    msg2: .asciiz "\nIt is not a Palindrome"
    msg3: .asciiz "\nThe Mirror Image Of The Word Is "
    msg4: .asciiz "\nDo you  Want to Continue(1/0) "
    msg5: .asciiz "\nInvalid string enter: "
    output: .space 256

.text
 
.globl main
.ent main
main:

    li $v0, 4
    la $a0, msg
    syscall

    li $v0 ,8
    la $a0,string_input
    li $a1 ,256
    # la $a0, msg
    syscall

    jal invalid
    jal palindrome

    move  $s2,    $v0                         
    
    jal final_result

    li $v0,10
    syscall
    jr $ra

.end main

.ent invalid
invalid: 

    lbu $t8 ,0($a0)
    beq $t8 ,10,invalid_msg
    j back

    invalid_msg:
        li $v0, 4
        la $a0, msg5
        syscall
        j main

    back:

        jr $ra

.end invalid

.ent string_lenght

string_lenght:

    li $v0 ,0
    move $s0,$a0

    lenght_loop:

        lbu $t0, 0($s0)

        beq $t0 ,10,strlenght_exit

        addi $s0, $s0, 1
        addi $v0, $v0, 1

        j lenght_loop 

    strlenght_exit:
        
        jr $ra

.end string_lenght

.ent palindrome

palindrome:

    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $t2, 8($sp)

    jal string_lenght

    move $t0 , $v0
    lw $a0, 4($sp)

    move $t1, $a0

    addi $t2, $t2, 1

    li $v0, 1

    div $t3, $t0, 2
    addi $t3, $t3, 1
    
    pal_loop:

        bge $t2, $t3 ,pal_exit
        lbu $t4, 0($a0)

        sub $t5, $t0, $t2
        add $t6 ,$t5, $t1

        lbu $t7, 0($t6)

        beq $t4, $t7, pal_cont
        li $v0, 0
        j pal_exit

    pal_cont:

        addi $a0, $a0, 1
        addi $t2, $t2, 1
        j pal_loop

    pal_exit:

        lw $t2,8($sp)
        lw $ra,0($sp)
        addi $sp,$sp,8
        jr $ra

.end palindrome

.ent final_result
final_result:
    
    addi $sp,$sp,0
    sw $s3, 0($sp)
    
    beq $s2, 0, invalid_pal
    j valid_pal

    invalid_pal:

        li $v0,4
        la $a0,msg2
        syscall
        j rev_str

    valid_pal:

        li $v0,4
        la $a0,msg1
        syscall
        
        j Continue

    rev_str:
        
        addi $s3,$s3,0

    reverse_loop:
            
        add	$s4, $t1, $s3	
        lbu	$s5, 0($s4)		
        beq	$s5,0 rev_output		
        sb  $s5, output($t0)			
        addi  $t0, $t0, -1		
        addi  $s3, $s3, 1		
        j	reverse_loop		

    rev_output:

        li $v0,4
        la $a0, msg3
        syscall

        li	$v0, 4			
        la	$a0, output		
        syscall
            
        j Continue

    Continue:

        li $v0, 4
        la $a0, msg4
        syscall

        li $v0 ,5
        syscall

        move $s6, $v0
        addi $s7,$0,1
        lw $s3, 0($sp)
        addi $sp,$sp,0

        beq $s6,$s7,main
        j Exit

    Exit:
        jr $ra


.end final_result

    
