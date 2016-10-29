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
    li 	$v0,4	    	; # System call code 4 for print string
    la 	$a0,input1	    ; # Argument string as input
    syscall			    ; # Print the string
    # Read first input 
    li 	$v0,5		    ; # System call code 5 to read int input
    syscall			    ; # Read it
	move 	$a1,$v0	    ; # move number into $a1 and it is m value
	bgtz	$a1,INPUT2	; # If valid input goto main code, else get input again
    li 	$v0,4		    ; # System call code 4 for print string
    la 	$a0,errmsg	    ; # Argument string as input
    syscall		    	; # Print the string
	j INPUT1		    ; # get the input again
	
#prompt input 2
INPUT2:
    li 	$v0,4	    	; # System call code 4 for print string
    la 	$a0,input2	    ; # Argument string as input
    syscall			    ; # Print the string
    # Read second input 
    li 	$v0,5		    ; # System call code 5 to read int input
    syscall			    ; # Read it
	move 	$a2,$v0	    ; # move number into a2 and it is n value
	bgtz	$a2,JGCD	; # If valid input goto main code, else get input again
    li 	$v0,4		    ; # System call code 4 for print string
    la 	$a0,errmsg	    ; # Argument string as input
    syscall		    	; # Print the string
	j INPUT2		    ; # get the input again
	
	
JGCD:
	jal 	GCDMAIN       	; # jump to greatest common divasor function
	move 	$a0,$v0      	; # copy result into a0 for printing
	li 	$v0, 1		; # Set up for printing
	syscall			; # Call the print routine
	li	$v0,4		; # Setup for string printing
	la	$a0,cr		; # Load address of string for printing
	syscall			; # Print the string
	
EXIT:
	li 	$v0,10		; # System call code for exit
    syscall			; # exit	
	
GCDMAIN:
    li $t0,0            ;#load 0 into register t0
    bne $a2,$t0,REC      ;#checking if n==0 then we return m
    move $v0,$a1        ;#copy m from a1 to function return register v0
    j RET               ;#jump to return 
REC:
    addi	$sp,$sp,-12	; # decrement sp
	sw	$a1,8($sp)  	; # push a1 (value m) onto the stack
	sw  $a2,4($sp)      ; # push a2 (value n) onto the stack
	sw	$ra,0($sp)	    ; # push ra onto stack
	jal     MOD         ; # find the modulo of m and n
	move $a1,$a2        ; # move value of a2 to a1 (from n to m)
	move $a2,$v0        ; # load the return value of modulo to a1
	jal 	GCDMAIN		; # jump to fact
	lw	$a1,8($sp)	; # pop stack into a1
	lw  $a2,4($sp)  ;# pop stack into a2
	lw	$ra,0($sp)	; # pop stack into ra
	addi	$sp,$sp,12	; # increment sp
    j   RET             ; #return
    

#n is in $a2 and m is in $a1

MOD:
    li $t1,0            ;#make  i=0
LOOP:                   ;#start of the while loop
    mul $t2,$t1,$a2     ;#multiply i*m where i is in register $t1 and m in register $a1
    sub $t2,$a1,$t2     ;#n-(i*m) where i*m is in register $t2
    bltz $t2,ENDLOOP    ;#if value of n-(i*m) is less than zero we return 
    addi $t1,$t1,1      ;#increment i by 1
    j LOOP              ;#repeat the loop
ENDLOOP:                ;#end of the loop
    addi $t1,$t1,-1     ;#substract 1 from i
    mul $t1, $t1, $a2   ;#multiply (i-1)*n where n is in register $a2, and (i-1) in register $t1
    sub $v0,$a1,$t1     ;#substract (i-1)*n from m and return
   
  
RET: 
    jr $ra              ;#return
    
    
    
    
    
    
    
    
    
    

    
    