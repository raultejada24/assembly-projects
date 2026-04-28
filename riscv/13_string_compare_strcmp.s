# String Comparison (strcmp)
# Compares two strings character by character
# Returns comparison result
# RISC-V Compatible with RARS/Venus Simulators

.data
    str1_prompt: .asciiz "Enter first string: "
    str2_prompt: .asciiz "Enter second string: "
    str1_buffer: .space 256
    str2_buffer: .space 256
    
    equal_msg: .asciiz "Strings are equal!\n"
    first_less_msg: .asciiz "First string is less than second.\n"
    first_greater_msg: .asciiz "First string is greater than second.\n"

.text
.globl main

main:
    # Read first string
    la a0, str1_prompt
    li a7, 4
    ecall
    
    li a7, 8
    la a0, str1_buffer
    li a1, 256
    ecall
    
    # Read second string
    la a0, str2_prompt
    li a7, 4
    ecall
    
    li a7, 8
    la a0, str2_buffer
    li a1, 256
    ecall
    
    # Compare strings
    la a0, str1_buffer
    la a1, str2_buffer
    jal ra, strcmp
    
    # a0 = 0 if equal, < 0 if first < second, > 0 if first > second
    
    beq a0, zero, strings_equal
    blt a0, zero, first_less
    
    # First greater
    la a0, first_greater_msg
    li a7, 4
    ecall
    j exit_prog
    
first_less:
    la a0, first_less_msg
    li a7, 4
    ecall
    j exit_prog
    
strings_equal:
    la a0, equal_msg
    li a7, 4
    ecall
    
exit_prog:
    li a7, 10
    ecall

# strcmp Function
# Input: a0 = string1, a1 = string2
# Output: a0 = 0 if equal, negative if s1 < s2, positive if s1 > s2
strcmp:
    addi sp, sp, -4
    sw ra, 0(sp)
    
strcmp_loop:
    # Load characters
    lb t0, 0(a0)
    lb t1, 0(a1)
    
    # Check for end of either string
    beq t0, zero, check_s2_end
    beq t1, zero, s1_greater
    
    # Compare characters
    bne t0, t1, chars_different
    
    # Move to next characters
    addi a0, a0, 1
    addi a1, a1, 1
    j strcmp_loop
    
check_s2_end:
    beq t1, zero, strings_equal_result
    j s1_less
    
chars_different:
    # s1[i] - s2[i]
    sub a0, t0, t1
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
    
s1_greater:
    li a0, 1
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
    
s1_less:
    li a0, -1
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
    
strings_equal_result:
    li a0, 0
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
