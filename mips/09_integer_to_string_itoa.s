# Integer to String Conversion (itoa)
# Converts a 32-bit integer to its ASCII string representation
# Handles positive and negative numbers with digit extraction
# MIPS Compatible with MARS Simulator

.data
    prompt: .asciiz "Enter an integer: "
    result_msg: .asciiz "String representation: "
    buffer: .space 32           # String buffer
    newline: .asciiz "\n"
    
    # Constants
    minus_sign: .asciiz "-"
    divisor: .word 10

.text
.globl main

main:
    # Read integer from user
    li $v0, 4
    la $a0, prompt
    syscall
    
    li $v0, 5
    syscall
    move $a0, $v0       # $a0 = integer value
    
    # Convert to string
    la $a1, buffer      # $a1 = buffer address
    jal itoa
    
    # Print result message
    li $v0, 4
    la $a0, result_msg
    syscall
    
    # Print converted string
    li $v0, 4
    la $a0, buffer
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Exit
    li $v0, 10
    syscall

# itoa Function - Integer to ASCII
# Input: $a0 = integer, $a1 = buffer address
# Output: buffer contains ASCII string
itoa:
    addiu $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)      # Save original number
    sw $a1, 8($sp)      # Save buffer address
    sw $zero, 12($sp)   # Character counter
    
    # Check if negative
    bltz $a0, itoa_negative
    
    # Positive number
    li $t0, 0           # Digit count
    
    j itoa_extract_digits
    
itoa_negative:
    # Handle negative number
    li $v0, 4
    la $a0, minus_sign
    syscall
    
    neg $a0, $a0        # Make positive
    li $t0, 0
    
itoa_extract_digits:
    # Stack to reverse digits
    addiu $sp, $sp, -32
    
    li $t1, 0           # Digit stack pointer
    li $t2, 10          # Divisor
    
extract_loop:
    div $a0, $t2
    mfhi $t3            # Remainder (digit)
    mflo $a0            # Quotient
    
    # Convert digit to ASCII and push to stack
    addiu $t3, $t3, '0'
    sb $t3, 0($sp)
    addiu $sp, $sp, -1
    addiu $t1, $t1, 1
    
    beq $a0, 0, extract_done
    j extract_loop
    
extract_done:
    # Pop digits from stack and store in buffer
    lw $a1, 8($sp)
    
pop_loop:
    beq $t1, 0, pop_done
    
    addiu $sp, $sp, 1
    lb $t3, 0($sp)
    sb $t3, 0($a1)
    addiu $a1, $a1, 1
    addiu $t1, $t1, -1
    j pop_loop
    
pop_done:
    # Null terminate string
    sb $zero, 0($a1)
    
    # Clean up stack
    addiu $sp, $sp, 32
    lw $ra, 0($sp)
    addiu $sp, $sp, 16
    jr $ra
