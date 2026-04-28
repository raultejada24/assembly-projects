# Dynamic Stack Data Structure Implementation
# LIFO (Last-In-First-Out) stack using pointer arithmetic
# Demonstrates subroutines, memory management, and stack operations
# MIPS Compatible with MARS Simulator

.data
    stack_base: .space 400      # Stack storage (100 integers * 4 bytes)
    stack_top: .word 0          # Stack pointer
    push_msg: .asciiz "Pushed: "
    pop_msg: .asciiz "Popped: "
    empty_msg: .asciiz "Stack is empty!\n"
    newline: .asciiz "\n"

.text
.globl main

main:
    # Initialize stack
    la $s0, stack_base      # $s0 = stack base address
    sw $zero, stack_top     # Initialize stack pointer to 0
    
    # Push values: 10, 20, 30, 40, 50
    li $a0, 10
    jal push
    
    li $a0, 20
    jal push
    
    li $a0, 30
    jal push
    
    li $a0, 40
    jal push
    
    li $a0, 50
    jal push
    
    # Pop all values and print them
    jal pop
    li $v0, 4
    la $a0, pop_msg
    syscall
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    jal pop
    li $v0, 4
    la $a0, pop_msg
    syscall
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    jal pop
    li $v0, 4
    la $a0, pop_msg
    syscall
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    # Exit
    li $v0, 10
    syscall

# Push subroutine
# Input: $a0 = value to push
push:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, stack_top       # Get current stack pointer
    la $t1, stack_base
    add $t1, $t1, $t0       # Calculate address
    sw $a0, 0($t1)          # Store value
    
    addiu $t0, $t0, 4       # Increment stack pointer
    sw $t0, stack_top
    
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

# Pop subroutine
# Output: $v0 = popped value
pop:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, stack_top       # Get current stack pointer
    
    # Check if stack is empty
    beq $t0, $zero, pop_empty
    
    addiu $t0, $t0, -4      # Decrement stack pointer
    la $t1, stack_base
    add $t1, $t1, $t0       # Calculate address
    lw $v0, 0($t1)          # Load value
    sw $t0, stack_top
    
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
    
pop_empty:
    li $v0, 4
    la $a0, empty_msg
    syscall
    li $v0, -1              # Return -1 to indicate error
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
