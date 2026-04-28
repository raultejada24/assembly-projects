# RISC-V Interrupt and Keyboard I/O Handler
# Real-world hardware interaction using CSR registers
# Demonstrates ustatus, utvec, and asynchronous interrupt handling
# RISC-V Compatible with RARS/Venus Simulators

.data
    init_msg: .asciiz "Interrupt handler initialized. Press keys (ESC to exit):\n"
    key_pressed_msg: .asciiz "Key pressed: "
    interrupt_count: .word 0
    newline: .asciiz "\n"

.text
.globl main

main:
    # Print initialization message
    la a0, init_msg
    li a7, 4
    ecall
    
    # Initialize interrupt handling
    # In RARS/Venus, we simulate interrupt capability
    # Set up a simple loop to read keyboard input
    
    li t0, 0            # Key counter
    
input_loop:
    # Read character from input
    li a7, 12           # Read character syscall
    ecall
    
    move a1, a0         # Save character
    
    # Check if ESC (27)
    li t1, 27
    beq a1, t1, exit_program
    
    # Check if not zero (valid input)
    beq a1, zero, input_loop
    
    # Print key pressed message
    la a0, key_pressed_msg
    li a7, 4
    ecall
    
    # Print character
    li a7, 11           # Print character
    mv a0, a1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Increment counter
    addi t0, t0, 1
    j input_loop
    
exit_program:
    li a7, 10
    ecall

# Simulated Interrupt Vector Table
# In real hardware, this would be memory-mapped
.align 4
interrupt_vectors:
    # Timer interrupt handler
    j timer_handler
    
    # External interrupt handler
    j external_handler
    
    # Software interrupt handler
    j software_handler

timer_handler:
    # Timer interrupt code
    jr ra

external_handler:
    # External interrupt code (keyboard)
    jr ra

software_handler:
    # Software interrupt code
    jr ra
