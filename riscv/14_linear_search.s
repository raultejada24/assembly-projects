# Linear Search Algorithm
# Basic array traversal to find a specific element index
# Returns index if found, -1 if not found
# RISC-V Compatible with RARS/Venus Simulators

.data
    array: .word 45, 23, 67, 12, 89, 34, 56, 78
    array_size: .word 8
    
    prompt: .asciiz "Enter value to search: "
    found_msg: .asciiz "Found at index: "
    not_found_msg: .asciiz "Value not found!\n"
    newline: .asciiz "\n"

.text
.globl main

main:
    # Read search value
    la a0, prompt
    li a7, 4
    ecall
    
    li a7, 5
    ecall
    mv s0, a0           # Save search value
    
    # Perform linear search
    la a0, array
    li a1, 8
    mv a2, s0           # Value to search
    jal ra, linear_search
    
    # Check if found
    li t0, -1
    beq a0, t0, not_found_label
    
    # Print found message
    la a0, found_msg
    li a7, 4
    ecall
    
    li a7, 1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    j exit_prog
    
not_found_label:
    la a0, not_found_msg
    li a7, 4
    ecall
    
exit_prog:
    li a7, 10
    ecall

# Linear Search Function
# Input: a0 = array, a1 = size, a2 = value to search
# Output: a0 = index if found, -1 if not found
linear_search:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    li t0, 0            # Index counter
    
search_loop:
    bge t0, a1, search_not_found
    
    # Load array element
    sll t1, t0, 2
    add t1, a0, t1
    lw t2, 0(t1)
    
    # Compare with search value
    beq t2, a2, search_found
    
    addi t0, t0, 1
    j search_loop
    
search_found:
    mv a0, t0
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
    
search_not_found:
    li a0, -1
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
