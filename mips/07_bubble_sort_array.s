# Bubble Sort Algorithm
# In-place array sorting with nested loops and element swapping
# Demonstrates loop control and conditional swapping
# MIPS Compatible with MARS Simulator

.data
    array: .word 64, 34, 25, 12, 22, 11, 90, 88
    array_size: .word 8
    
    unsorted_msg: .asciiz "Unsorted array: "
    sorted_msg: .asciiz "Sorted array: "
    space: .asciiz " "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Print unsorted array
    li $v0, 4
    la $a0, unsorted_msg
    syscall
    
    la $a0, array
    li $a1, 8
    jal print_array
    
    # Sort the array
    la $a0, array
    li $a1, 8
    jal bubble_sort
    
    # Print sorted array
    li $v0, 4
    la $a0, sorted_msg
    syscall
    
    la $a0, array
    li $a1, 8
    jal print_array
    
    # Exit
    li $v0, 10
    syscall

# Bubble Sort Function
# Input: $a0 = array address, $a1 = array size
bubble_sort:
    addiu $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a0, 4($sp)      # Save array address
    sw $a1, 8($sp)      # Save array size
    
    # Outer loop: $t0 = i
    li $t0, 0
    
outer_loop:
    bge $t0, $a1, sort_done
    
    # Inner loop: $t1 = j
    li $t1, 0
    
inner_loop:
    # Check if j < size - i - 1
    sub $t2, $a1, $t0
    addiu $t2, $t2, -1
    bge $t1, $t2, outer_loop_next
    
    # Load array[j]
    sll $t3, $t1, 2
    add $t3, $a0, $t3
    lw $t4, 0($t3)
    
    # Load array[j+1]
    addiu $t5, $t1, 1
    sll $t5, $t5, 2
    add $t5, $a0, $t5
    lw $t6, 0($t5)
    
    # If array[j] <= array[j+1], no swap needed
    ble $t4, $t6, inner_loop_next
    
    # Swap array[j] and array[j+1]
    sw $t6, 0($t3)
    sw $t4, 0($t5)
    
inner_loop_next:
    addiu $t1, $t1, 1
    j inner_loop
    
outer_loop_next:
    addiu $t0, $t0, 1
    j outer_loop
    
sort_done:
    lw $ra, 0($sp)
    addiu $sp, $sp, 12
    jr $ra

# Print Array Function
# Input: $a0 = array address, $a1 = array size
print_array:
    addiu $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    
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
    addiu $sp, $sp, 8
    jr $ra
