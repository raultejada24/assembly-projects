# Heap Memory Allocator (malloc/free simulation)
# Primitive dynamic memory allocation using heap pointer
# Demonstrates memory management and pointer arithmetic
# RISC-V Compatible with RARS/Venus Simulators

.data
    heap: .space 1000               # Simulated heap
    heap_ptr: .word heap            # Current heap pointer
    heap_end: .word heap + 1000     # End of heap
    
    alloc_msg: .asciiz "Allocated "
    bytes_msg: .asciiz " bytes at address: "
    space: .asciiz "\n"
    out_of_memory: .asciiz "Out of memory!\n"

.text
.globl main

main:
    # Allocate 16 bytes
    li a0, 16
    jal ra, malloc
    beq a0, -1, alloc_error
    
    # Print allocation message
    la a0, alloc_msg
    li a7, 4
    ecall
    
    li a7, 1
    li a0, 16
    ecall
    
    la a0, bytes_msg
    li a7, 4
    ecall
    
    li a7, 1
    ecall
    
    la a0, space
    li a7, 4
    ecall
    
    # Allocate another 32 bytes
    li a0, 32
    jal ra, malloc
    beq a0, -1, alloc_error
    
    # Allocate 64 bytes
    li a0, 64
    jal ra, malloc
    beq a0, -1, alloc_error
    
    j exit_prog
    
alloc_error:
    la a0, out_of_memory
    li a7, 4
    ecall
    
exit_prog:
    li a7, 10
    ecall

# malloc function
# Input: a0 = number of bytes to allocate
# Output: a0 = address of allocated memory, -1 if failed
malloc:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Get current heap pointer
    la t0, heap_ptr
    lw t1, 0(t0)
    
    # Calculate new heap pointer
    add t2, t1, a0
    
    # Check if within bounds
    la t3, heap_end
    lw t4, 0(t3)
    bgt t2, t4, malloc_fail
    
    # Update heap pointer
    sw t2, 0(t0)
    
    # Return allocated address
    mv a0, t1
    
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
    
malloc_fail:
    li a0, -1
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

# free function (simplified - just returns, no actual deallocation)
# Input: a0 = address to free
free:
    # In a simple allocator, free doesn't do much
    # A real implementation would track block sizes
    jr ra
