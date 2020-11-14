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

    jal     PrintReverse

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


pushArray: 
	

	#get the length and save it to a temporary for comparisons 
	move $t0, $s1
	
	#get the address and save it to a temporary
	move $t2, $s0

	#make a temporary for a counter 
	li $t1, 0 


pushArray_loop: 

	#check if you've reached the end 
	bge $t1, $t0, setCounter

	#if not, push whatever is at the counter 
	

	#allocate space for it: 
	addiu $sp, $sp, -4 

	#push it
	lw $t3, 0($t2)  
	sw $t3, 0($sp) 

	#increment everything 
	addiu $t2, $t2, 4 #move the address over by 4 for the array to get the next thing 
	addiu $t1, $t1, 1 #update the counter 

	j pushArray_loop


PrintReverse:
    #TODO: write your code here, $a0 stores the address of the array, $a1 stores the length of the array
	
	#push length and ra onto the stack, just for good measure 
    	
	#allocate space on the stack for length and ra 
	addiu $sp, $sp, -12

	#add s0, s1, and s2 to the stack
	sw $s0, 8($sp) 
 	sw $s1, 4($sp) 
	sw $s2, 0($sp)

	#initialize s0 with array address 
	move $s0, $a0

	#initialize s1 with length 
	move $s1, $a1

	#go to function to push everything onto the stack
	j pushArray


setCounter:
	move $s2, $zero 

PrintReverse_loop:

	#do a condition check 
	bge $s2, $s1, PrintReverse_exit

	
	#if it didn't branch, pop out whatever is at the top of the stack pointer 
	lw $t2, 0($sp) #move whatever is at the top of the stack to a temp 
	li $v0, 1 
	move $a0, $t2
	syscall 

	
	#increment $sp
	addiu $sp, $sp, 4 

  
	
	#increment counter 
	addi $s2, $s2, 1


	#push the ra before the check
	addiu $sp, $sp, -4
	sw $ra, 0($sp) 	

 	#do a convention check 
	jal ConventionCheck

	#pop the ra after the call 
	lw $ra, 0($sp)
	addiu $sp, $sp, 4


	j PrintReverse_loop 


PrintReverse_exit: 

    #clear everything 
    lw $s0, 8($sp)
    lw $s1, 4($sp) 
    lw $s2, 0($sp)
    addiu $sp, $sp, 12

    # Do not remove this line
    jr  $ra
