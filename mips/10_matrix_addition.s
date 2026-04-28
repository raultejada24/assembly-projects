# Matrix Addition Algorithm
# Adds two 3x3 matrices and stores result in a third matrix
# Demonstrates 2D array indexing and nested loop traversal
# MIPS Compatible with MARS Simulator

.data
    # Matrix A (3x3)
    matrix_a: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
    
    # Matrix B (3x3)
    matrix_b: .word 9, 8, 7, 6, 5, 4, 3, 2, 1
    
    # Result Matrix C (3x3) - initialized to zeros
    matrix_c: .space 36
    
    rows: .word 3
    cols: .word 3
    
    result_msg: .asciiz "Result Matrix:\n"
    space: .asciiz " "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Call matrix addition
    la $a0, matrix_a
    la $a1, matrix_b
    la $a2, matrix_c
    li $a3, 3
    li $t0, 3
    
    jal matrix_add
    
    # Print result message
    li $v0, 4
    la $a0, result_msg
    syscall
    
    # Print result matrix
    la $a0, matrix_c
    li $a1, 3
    li $a2, 3
    jal print_matrix
    
    # Exit
    li $v0, 10
    syscall

# Matrix Addition Function
# Input: $a0 = matrix A, $a1 = matrix B, $a2 = matrix C (result)
#        $a3 = rows, $t0 = cols
matrix_add:
    addiu $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a3, 4($sp)      # Save rows
    sw $t0, 8($sp)      # Save cols
    
    li $t1, 0           # Row counter
    
row_loop:
    bge $t1, $a3, add_done
    
    li $t2, 0           # Column counter
    
col_loop:
    bge $t2, $t0, row_loop_next
    
    # Calculate index: row * cols + col
    mult $t1, $t0
    mflo $t3
    add $t3, $t3, $t2
    
    # Calculate memory offset (multiply by 4 for word size)
    sll $t4, $t3, 2
    
    # Load elements
    add $t5, $a0, $t4
    lw $t6, 0($t5)      # A[row][col]
    
    add $t5, $a1, $t4
    lw $t7, 0($t5)      # B[row][col]
    
    # Add and store
    add $t6, $t6, $t7
    
    add $t5, $a2, $t4
    sw $t6, 0($t5)      # C[row][col] = A[row][col] + B[row][col]
    
    addiu $t2, $t2, 1
    j col_loop
    
row_loop_next:
    addiu $t1, $t1, 1
    j row_loop
    
add_done:
    lw $ra, 0($sp)
    addiu $sp, $sp, 12
    jr $ra

# Print Matrix Function
# Input: $a0 = matrix address, $a1 = rows, $a2 = cols
print_matrix:
    addiu $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    
    li $t1, 0           # Row counter
    
print_row_loop:
    bge $t1, $a1, print_done
    
    li $t2, 0           # Column counter
    
print_col_loop:
    bge $t2, $a2, print_row_next
    
    # Calculate index
    mult $t1, $a2
    mflo $t3
    add $t3, $t3, $t2
    sll $t4, $t3, 2
    
    add $t5, $a0, $t4
    lw $a0, 0($t5)
    
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    addiu $t2, $t2, 1
    j print_col_loop
    
print_row_next:
    li $v0, 4
    la $a0, newline
    syscall
    
    addiu $t1, $t1, 1
    j print_row_loop
    
print_done:
    lw $ra, 0($sp)
    addiu $sp, $sp, 12
    jr $ra
