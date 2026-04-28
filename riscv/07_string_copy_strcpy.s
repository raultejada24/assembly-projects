# String Copy (strcpy) Function
# Deep copy of a string from source address to destination address
# Demonstrates byte-level memory operations and null termination
# RISC-V Compatible with RARS/Venus Simulators

.data
    source_str: .asciiz "Hello, RISC-V!"
    dest_str: .space 32             # Destination buffer
    
    source_msg: .asciiz "Source string: "
    dest_msg: .asciiz "Copied string: "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Print source string
    la a0, source_msg
    li a7, 4
    ecall
    
    la a0, source_str
    li a7, 4
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Copy string
    la a0, source_str
    la a1, dest_str
    jal ra, strcpy
    
    # Print destination string
    la a0, dest_msg
    li a7, 4
    ecall
    
    la a0, dest_str
    li a7, 4
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Exit
    li a7, 10
    ecall

# strcpy Function
# Input: a0 = source address, a1 = destination address
strcpy:
    addi sp, sp, -4
    sw ra, 0(sp)
    
copy_loop:
    # Load character from source
    lb t0, 0(a0)
    
    # Store in destination
    sb t0, 0(a1)
    
    # Check for null terminator
    beq t0, zero, copy_done
    
    # Move to next character
    addi a0, a0, 1
    addi a1, a1, 1
    j copy_loop
    
copy_done:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
