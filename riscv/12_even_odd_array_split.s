# Even/Odd Array Split
# Parses one array and splits contents into 'even' and 'odd' arrays
# Demonstrates conditional branching and array manipulation
# RISC-V Compatible with RARS/Venus Simulators

.data
    source: .word 10, 15, 20, 25, 30, 35, 40, 45
    source_size: .word 8
    
    even_array: .space 32
    odd_array: .space 32
    even_count: .word 0
    odd_count: .word 0
    
    source_msg: .asciiz "Source array: "
    even_msg: .asciiz "Even array: "
    odd_msg: .asciiz "Odd array: "
    space: .asciiz " "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Print source array
    la a0, source_msg
    li a7, 4
    ecall
    
    la a0, source
    li a1, 8
    jal ra, print_array
    
    # Split array
    la a0, source
    li a1, 8
    la a2, even_array
    la a3, odd_array
    jal ra, split_even_odd
    
    # Print even array
    la a0, even_msg
    li a7, 4
    ecall
    
    la a0, even_array
    lw a1, even_count
    jal ra, print_array
    
    # Print odd array
    la a0, odd_msg
    li a7, 4
    ecall
    
    la a0, odd_array
    lw a1, odd_count
    jal ra, print_array
    
    # Exit
    li a7, 10
    ecall

# Split array into even and odd
# Input: a0 = source, a1 = size, a2 = even array, a3 = odd array
split_even_odd:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw a2, 0(sp)        # Save even_array address
    
    li t0, 0            # Even counter
    li t1, 0            # Odd counter
    li t2, 0            # Loop counter
    
split_loop:
    bge t2, a1, split_done
    
    # Load element
    sll t3, t2, 2
    add t3, a0, t3
    lw t4, 0(t3)
    
    # Check if even (t4 & 1 == 0)
    andi t5, t4, 1
    beq t5, zero, add_even
    
    # Add to odd array
    sll t5, t1, 2
    add t5, a3, t5
    sw t4, 0(t5)
    addi t1, t1, 1
    j split_next
    
add_even:
    # Add to even array
    sll t5, t0, 2
    add t5, a2, t5
    sw t4, 0(t5)
    addi t0, t0, 1
    
split_next:
    addi t2, t2, 1
    j split_loop
    
split_done:
    # Store counts
    la t2, even_count
    sw t0, 0(t2)
    la t2, odd_count
    sw t1, 0(t2)
    
    lw ra, 4(sp)
    addi sp, sp, 8
    jr ra

# Print Array
# Input: a0 = array, a1 = size
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
