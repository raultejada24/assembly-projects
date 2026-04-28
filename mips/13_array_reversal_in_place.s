# Array Reversal In-Place
# Reverses an array without secondary memory allocation
# Uses two-pointer technique from both ends
# MIPS Compatible with MARS Simulator

.data
    array: .word 10, 20, 30, 40, 50, 60, 70, 80
    array_size: .word 8
    
    original_msg: .asciiz "Original array: "
    reversed_msg: .asciiz "Reversed array: "
    space: .asciiz " "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Print original array
    li $v0, 4
    la $a0, original_msg
    syscall
    
    la $a0, array
    li $a1, 8
    jal print_array
    
    # Reverse the array
    la $a0, array
    li $a1, 8
    jal reverse_array
    
    # Print reversed array
    li $v0, 4
    la $a0, reversed_msg
    syscall
    
    la $a0, array
    li $a1, 8
    jal print_array
    
    # Exit
    li $v0, 10
    syscall

# Reverse Array Function
# Input: $a0 = array address, $a1 = array size
reverse_array:
    addiu $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    
    li $t0, 0           # Left pointer
    addi $t1, $a1, -1   # Right pointer
    
reverse_loop:
    bge $t0, $t1, reverse_done
    
    # Load elements
    sll $t2, $t0, 2
    add $t2, $a0, $t2
    lw $t3, 0($t2)      # Left element
    
    sll $t4, $t1, 2
    add $t4, $a0, $t4
    lw $t5, 0($t4)      # Right element
    
    # Swap
    sw $t5, 0($t2)
    sw $t3, 0($t4)
    
    # Move pointers
    addiu $t0, $t0, 1
    addiu $t1, $t1, -1
    j reverse_loop
    
reverse_done:
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra

# Print Array Function
# Input: $a0 = array address, $a1 = array size
print_array:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $t0, 0
    
print_loop:
    bge $t0, $a1, print_done
    
    sll $t1, $t0, 2
    add $t1, $a0, $t1
    lw $a0, 0($t1)
    
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    addiu $t0, $t0, 1
    j print_loop
    
print_done:
    li $v0, 4
    la $a0, newline
    syscall
    
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
