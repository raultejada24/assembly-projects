# String Length Calculator (strlen)
# Calculates the length of a null-terminated string
# Traverses string until null terminator is found
# MIPS Compatible with MARS Simulator

.data
    prompt: .asciiz "Enter a string: "
    result_msg: .asciiz "String length: "
    buffer: .space 256
    newline: .asciiz "\n"

.text
.globl main

main:
    # Print prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Read string
    li $v0, 8
    la $a0, buffer
    li $a1, 256
    syscall
    
    # Calculate length
    la $a0, buffer
    jal strlen
    move $s0, $v0       # Save length
    
    # Print result message
    li $v0, 4
    la $a0, result_msg
    syscall
    
    # Print length
    li $v0, 1
    move $a0, $s0
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Exit
    li $v0, 10
    syscall

# strlen Function
# Input: $a0 = string address
# Output: $v0 = string length (excluding null terminator and newline)
strlen:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $v0, 0           # Length counter
    
strlen_loop:
    lb $t0, 0($a0)      # Load character
    
    # Check for null terminator or newline
    beq $t0, '\0', strlen_done
    beq $t0, '\n', strlen_done
    
    # Increment length
    addiu $v0, $v0, 1
    addiu $a0, $a0, 1
    j strlen_loop
    
strlen_done:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
