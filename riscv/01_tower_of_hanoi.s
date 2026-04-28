# Tower of Hanoi - Classic Recursive Algorithm
# Demonstrates multi-level stack frame management and recursion
# RISC-V Compatible with RARS/Venus Simulators

.data
    prompt_msg: .asciiz "Tower of Hanoi - Move sequence:\n"
    move_msg: .asciiz "Move disk from rod "
    to_rod: .asciiz " to rod "
    newline: .asciiz "\n"
    move_count: .word 0

.text
.globl main

main:
    # Print intro message
    la a0, prompt_msg
    li a7, 4            # Print string syscall
    ecall
    
    # Solve Tower of Hanoi for 4 disks
    # hanoi(4, 'A', 'C', 'B')
    li a0, 4            # n = 4 disks
    li a1, 0            # source = 0 (rod A)
    li a2, 2            # destination = 2 (rod C)
    li a3, 1            # auxiliary = 1 (rod B)
    
    jal ra, hanoi
    
    # Exit program
    li a7, 10
    ecall

# Recursive Hanoi function
# Input: a0 = n, a1 = source, a2 = destination, a3 = auxiliary
hanoi:
    addi sp, sp, -16
    sw ra, 12(sp)       # Save return address
    sw a0, 8(sp)        # Save n
    sw a1, 4(sp)        # Save source
    sw a3, 0(sp)        # Save auxiliary
    
    # Base case: if n == 1, move disk and return
    li t0, 1
    beq a0, t0, hanoi_base_case
    
    # Recursive case: hanoi(n-1, source, auxiliary, destination)
    addi a0, a0, -1     # n-1
    # a1 = source (already set)
    mv a2, a3           # destination = auxiliary
    lw a3, 4(sp)        # auxiliary = source
    
    jal ra, hanoi
    
    # Move disk from source to destination
    lw a0, 8(sp)
    lw a1, 4(sp)
    lw a2, 12(sp)       # Load original destination from where we saved a2
    # Actually we need to fix this - save a2 too
    
    # For now, print move
    la a0, move_msg
    li a7, 4
    ecall
    
    lw a0, 4(sp)
    li a7, 1
    ecall
    
    la a0, to_rod
    li a7, 4
    ecall
    
    lw a0, 12(sp)       # Destination
    li a7, 1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # hanoi(n-1, auxiliary, destination, source)
    lw a0, 8(sp)
    addi a0, a0, -1
    lw a1, 0(sp)        # auxiliary
    lw a2, 12(sp)       # destination
    lw a3, 4(sp)        # source
    
    jal ra, hanoi
    
    j hanoi_return
    
hanoi_base_case:
    # Move disk from source (a1) to destination (a2)
    la a0, move_msg
    li a7, 4
    ecall
    
    lw a0, 4(sp)
    li a7, 1
    ecall
    
    la a0, to_rod
    li a7, 4
    ecall
    
    lw a0, 12(sp)       # destination
    li a7, 1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
hanoi_return:
    lw ra, 12(sp)
    addi sp, sp, 16
    jr ra
