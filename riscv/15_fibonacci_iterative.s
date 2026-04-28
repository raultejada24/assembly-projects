# Fibonacci Number Generator (Iterative)
# Loop-based Fibonacci generator utilizing registers instead of stack
# Demonstrates iterative computation with register rotation
# RISC-V Compatible with RARS/Venus Simulators

.data
    prompt: .asciiz "Enter n: "
    result_msg: .asciiz "Fibonacci("
    equals: .asciiz ") = "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Read input
    la a0, prompt
    li a7, 4
    ecall
    
    li a7, 5
    ecall
    mv s0, a0           # Save n
    
    # Calculate iterative Fibonacci
    mv a0, s0
    jal ra, fibonacci_iterative
    mv s1, a0           # Save result
    
    # Print result message
    la a0, result_msg
    li a7, 4
    ecall
    
    li a7, 1
    mv a0, s0
    ecall
    
    la a0, equals
    li a7, 4
    ecall
    
    li a7, 1
    mv a0, s1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Exit
    li a7, 10
    ecall

# Iterative Fibonacci Function
# Input: a0 = n
# Output: a0 = fib(n)
fibonacci_iterative:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Handle base cases
    li t0, 2
    blt a0, t0, fib_base_case
    
    li t1, 0            # fib(0)
    li t2, 1            # fib(1)
    li t3, 2            # Counter
    
fib_loop:
    bgt t3, a0, fib_done
    
    # Calculate next Fibonacci number
    add t4, t1, t2      # fib(i) = fib(i-1) + fib(i-2)
    
    # Shift values: fib(i-1) = fib(i), fib(i) = fib(i+1)
    mv t1, t2
    mv t2, t4
    
    addi t3, t3, 1
    j fib_loop
    
fib_done:
    mv a0, t2
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
    
fib_base_case:
    # fib(0) = 0, fib(1) = 1
    mv a0, a0
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
