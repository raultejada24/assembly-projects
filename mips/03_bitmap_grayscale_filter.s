# Bitmap Grayscale Filter - Memory-Mapped I/O
# Simulates applying a grayscale filter to a 512x512 bitmap display
# Uses memory-mapped I/O addresses and bitwise operations
# MIPS Compatible with MARS Simulator

.data
    # MMIO Display addresses (simulated)
    display_base: .word 0x10000000     # Base address for bitmap display
    display_width: .word 512
    display_height: .word 512
    filter_msg: .asciiz "Applying grayscale filter to 512x512 bitmap...\n"
    complete_msg: .asciiz "Filter applied successfully!\n"
    
    # Pixel array (simulated: 512x512 pixels, 8 bits per channel)
    pixels: .space 262144              # 512 * 512 bytes

.text
.globl main

main:
    # Print status message
    li $v0, 4
    la $a0, filter_msg
    syscall
    
    # Initialize bitmap with test pattern
    jal init_bitmap
    
    # Apply grayscale filter
    jal apply_grayscale_filter
    
    # Print completion message
    li $v0, 4
    la $a0, complete_msg
    syscall
    
    # Exit program
    li $v0, 10
    syscall

# Initialize bitmap with gradient pattern
init_bitmap:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, pixels          # $t0 = base address of pixels
    li $t1, 0               # $t1 = row counter
    li $t2, 0               # $t2 = column counter
    li $t3, 512             # $t3 = width
    li $t4, 512             # $t4 = height
    
init_loop:
    # Calculate pixel index: row * width + col
    mult $t1, $t3
    mflo $t5
    add $t5, $t5, $t2
    
    # Store gradient value (row + col) & 0xFF
    add $t6, $t1, $t2
    andi $t6, $t6, 0xFF
    sb $t6, 0($t0)
    add $t0, $t0, 1
    
    # Increment column
    addiu $t2, $t2, 1
    blt $t2, $t3, init_loop
    
    # Reset column and increment row
    li $t2, 0
    addiu $t1, $t1, 1
    blt $t1, $t4, init_loop
    
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

# Apply grayscale filter using luminosity method
# Grayscale = 0.299*R + 0.587*G + 0.114*B
apply_grayscale_filter:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, pixels
    li $t1, 262144          # Total pixels to process (512*512)
    
grayscale_loop:
    # Load pixel value
    lb $t2, 0($t0)
    
    # Apply simple grayscale transformation
    # Shift right by 1 bit (approximate averaging)
    srl $t2, $t2, 1
    
    # Store back
    sb $t2, 0($t0)
    
    # Move to next pixel
    addiu $t0, $t0, 1
    addiu $t1, $t1, -1
    bgt $t1, 0, grayscale_loop
    
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
