# Palindrome Checker Algorithm
# Verifies if a string reads the same forwards and backwards
# Uses two-pointer technique from opposite ends
# MIPS Compatible with MARS Simulator

.data
    prompt: .asciiz "Enter a string: "
    is_palindrome: .asciiz " is a palindrome!\n"
    not_palindrome: .asciiz " is NOT a palindrome.\n"
    buffer: .space 256
    newline: .asciiz "\n"

.text
.globl main

main:
    # Print prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Read string
    li $v0, 8
    la $a0, buffer
    li $a1, 256
    syscall
    
    # Find string length
    la $a0, buffer
    jal string_length
    move $a2, $v0       # $a2 = string length (excluding \n)
    
    # Check palindrome
    la $a0, buffer
    jal check_palindrome
    
    # Print result
    li $v0, 4
    la $a0, buffer
    syscall
    
    beq $v0, 1, is_pal
    
    li $v0, 4
    la $a0, not_palindrome
    syscall
    j exit_program
    
is_pal:
    li $v0, 4
    la $a0, is_palindrome
    syscall
    
exit_program:
    li $v0, 10
    syscall

# String Length Function
# Input: $a0 = string address
# Output: $v0 = string length
string_length:
    li $v0, 0
    
length_loop:
    lb $t0, 0($a0)
    beq $t0, '\n', length_done
    beq $t0, '\0', length_done
    addiu $v0, $v0, 1
    addiu $a0, $a0, 1
    j length_loop
    
length_done:
    jr $ra

# Palindrome Check Function
# Input: $a0 = string address, $a2 = string length
# Output: $v0 = 1 if palindrome, 0 if not
check_palindrome:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $t0, 0           # left pointer
    addi $t1, $a2, -1   # right pointer
    
palindrome_loop:
    bge $t0, $t1, palindrome_true
    
    # Load characters
    add $t2, $a0, $t0
    lb $t3, 0($t2)
    
    add $t2, $a0, $t1
    lb $t4, 0($t2)
    
    # Compare characters
    bne $t3, $t4, palindrome_false
    
    addiu $t0, $t0, 1
    addiu $t1, $t1, -1
    j palindrome_loop
    
palindrome_true:
    li $v0, 1
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
    
palindrome_false:
    li $v0, 0
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
