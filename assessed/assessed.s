    .data
    .align 2
# Input the string
    input1:  	.asciiz "\nEnter first number: " 
    input2:  	.asciiz "\nEnter second number: "
    cr:	 	    .asciiz "\n"
    errmsg:	    .asciiz "\nError - must enter a positive integer\n"
    
#standard preliminaries
    .text
    .globl main
    
main:

#prompt input 1
INPUT1:
    li 	    $v0,4	   	; # System call code 4 for print string
    la 	    $a0,input1  ; # Argument string as input
    syscall			    ; # Print the string
    # Read first input 
    li 	    $v0,5	    ; # System call code 5 to read int input
    syscall			    ; # Read first input
	move 	$a1,$v0	    ; # Move number into $a1 (m value from pseudocode)
	bgtz	$a1,INPUT2	; # If valid input go to input 2 code, else get input 1 again
    li 	    $v0,4	    ; # System call code 4 for print string
    la 	    $a0,errmsg  ; # Error argument string as input
    syscall		    	; # Print the string
	j       INPUT1	    ; # Get the input 1 again
	
#prompt input 2
INPUT2:
    li 	    $v0,4	    ; # System call code 4 for print string
    la 	    $a0,input2	; # Argument string as input
    syscall			    ; # Print the string
    # Read second input 
    li  	$v0,5		; # System call code 5 to read int input
    syscall			    ; # Read second input
	move 	$a2,$v0	    ; # Move number into a2 (n value from pseudocode)
	bgtz	$a2,JGCD	; # If valid input goto main code, else get input 2 again
    li 	    $v0,4		; # System call code 4 for print string
    la 	    $a0,errmsg	; # Error argument string as input
    syscall		    	; # Print the string
	j       INPUT2		; # Get the input 2 again
	
	
JGCD:
	jal 	GCDMAIN     ; # Jump and link to the greatest common divasor function
	move 	$a0,$v0     ; # Copy result into a0 for printing
	li 	    $v0, 1		; # Set up for printing
	syscall			    ; # Call the print routine
	li	    $v0,4		; # Setup for string printing
	la	    $a0,cr		; # Load address of string for printing
	syscall			    ; # Print the string
	
EXIT:
	li  	$v0,10	    ; # System call code for exit
    syscall			    ; # Exit	
	
GCDMAIN:
    li      $t0,0       ; # Load 0 into register t0
    bne     $a2,$t0,REC ; # Check if n==0 then we return m else jump to recursion
    move    $v0,$a1     ; # Copy m value from register a1 to function return register v0
    j       RET         ; # Jump to return 
REC:
    addi	$sp,$sp,-12	; # Decrement sp
	sw	    $a1,8($sp) 	; # Push a1 (value m) onto the stack
	sw      $a2,4($sp)  ; # Push a2 (value n) onto the stack
	sw	    $ra,0($sp)	; # Push ra onto stack
	jal     MOD         ; # Find the modulo of m and n
	move    $a1,$a2     ; # Move value of a2 to a1 (from n to m)
	move    $a2,$v0     ; # Load the return value of modulo to a2 (to n)
	jal 	GCDMAIN		; # Jump to the greatest common divisor main function
	lw	    $a1,8($sp)	; # Pop stack into a1
	lw      $a2,4($sp)  ; # Pop stack into a2
	lw  	$ra,0($sp)	; # Pop stack into ra
	addi	$sp,$sp,12	; # Increment sp
    j       RET         ; # Return
    

#Modulo function 
MOD:
    li      $t1,0       ; # Load 0 to t1 (i=0 from pseudocode)
LOOP:                   ; # Start the while loop
    mul     $t2,$t1,$a2 ; # Multiply i*m where i is in register $t1 and m in register $a2
    sub     $t2,$a1,$t2 ; # Substract n-(i*m) where i*m is in register $t2 and n in register $a1
    bltz    $t2,ENDLOOP ; # If value of n-(i*m) is less than zero we jump to return 
    addi    $t1,$t1,1   ; # Else we increment i by 1
    j       LOOP        ; # Repeat the loop
ENDLOOP:                ; # End of the loop
    addi    $t1,$t1,-1  ; # Substract 1 from i
    mul     $t1,$t1,$a2 ; # Multiply (i-1)*n where n is in register $a2, and (i-1) in register $t1
    sub     $v0,$a1,$t1 ; # Substract (i-1)*n from m and return
   
  
RET: 
    jr      $ra         ; # Return
    
    
    
    
    
    
    
    
    
    

    
    