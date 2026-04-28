# Power Function (x^y)
# Calculates x raised to the power of y using loops
# Demonstrates iterative computation and register usage
# RISC-V Compatible with RARS/Venus Simulators

.data
    prompt_x: .asciiz "Enter base (x): "
    prompt_y: .asciiz "Enter exponent (y): "
    result_msg: .asciiz " ^ "
    equals: .asciiz " = "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Read base
    la a0, prompt_x
    li a7, 4
    ecall
    
    li a7, 5
    ecall
    mv s0, a0           # Save base in s0
    
    # Read exponent
    la a0, prompt_y
    li a7, 4
    ecall
    
    li a7, 5
    ecall
    mv s1, a0           # Save exponent in s1
    
    # Calculate power
    mv a0, s0           # a0 = base
    mv a1, s1           # a1 = exponent
    jal ra, power
    mv s2, a0           # Save result
    
    # Print result
    li a7, 1
    mv a0, s0
    ecall
    
    la a0, result_msg
    li a7, 4
    ecall
    
    li a7, 1
    mv a0, s1
    ecall
    
    la a0, equals
    li a7, 4
    ecall
    
    li a7, 1
    mv a0, s2
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Exit
    li a7, 10
    ecall

# Power Function
# Input: a0 = base, a1 = exponent
# Output: a0 = result
power:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    li t0, 1            # Result accumulator
    li t1, 0            # Counter
    
    # Handle case where exponent is 0
    beq a1, zero, power_return_one
    
power_loop:
    bge t1, a1, power_done
    
    # Multiply result by base
    mul t0, t0, a0
    
    addi t1, t1, 1
    j power_loop
    
power_done:
    mv a0, t0
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
    
power_return_one:
    li a0, 1
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
