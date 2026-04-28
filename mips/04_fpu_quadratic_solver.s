# Quadratic Equation Solver using FPU (Coprocessor 1)
# Solves ax^2 + bx + c = 0 using floating-point arithmetic
# Calculates discriminant and roots using FPU registers
# MIPS Compatible with MARS Simulator (with FPU support)

.data
    prompt_a: .asciiz "Enter coefficient a: "
    prompt_b: .asciiz "Enter coefficient b: "
    prompt_c: .asciiz "Enter coefficient c: "
    root1_msg: .asciiz "Root 1: "
    root2_msg: .asciiz "Root 2: "
    discriminant_msg: .asciiz "Discriminant: "
    no_real_roots: .asciiz "No real roots (negative discriminant)\n"
    newline: .asciiz "\n"
    
    # Constants
    two: .float 2.0
    four: .float 4.0

.text
.globl main

main:
    # Read coefficient a
    li $v0, 4
    la $a0, prompt_a
    syscall
    
    li $v0, 6           # Read float syscall
    syscall
    mov.s $f0, $f0      # Move to $f0 (coefficient a)
    
    # Read coefficient b
    li $v0, 4
    la $a0, prompt_b
    syscall
    
    li $v0, 6
    syscall
    mov.s $f2, $f0      # Move to $f2 (coefficient b)
    
    # Read coefficient c
    li $v0, 4
    la $a0, prompt_c
    syscall
    
    li $v0, 6
    syscall
    mov.s $f4, $f0      # Move to $f4 (coefficient c)
    
    # Calculate discriminant: b^2 - 4ac
    mul.s $f6, $f2, $f2     # b^2
    lwc1 $f8, four
    mul.s $f10, $f8, $f0    # 4a
    mul.s $f10, $f10, $f4   # 4ac
    sub.s $f6, $f6, $f10    # b^2 - 4ac
    
    # Print discriminant
    li $v0, 4
    la $a0, discriminant_msg
    syscall
    
    li $v0, 2           # Print float syscall
    mov.s $f12, $f6
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Check if discriminant is negative
    li.s $f14, 0.0
    c.lt.s $f6, $f14
    bc1t no_real_roots_label
    
    # Calculate sqrt(discriminant)
    sqrt.s $f6, $f6
    
    # Root 1: (-b + sqrt(discriminant)) / (2a)
    neg.s $f12, $f2         # -b
    add.s $f12, $f12, $f6   # -b + sqrt(discriminant)
    lwc1 $f14, two
    mul.s $f14, $f14, $f0   # 2a
    div.s $f12, $f12, $f14
    
    # Print root 1
    li $v0, 4
    la $a0, root1_msg
    syscall
    
    li $v0, 2
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Root 2: (-b - sqrt(discriminant)) / (2a)
    neg.s $f12, $f2         # -b
    sub.s $f12, $f12, $f6   # -b - sqrt(discriminant)
    lwc1 $f14, two
    mul.s $f14, $f14, $f0   # 2a
    div.s $f12, $f12, $f14
    
    # Print root 2
    li $v0, 4
    la $a0, root2_msg
    syscall
    
    li $v0, 2
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Exit
    li $v0, 10
    syscall
    
no_real_roots_label:
    li $v0, 4
    la $a0, no_real_roots
    syscall
    
    li $v0, 10
    syscall
