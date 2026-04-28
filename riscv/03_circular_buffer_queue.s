# Circular Buffer (FIFO Queue) Implementation
# FIFO data structure with modulo arithmetic for wrap-around pointers
# Demonstrates ring buffer management and pointer manipulation
# RISC-V Compatible with RARS/Venus Simulators

.data
    buffer_size: .word 8
    buffer: .space 32               # 8 elements * 4 bytes
    head: .word 0                   # Head pointer
    tail: .word 0                   # Tail pointer
    count: .word 0                  # Number of elements
    
    enqueue_msg: .asciiz "Enqueued: "
    dequeue_msg: .asciiz "Dequeued: "
    queue_full: .asciiz "Queue is full!\n"
    queue_empty: .asciiz "Queue is empty!\n"
    space: .asciiz " "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Enqueue values 10, 20, 30, 40
    li a0, 10
    jal ra, enqueue
    
    li a0, 20
    jal ra, enqueue
    
    li a0, 30
    jal ra, enqueue
    
    li a0, 40
    jal ra, enqueue
    
    # Dequeue and print values
    jal ra, dequeue
    beq a0, -1, deq_empty
    
    la a0, dequeue_msg
    li a7, 4
    ecall
    
    li a7, 1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    j main_end
    
deq_empty:
    la a0, queue_empty
    li a7, 4
    ecall
    
main_end:
    li a7, 10
    ecall

# Enqueue function
# Input: a0 = value to enqueue
enqueue:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Check if queue is full
    lw t0, count
    lw t1, buffer_size
    bge t0, t1, enqueue_full
    
    # Calculate tail position
    lw t2, tail
    lw t3, buffer_size
    
    # Add element to buffer
    la t4, buffer
    sll t5, t2, 2       # Multiply by 4 (word size)
    add t5, t4, t5
    sw a0, 0(t5)
    
    # Print enqueue message
    la a0, enqueue_msg
    li a7, 4
    ecall
    
    li a7, 1
    ecall
    
    la a0, space
    li a7, 4
    ecall
    
    # Update tail pointer (circular)
    addi t2, t2, 1
    rem t2, t2, t3      # t2 = (t2 + 1) % buffer_size
    sw t2, tail
    
    # Increment count
    addi t0, t0, 1
    sw t0, count
    
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
    
enqueue_full:
    la a0, queue_full
    li a7, 4
    ecall
    
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

# Dequeue function
# Output: a0 = dequeued value, -1 if empty
dequeue:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Check if queue is empty
    lw t0, count
    beq t0, zero, dequeue_empty
    
    # Get head pointer
    lw t1, head
    lw t2, buffer_size
    
    # Load element from buffer
    la t3, buffer
    sll t4, t1, 2
    add t4, t3, t4
    lw a0, 0(t4)
    
    # Update head pointer (circular)
    addi t1, t1, 1
    rem t1, t1, t2      # t1 = (t1 + 1) % buffer_size
    sw t1, head
    
    # Decrement count
    addi t0, t0, -1
    sw t0, count
    
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
    
dequeue_empty:
    li a0, -1
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
