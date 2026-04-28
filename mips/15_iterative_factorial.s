# Iterative Factorial Calculation
# Loop-based factorial computation to contrast with recursive methods
# Accumulates product through iterative multiplication
# MIPS Compatible with MARS Simulator

.data
    prompt: .asciiz "Enter a number: "
    result_msg: .asciiz "Factorial of "
    equals: .asciiz " = "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Read input
    li $v0, 4
    la $a0, prompt
    syscall
    
    li $v0, 5
    syscall
    move $a0, $v0       # $a0 = n
    move $s0, $a0       # Save n for printing
    
    # Calculate factorial
    jal factorial
    move $s1, $v0       # Save result
    
    # Print result message
    li $v0, 4
    la $a0, result_msg
    syscall
    
    li $v0, 1
    move $a0, $s0
    syscall
    
    li $v0, 4
    la $a0, equals
    syscall
    
    li $v0, 1
    move $a0, $s1
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Exit
    li $v0, 10
    syscall

# Iterative Factorial Function
# Input: $a0 = n
# Output: $v0 = n!
factorial:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $v0, 1           # Accumulator (result)
    li $t0, 2           # Counter (starts at 2)
    
factorial_loop:
    bgt $t0, $a0, factorial_done
    
    # Multiply result by counter
    mult $v0, $t0
    mflo $v0
    
    # Increment counter
    addiu $t0, $t0, 1
    j factorial_loop
    
factorial_done:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
