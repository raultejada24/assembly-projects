# Prime Number Checker Algorithm
# Mathematical algorithm using division and modulo operations
# Efficiently checks divisibility up to sqrt(n)
# MIPS Compatible with MARS Simulator

.data
    prompt: .asciiz "Enter a number: "
    is_prime: .asciiz " is a prime number.\n"
    not_prime: .asciiz " is NOT a prime number.\n"
    newline: .asciiz "\n"

.text
.globl main

main:
    # Read number
    li $v0, 4
    la $a0, prompt
    syscall
    
    li $v0, 5
    syscall
    move $a0, $v0       # $a0 = number to check
    move $s0, $a0       # Save for printing
    
    # Check if prime
    jal is_prime_check
    
    # Print number
    li $v0, 1
    move $a0, $s0
    syscall
    
    # Print result
    li $v0, 4
    beq $v0, 1, print_prime
    la $a0, not_prime
    syscall
    j exit_prog
    
print_prime:
    la $a0, is_prime
    syscall
    
exit_prog:
    li $v0, 10
    syscall

# Prime Check Function
# Input: $a0 = number to check
# Output: $v0 = 1 if prime, 0 if not
is_prime_check:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Handle special cases
    li $t0, 2
    blt $a0, $t0, not_prime_ret
    
    beq $a0, $t0, prime_ret
    
    # Check if even
    andi $t1, $a0, 1
    beq $t1, $zero, not_prime_ret
    
    # Check odd divisors from 3 to sqrt(n)
    li $t0, 3           # Divisor
    
prime_check_loop:
    # Calculate t0 * t0
    mult $t0, $t0
    mflo $t1
    
    # If t0*t0 > n, it's prime
    bgt $t1, $a0, prime_ret
    
    # Check if n is divisible by t0
    div $a0, $t0
    mfhi $t1            # Remainder
    
    beq $t1, $zero, not_prime_ret
    
    # Next odd number
    addiu $t0, $t0, 2
    j prime_check_loop
    
prime_ret:
    li $v0, 1
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
    
not_prime_ret:
    li $v0, 0
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
