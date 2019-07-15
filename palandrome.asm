.data 

    msg: .asciiz "enter any string"
    msg1: .asciiz "\nIT is Palondrome"
    msg2: .asciiz "\nit is not a palondrome"
    msg3: .asciiz "\nthe mirror image is "
    output: .space 256

.text
 
.globl main
.ent main
main:

    li $v0, 4
    la $a0, msg
    syscall

    li $v0 ,8
    la $a0, msg
    syscall
        
    jal palondrome
    # jal final_result

   
    move  $s2,    $v0                         #set a0 to palindrom return value
    
    jal final_result


    li $v0,10
    syscall
    jr $ra

.end main

strl:
    li $v0 ,0
    move $s0,$a0

strlenght:

    lbu $t0, 0($s0)

    beq $t0 ,10,strlenght_exit

    addi $s0, $s0, 1
    addi $v0, $v0, 1

    j strlenght 

strlenght_exit:
    
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

    lw $ra,0($sp)
    addi $sp,$sp,8
    jr $ra


final_result:

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
    jr $ra
    
# # .end mai
rev_str:
    
    addi $s3,$s3,0

reverse_loop:
		add	$s4, $t1, $s3	
		lb	$s5, 0($s4)		
		beq	$s5,0 exit		
		sb	$s5, output($t0)			
		subu	$t0, $t0, 1		
		addi	$s3, $s3, 1		
		j	reverse_loop		
	
exit:

    li $v0,4
    syscall

	li	$v0, 4			
	la	$a0, output		
	syscall
		
	li	$v0, 10			
	syscall
	      



    
