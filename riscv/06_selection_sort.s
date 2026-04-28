# Selection Sort Algorithm
# Array sorting by iteratively finding and swapping minimum elements
# Demonstrates finding minimum element and in-place swapping
# RISC-V Compatible with RARS/Venus Simulators

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
    la a0, unsorted_msg
    li a7, 4
    ecall
    
    la a0, array
    li a1, 8
    jal ra, print_array
    
    # Sort the array
    la a0, array
    li a1, 8
    jal ra, selection_sort
    
    # Print sorted array
    la a0, sorted_msg
    li a7, 4
    ecall
    
    la a0, array
    li a1, 8
    jal ra, print_array
    
    # Exit
    li a7, 10
    ecall

# Selection Sort Function
# Input: a0 = array address, a1 = array size
selection_sort:
    addi sp, sp, -12
    sw ra, 8(sp)
    sw a0, 4(sp)
    sw a1, 0(sp)
    
    li t0, 0            # i (outer loop counter)
    
outer_loop:
    bge t0, a1, sort_done
    
    # Find minimum from i to end
    mv a2, t0           # min_index = i
    mv a3, t0
    addi a3, a3, 1      # j = i + 1
    
find_min_loop:
    bge a3, a1, min_found
    
    # Load array[j] and array[min_index]
    sll t1, a3, 2
    add t1, a0, t1
    lw t2, 0(t1)
    
    sll t3, a2, 2
    add t3, a0, t3
    lw t4, 0(t3)
    
    # If array[j] < array[min_index], update min_index
    bge t2, t4, min_not_found
    mv a2, a3
    
min_not_found:
    addi a3, a3, 1
    j find_min_loop
    
min_found:
    # Swap array[i] and array[min_index]
    sll t1, t0, 2
    add t1, a0, t1
    lw t2, 0(t1)
    
    sll t3, a2, 2
    add t3, a0, t3
    lw t4, 0(t3)
    
    sw t4, 0(t1)
    sw t2, 0(t3)
    
    addi t0, t0, 1
    j outer_loop
    
sort_done:
    lw ra, 8(sp)
    addi sp, sp, 12
    jr ra

# Print Array Function
# Input: a0 = array address, a1 = array size
print_array:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    li t0, 0
    
print_loop:
    bge t0, a1, print_done
    
    sll t1, t0, 2
    add t1, a0, t1
    lw a0, 0(t1)
    
    li a7, 1
    ecall
    
    la a0, space
    li a7, 4
    ecall
    
    addi t0, t0, 1
    j print_loop
    
print_done:
    la a0, newline
    li a7, 4
    ecall
    
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
