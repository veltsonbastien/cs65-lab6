# xSpim Memory Demo Program

#  Data Area
.data

space:
    .asciiz " "

newline:
    .asciiz "\n"

dispArray:
    .asciiz "\nCurrent Array:\n"

convention:
    .asciiz "\nConvention Check\n"

myArray:
	.word 0 33 123 -66 332 -1 -223 453 9 45 -78 -14  

#Text Area (i.e. instructions)
.text

main:
    ori     $v0, $0, 4          
    la      $a0, dispArray 
    syscall

    ori     $s1, $0, 12
    la      $s0, myArray

    add     $a1, $0, $s1
    add     $a0, $0, $s0
 
    jal     DispArray

    ori     $s2, $0, 0
    ori     $s3, $0, 0
    ori     $s4, $0, 0
    ori     $s5, $0, 0
    ori     $s6, $0, 0
    ori     $s7, $0, 0
    
    add     $a1, $0, $s1
    add     $a0, $0, $s0

    jal     IterativeMax

    add     $s1, $s1, $s2
    add     $s1, $s1, $s3
    add     $s1, $s1, $s4
    add     $s1, $s1, $s5
    add     $s1, $s1, $s6
    add     $s1, $s1, $s7

    add     $a1, $0, $s1
    add     $a0, $0, $s0
    jal     DispArray

    j       Exit

DispArray:
    addi    $t0, $0, 0 
    add     $t1, $0, $a0

dispLoop:
    beq     $t0, $a1, dispend
    sll     $t2, $t0, 2
    add     $t3, $t1, $t2
    lw      $t4, 0($t3)

    ori     $v0, $0, 1
    add     $a0, $0, $t4
    syscall

    ori     $v0, $0, 4
    la      $a0, space
    syscall

    addi    $t0, $t0, 1
    j       dispLoop    

dispend:
    ori     $v0, $0, 4
    la      $a0, newline
    syscall
    jr      $ra 

ConventionCheck:
    addi    $t0, $0, -1
    addi    $t1, $0, -1
    addi    $t2, $0, -1
    addi    $t3, $0, -1
    addi    $t4, $0, -1
    addi    $t5, $0, -1
    addi    $t6, $0, -1
    addi    $t7, $0, -1
    ori     $v0, $0, 4
    la      $a0, convention
    syscall
    addi $v0, $zero, -1
    addi $v1, $zero, -1
    addi $a0, $zero, -1
    addi $a1, $zero, -1
    addi $a2, $zero, -1
    addi $a3, $zero, -1
    addi $k0, $zero, -1
    addi $k1, $zero, -1
    jr      $ra
    
Exit:
    ori     $v0, $0, 10
    syscall

# COPYFROMHERE - DO NOT REMOVE THIS LINE

IterativeMax:
    #TODO: write your code here, $a0 stores the address of the array, $a1 stores the length of the array

	#allocate space for s0, s1, s2
	#s0 = address of array 
	#s1 = length of array
	#s2 = iterative max
	#s3 = counter 


	addiu $sp, $sp, -16 
	sw $s0, 12($sp) 
	sw $s1, 8($sp) 
	sw $s2, 4($sp)
	sw $s3, 0($sp) 

	#assign $a0 to $s0 
	move $s0, $a0

	#assign $a1 to $s1
	move $s1, $a1
	
	#assign zero to iterative max 
	move $s2, $zero 
	
	#assign zero to counter 
	move $s3, $zero 


	#begin ITERATING through the array 

IterativeMax_loop: 

	#do a condition check for the iteration  
	bge $s3, $s1, IterativeMax_exit 

	#if we didn't branch, first write out the current number and a line 
	li $v0, 1
	lw $a0, 0($s0) 
	syscall 

	li $v0, 4
	la $a0, newline
	syscall

	
	#check compare the number against the current max, branch accordingly
	
	#set a temp to the current number 
	lw $t0, 0($s0)
	
	#the number is bigger, set new max: 
	bgt $t0, $s2, setNewMax
	
	#it didn't branch, so print out the current max as is 
	li $v0, 1
	move $a0, $s2
	syscall 

	#update array address 
	addiu $s0, $s0, 4

	#update the counter 
	addi $s3, $s3, 1

	#before leaving push the ra
	addiu $sp, $sp, -4
	sw $ra, 0($sp) 
	
	#do a convention check
	jal ConventionCheck 
	

	#after coming back pop the ra
	lw $ra, 0($sp) 
	addiu $sp, $sp, 4

	#jump back 	
	j IterativeMax_loop


setNewMax: 
	
	#set s2 to the current element 
	lw $s2, 0($s0) 

	#print out the current 
	li $v0, 1
	move $a0, $s2
	syscall 


	#update array address 
	addiu $s0, $s0, 4

	#update the counter 
	addi $s3, $s3, 1

	#before leaving, push the ra
	addiu $sp, $sp, -4
	sw $ra, 0($sp) 

	#do a convention check 
	jal ConventionCheck 
	
	#after coming back, pop the ra
	lw $ra, 0($sp) 
	addiu $sp, $sp, 4

	#jump back to iterative max loop 
	
	j IterativeMax_loop


IterativeMax_exit: 		

	#deallocate everything 
	lw $s0, 12($sp) 
	lw $s1, 8($sp) 
	lw $s2, 4($sp) 
	lw $s3, 0($sp) 

	addiu $sp, $sp, 16

    # Do not remove this line
    jr      $ra
