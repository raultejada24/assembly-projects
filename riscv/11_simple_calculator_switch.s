# Simple Calculator with Switch-Case Logic
# Simulates switch statement for basic arithmetic operations
# Demonstrates branching based on operation selection
# RISC-V Compatible with RARS/Venus Simulators

.data
    prompt_menu: .asciiz "1=Add, 2=Sub, 3=Mul, 4=Div. Choose: "
    prompt_a: .asciiz "Enter first number: "
    prompt_b: .asciiz "Enter second number: "
    result_msg: .asciiz "Result: "
    invalid_msg: .asciiz "Invalid operation!\n"
    newline: .asciiz "\n"

.text
.globl main

main:
    # Show menu
    la a0, prompt_menu
    li a7, 4
    ecall
    
    # Read operation choice
    li a7, 5
    ecall
    mv s0, a0           # Save operation choice
    
    # Read first number
    la a0, prompt_a
    li a7, 4
    ecall
    
    li a7, 5
    ecall
    mv s1, a0           # Save first number
    
    # Read second number
    la a0, prompt_b
    li a7, 4
    ecall
    
    li a7, 5
    ecall
    mv s2, a0           # Save second number
    
    # Perform operation based on choice
    mv a0, s0           # Operation
    mv a1, s1           # First number
    mv a2, s2           # Second number
    jal ra, calculate
    mv s3, a0           # Save result
    
    # Print result
    la a0, result_msg
    li a7, 4
    ecall
    
    li a7, 1
    mv a0, s3
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Exit
    li a7, 10
    ecall

# Calculate function (switch-like logic)
# Input: a0 = operation, a1 = first number, a2 = second number
# Output: a0 = result
calculate:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Switch on operation
    li t0, 1
    beq a0, t0, do_add
    
    li t0, 2
    beq a0, t0, do_sub
    
    li t0, 3
    beq a0, t0, do_mul
    
    li t0, 4
    beq a0, t0, do_div
    
    # Invalid operation
    la a0, invalid_msg
    li a7, 4
    ecall
    
    li a0, 0
    j calc_done
    
do_add:
    add a0, a1, a2
    j calc_done
    
do_sub:
    sub a0, a1, a2
    j calc_done
    
do_mul:
    mul a0, a1, a2
    j calc_done
    
do_div:
    div a0, a1, a2
    j calc_done
    
calc_done:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
