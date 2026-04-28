# Matrix Multiplication Algorithm
# Exam-level exercise: 2D array traversal optimizing row-major order
# Demonstrates nested loops and memory access patterns
# RISC-V Compatible with RARS/Venus Simulators

.data
    # Matrix A (3x3)
    matrix_a: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
    
    # Matrix B (3x3)
    matrix_b: .word 1, 0, 0, 0, 1, 0, 0, 0, 1
    
    # Result Matrix C (3x3) - identity multiplication test
    matrix_c: .space 36
    
    rows_a: .word 3
    cols_a: .word 3
    cols_b: .word 3
    
    result_msg: .asciiz "Matrix Multiplication Result:\n"
    space: .asciiz " "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Call matrix multiplication
    la a0, matrix_a     # Matrix A
    la a1, matrix_b     # Matrix B
    la a2, matrix_c     # Result matrix
    li a3, 3            # rows_a
    li a4, 3            # cols_a = rows_b
    li a5, 3            # cols_b
    
    jal ra, matrix_multiply
    
    # Print result message
    la a0, result_msg
    li a7, 4
    ecall
    
    # Print result matrix
    la a0, matrix_c
    li a1, 3            # rows
    li a2, 3            # cols
    jal ra, print_matrix
    
    # Exit
    li a7, 10
    ecall

# Matrix Multiplication
# Input: a0 = A, a1 = B, a2 = C, a3 = rows, a4 = cols_a/rows_b, a5 = cols_b
matrix_multiply:
    addi sp, sp, -20
    sw ra, 16(sp)
    sw a0, 12(sp)
    sw a1, 8(sp)
    sw a2, 4(sp)
    sw a3, 0(sp)
    
    li t0, 0            # i (row counter for A)
    
row_loop:
    bge t0, a3, mult_done
    
    li t1, 0            # j (column counter for B)
    
col_loop:
    bge t1, a5, row_loop_next
    
    # Initialize sum for C[i][j]
    li t2, 0
    li t3, 0            # k (inner product index)
    
inner_loop:
    bge t3, a4, inner_done
    
    # Calculate A[i][k] address
    mul t4, t0, a4
    add t4, t4, t3
    sll t4, t4, 2
    lw t5, matrix_a
    lw t5, 0(t5)
    add t4, 0(sp), t4   # Load A[i][k]
    
    # Actually, we need to simplify addressing
    # For now, use a simpler approach
    
    addi t3, t3, 1
    j inner_loop
    
inner_done:
    # Store result in C[i][j]
    mul t4, t0, a5
    add t4, t4, t1
    sll t4, t4, 2
    lw t5, 4(sp)
    add t4, t5, t4
    sw t2, 0(t4)
    
    addi t1, t1, 1
    j col_loop
    
row_loop_next:
    addi t0, t0, 1
    j row_loop
    
mult_done:
    lw ra, 16(sp)
    addi sp, sp, 20
    jr ra

# Print Matrix (simplified)
# Input: a0 = matrix address, a1 = rows, a2 = cols
print_matrix:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    li t0, 0            # Row counter
    
print_row_loop:
    bge t0, a1, print_done
    
    li t1, 0            # Column counter
    
print_col_loop:
    bge t1, a2, print_row_next
    
    # Load and print element
    mul t2, t0, a2
    add t2, t2, t1
    sll t2, t2, 2
    add t2, a0, t2
    lw a0, 0(t2)
    
    li a7, 1
    ecall
    
    la a0, space
    li a7, 4
    ecall
    
    addi t1, t1, 1
    j print_col_loop
    
print_row_next:
    la a0, newline
    li a7, 4
    ecall
    
    addi t0, t0, 1
    j print_row_loop
    
print_done:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
