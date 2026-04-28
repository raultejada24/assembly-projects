# Array Sum and Average Calculator
# Traverses an integer array to calculate total sum and average
# Demonstrates accumulation and division operations
# RISC-V Compatible with RARS/Venus Simulators

.data
    array: .word 10, 20, 30, 40, 50, 60, 70, 80
    array_size: .word 8
    
    sum_msg: .asciiz "Sum: "
    average_msg: .asciiz "Average: "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Calculate sum and average
    la a0, array
    li a1, 8
    jal ra, calculate_sum_and_average
    
    # a0 = sum, a1 = average
    
    # Print sum
    la a0, sum_msg
    li a7, 4
    ecall
    
    li a7, 1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Print average
    la a0, average_msg
    li a7, 4
    ecall
    
    li a7, 1
    mv a0, a1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Exit
    li a7, 10
    ecall

# Calculate sum and average
# Input: a0 = array address, a1 = array size
# Output: a0 = sum, a1 = average
calculate_sum_and_average:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw a1, 0(sp)        # Save array size
    
    li t0, 0            # Sum accumulator
    li t1, 0            # Counter
    
sum_loop:
    bge t1, a1, sum_done
    
    # Load element
    sll t2, t1, 2
    add t2, a0, t2
    lw t3, 0(t2)
    
    # Add to sum
    add t0, t0, t3
    
    addi t1, t1, 1
    j sum_loop
    
sum_done:
    # Calculate average = sum / size
    div t0, a1
    mv a1, t0           # Average to a1
    
    # Actually we need to fix: sum should be in a0
    # Let me recalculate
    mv a0, t0           # Sum to a0
    
    # For average, divide sum by size
    lw a1, 0(sp)
    div a0, a1
    
    lw ra, 4(sp)
    addi sp, sp, 8
    jr ra
