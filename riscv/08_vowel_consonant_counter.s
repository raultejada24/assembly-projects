# Vowel and Consonant Counter
# String parser using branches based on ASCII character classification
# Demonstrates character comparison and conditional logic
# RISC-V Compatible with RARS/Venus Simulators

.data
    prompt: .asciiz "Enter a string: "
    buffer: .space 256
    vowel_msg: .asciiz "Vowels: "
    consonant_msg: .asciiz "Consonants: "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Print prompt
    la a0, prompt
    li a7, 4
    ecall
    
    # Read string
    li a7, 8
    la a0, buffer
    li a1, 256
    ecall
    
    # Count vowels and consonants
    la a0, buffer
    jal ra, count_vowels_consonants
    
    # a0 = vowel count, a1 = consonant count
    
    # Print vowel count
    la a0, vowel_msg
    li a7, 4
    ecall
    
    li a7, 1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Print consonant count
    la a0, consonant_msg
    li a7, 4
    ecall
    
    li a7, 1
    mv a0, a1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Exit
    li a7, 10
    ecall

# Count vowels and consonants
# Input: a0 = string address
# Output: a0 = vowel count, a1 = consonant count
count_vowels_consonants:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    li t0, 0            # Vowel counter
    li t1, 0            # Consonant counter
    
count_loop:
    # Load character
    lb t2, 0(a0)
    
    # Check for end of string
    beq t2, zero, count_done
    beq t2, '\n', count_done
    
    # Convert to lowercase for easier comparison
    li t3, 'A'
    li t4, 'Z'
    blt t2, t3, check_lowercase
    bgt t2, t4, check_lowercase
    addi t2, t2, 32     # Convert to lowercase
    
check_lowercase:
    # Check if vowel
    li t3, 'a'
    li t4, 'e'
    li t5, 'i'
    li t6, 'o'
    li t7, 'u'
    
    beq t2, t3, is_vowel
    beq t2, t4, is_vowel
    beq t2, t5, is_vowel
    beq t2, t6, is_vowel
    beq t2, t7, is_vowel
    
    # Check if letter (consonant)
    li t3, 'a'
    li t4, 'z'
    blt t2, t3, not_letter
    bgt t2, t4, not_letter
    
    # It's a consonant
    addi t1, t1, 1
    j next_char
    
is_vowel:
    addi t0, t0, 1
    j next_char
    
not_letter:
    # Skip non-alphabetic characters
    j next_char
    
next_char:
    addi a0, a0, 1
    j count_loop
    
count_done:
    mv a0, t0           # Vowel count to a0
    mv a1, t1           # Consonant count to a1
    
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
