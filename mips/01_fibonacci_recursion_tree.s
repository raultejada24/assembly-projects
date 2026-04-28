# Fibonacci Recursion with Stack Manipulation
# Calculates the nth Fibonacci number using recursive calls
# Demonstrates advanced stack frame management and register preservation
# MIPS Compatible with MARS Simulator

.data
    prompt: .asciiz "Enter n: "
    result_msg: .asciiz "Fibonacci("
    equals: .asciiz ") = "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Read input from user
    li $v0, 4           # Print string syscall
    la $a0, prompt
    syscall
    
    li $v0, 5           # Read integer syscall
    syscall
    move $a0, $v0       # $a0 = n (input value)
    
    # Call fib(n)
    jal fib
    move $s0, $v0       # Save result in $s0
    
    # Print result message
    li $v0, 4
    la $a0, result_msg
    syscall
    
    li $v0, 1
    lw $a0, 0($sp)      # Load original n from stack
    syscall
    
    li $v0, 4
    la $a0, equals
    syscall
    
    li $v0, 1
    move $a0, $s0       # Print result
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Exit program
    li $v0, 10
    syscall

# Recursive Fibonacci Function
# Input: $a0 = n
# Output: $v0 = fib(n)
fib:
    # Prologue: Save return address and local frame
    addiu $sp, $sp, -8
    sw $ra, 4($sp)      # Save return address
    sw $a0, 0($sp)      # Save argument n
    
    # Base cases
    li $t0, 2
    blt $a0, $t0, fib_base
    
    # Recursive case: fib(n-1) + fib(n-2)
    addiu $a0, $a0, -1
    jal fib             # Call fib(n-1)
    move $s1, $v0       # Save result in $s1
    
    # Load n from stack and calculate fib(n-2)
    lw $a0, 0($sp)
    addiu $a0, $a0, -2
    jal fib             # Call fib(n-2)
    
    # Combine results
    add $v0, $s1, $v0
    
    # Epilogue
    lw $ra, 4($sp)
    addiu $sp, $sp, 8
    jr $ra
    
fib_base:
    # Base case: fib(0) = 0, fib(1) = 1
    move $v0, $a0
    lw $ra, 4($sp)
    addiu $sp, $sp, 8
    jr $ra
