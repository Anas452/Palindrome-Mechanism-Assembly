
#This program takes string as an input from user
#Then it checks whether the given string is palindrome or not



.data 				#data section includes strings to be output to the console

    msg: .asciiz "\nEnter Any String:  "
    string_input: .space 256	#reserves a section of free space in a size given by bytes 
    msg1: .asciiz "\nIt Is A Palindrome. "
    msg2: .asciiz "\nIt Is Not A Palindrome. "
    msg3: .asciiz "\nThe Mirror Image Of The String Is: "
    msg4: .asciiz "\nDo You  Want To Continue [1/0]: "
    msg5: .asciiz "\nInvalid String Entered: "
    output: .space 256		#reserves a section of free space in a size given by bytes

.text
 
.globl main

.ent main
main:

    li $v0, 4			#preparing for string display
    la $a0, msg			
    syscall			#msg will be displayed on console

    li $v0 , 8			#preparing for string input
    la $a0, string_input	#loading memory address of string input buffer in "string_input"
    
    li $a1 , 256		#loading length of string buffer (n) to 256
    syscall

    jal invalid			#jump and link to "invalid"

    jal palindrome		#jump and link to "palindrome"

    move  $s2, $v0 		#$s2 = $v0
                        
    jal final_result		#jump and link to "final_result"

    li $v0,10			
    syscall			#exiting from console
    jr $ra

.end main




.ent invalid
invalid: 

    lbu $t8 , 0($a0)		#$t8 <— Zero-extended byte 
               			#from memory address $a0+0
               			 
    beq $t8 , 10, invalid_msg	#branch to "invalid_msg" if  $t8 = 10
    
    j back			#unconditional jump to "back"

    invalid_msg:
        
	li $v0, 4		#preparing for string display
        la $a0, msg5		
        syscall			#msg5 will be displayed on console
        
	j main			#unconditional jump to "main"

    back:

        jr $ra			#jump to address contained in $ra ("jump register")

.end invalid




.ent string_lenght

string_lenght:

    li $v0, 0			#loading imm 0 to $v0	
    move $s0, $a0		#$s0 = $a0

    lenght_loop:

        lbu $t0, 0($s0)		#$t0 <— Zero-extended byte 
               			#from memory address $s0+0	

        beq $t0 , 10, strlenght_exit
				#branch to "strlenght_exit" if  $t0 = 10

        addi $s0, $s0, 1	#$s0 = $s0 + 1
        addi $v0, $v0, 1	#$v0 = $v0 + 1

        j lenght_loop 		#unconditional jump to "lenght_loop"

    strlenght_exit:
        
        jr $ra			#jump to address contained in $ra ("jump register")


.end string_lenght




.ent palindrome

palindrome:

    addi $sp, $sp, -8		#$sp = $sp + (-8)

    sw $ra, 0($sp)		#store $ra into 0($sp)		
    sw $a0, 4($sp)		#store $a0 into 4($sp)	
    sw $t2, 8($sp)		#store $t2 into 8($sp)	

    jal string_lenght		#jump and link to "string_lenght"

    move $t0 , $v0		#$t0 = $v0
    lw $a0, 4($sp)		#load contents of 4($sp) into register $a0

    move $t1, $a0		#$t1 = $a0

    addi $t2, $t2, 1		#$t2 = $t2 + 1

    li $v0, 1			#load imm 1 to $v0		

    div $t3, $t0, 2		#$t3 = $t0 / 2   (integer quotient)
    addi $t3, $t3, 1		#$t3 = $t3 + 1
    
    pal_loop:

        bge $t2, $t3 ,pal_exit	#branch to "pal_exit" if  $t2 > $t3
        
	lbu $t4, 0($a0)		#$t4 <— Zero-extended byte 
               			#from memory address $a0+0	

        sub $t5, $t0, $t2	#$t5 = $t0 - $t2
        add $t6 ,$t5, $t1	#$t6 = $t5 + $t1

        lbu $t7, 0($t6)		#$t7 <— Zero-extended byte 
               			#from memory address $t6+0	


        beq $t4, $t7, pal_cont	#branch to "pal_cont" if  $t4 = $t7
        li $v0, 0		#load imm 1 to $v0
        j pal_exit		#unconditional jump to "pal_exit"

    pal_cont:

        addi $a0, $a0, 1	#$a0 = $a0 + 1
        addi $t2, $t2, 1	#$t2 = $t2 + 1
        j pal_loop		#unconditional jump to "pal_loop"

    pal_exit:

        lw $t2, 8($sp)		#load word 8($sp) into $t2
        lw $ra, 0($sp)		#load word 0($sp) into $ra
        addi $sp, $sp, 8	#$sp = $sp + 8
        jr $ra			#jump to address contained in $ra ("jump register")

.end palindrome




.ent final_result
final_result:
    
    addi $sp,$sp,0		#$sp = $sp + 0
    sw $s3, 0($sp)		#store word $s3 into 0($sp)
    
    beq $s2, 0, invalid_pal	#branch to "invalid_pal" if  $s2 = 0
    j valid_pal			#unconditional jump to "valid_pal"

    invalid_pal:

        li $v0,4
        la $a0,msg2
        syscall
        
	j rev_str		#unconditional jump to "rev_str"

    valid_pal:

        li $v0,4		#preparing for string display		
        la $a0,msg1
        syscall			#msg1 will be displayed on console
        
        j Continue		#unconditional jump to "Continue"

    rev_str:
        
        addi $s3,$s3,0		#$s3 = $s3 + 0

    reverse_loop:
            
        add $s4, $t1, $s3	#$s4 = $t1 + $s3		
        lbu $s5, 0($s4)		#$s5 <— Zero-extended byte 
               			#from memory address $s4+0	
        
	beq $s5, 0, rev_output	#branch to "rev_output" if  $s5 = 0		
        sb $s5, output($t0)	#store byte(low-order) in $s5 into RAM destination output($t0)			
        addi $t0, $t0, -1	#$t0 = $t0 + (-1)		
        addi $s3, $s3, 1	#$s3 = $s3 + 1		
        
	j reverse_loop		#unconditional jump to "reverse_loop"			

    rev_output:

        li $v0,4		#preparing for string display	
        la $a0, msg3
        syscall			#msg3 will be displayed on console

        li $v0, 4		#preparing for string display		
        la $a0, output		
        syscall			#output will be displayed on console
            
        j Continue		#unconditional jump to "Continue"	

    Continue:

        li $v0, 4		#preparing for string display	
        la $a0, msg4
        syscall			#msg4 will be displayed on console
			

        li $v0 , 5		#preparing for integer input
        syscall			#integer was input in $vo

        move $s6, $v0		#$s6 = $v0
        
	addi $s7, $0, 1		#$s7 = $0 + 1
        lw $s3, 0($sp)		#load word 0($sp) into $s3
        addi $sp, $sp, 0	#$sp = $sp + 0
	
        beq $s6,$s7,main	#branch to "main" if  $s6 = $s7
        j Exit			#unconditional jump to "Continue"	

    Exit:
        jr $ra			#jump to address contained in $ra ("jump register")


.end final_result

    
