# Binary Search Algorithm
# O(log n) search on a sorted array
# Demonstrates divide-and-conquer with register preservation
# MIPS Compatible with MARS Simulator

.data
    array: .word 10, 20, 30, 40, 50, 60, 70, 80, 90, 100
    array_size: .word 10
    
    prompt: .asciiz "Enter value to search: "
    found_msg: .asciiz "Found at index: "
    not_found_msg: .asciiz "Value not found!\n"
    newline: .asciiz "\n"

.text
.globl main

main:
    # Read search value
    li $v0, 4
    la $a0, prompt
    syscall
    
    li $v0, 5
    syscall
    move $a2, $v0       # $a2 = target value
    
    # Prepare arguments
    la $a0, array       # $a0 = array address
    li $a1, 0           # $a1 = left index
    li $a3, 9           # $a3 = right index
    
    # Call binary_search
    jal binary_search
    
    # Check if found
    li $t0, -1
    beq $v0, $t0, not_found
    
    # Print found message
    li $v0, 4
    la $a0, found_msg
    syscall
    
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    j exit_program
    
not_found:
    li $v0, 4
    la $a0, not_found_msg
    syscall
    
exit_program:
    li $v0, 10
    syscall

# Binary Search Function
# Input: $a0 = array address, $a1 = left, $a3 = right, $a2 = target
# Output: $v0 = index if found, -1 if not found
binary_search:
    addiu $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a2, 4($sp)      # Save target value
    
    # Check if left > right
    bgt $a1, $a3, search_not_found
    
    # Calculate mid = (left + right) / 2
    add $t0, $a1, $a3
    srl $t0, $t0, 1     # Divide by 2
    
    # Load array[mid]
    sll $t1, $t0, 2     # Multiply by 4 (word size)
    add $t1, $a0, $t1
    lw $t2, 0($t1)
    
    # Compare with target
    beq $t2, $a2, search_found
    blt $t2, $a2, search_right
    
    # Search left
    move $a3, $t0
    addiu $a3, $a3, -1
    jal binary_search
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra
    
search_right:
    move $a1, $t0
    addiu $a1, $a1, 1
    jal binary_search
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra
    
search_found:
    move $v0, $t0
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra
    
search_not_found:
    li $v0, -1
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra
