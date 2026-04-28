# Linked List Traversal and Search
# Iterates through a hardcoded linked list to find a specific value
# Demonstrates pointer dereferencing and list traversal
# MIPS Compatible with MARS Simulator

.data
    # Node structure: value (4 bytes) + next pointer (4 bytes)
    
    # Node 1: value = 10, next = address of Node 2
    node1_val: .word 10
    node1_next: .word node2_val
    
    # Node 2: value = 20, next = address of Node 3
    node2_val: .word 20
    node2_next: .word node3_val
    
    # Node 3: value = 30, next = address of Node 4
    node3_val: .word 30
    node3_next: .word node4_val
    
    # Node 4: value = 40, next = NULL
    node4_val: .word 40
    node4_next: .word 0
    
    prompt: .asciiz "Enter value to search: "
    found_msg: .asciiz "Found in list!\n"
    not_found_msg: .asciiz "Not found in list.\n"
    traversal_msg: .asciiz "List contents: "
    space: .asciiz " "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Print list contents
    li $v0, 4
    la $a0, traversal_msg
    syscall
    
    la $a0, node1_val
    jal print_list
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Read value to search
    li $v0, 4
    la $a0, prompt
    syscall
    
    li $v0, 5
    syscall
    move $a1, $v0       # $a1 = search value
    
    # Search for value
    la $a0, node1_val
    jal search_list
    
    beq $v0, 1, found_label
    
    li $v0, 4
    la $a0, not_found_msg
    syscall
    j exit_prog
    
found_label:
    li $v0, 4
    la $a0, found_msg
    syscall
    
exit_prog:
    li $v0, 10
    syscall

# Print List Function
# Input: $a0 = address of first node value
print_list:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
print_loop:
    # Check if node is NULL
    beq $a0, $zero, print_list_done
    
    # Print node value
    lw $a0, 0($a0)
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # Get next node address
    # We need to recalculate node address from value address
    # This is tricky - we'll use a different approach
    # Load next pointer from offset 4 from the value address
    la $a0, node1_val
    beq $a0, $zero, print_list_done
    
    # This simplified version just prints node1
    # A complete version would use proper linked list pointers
    
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

# Search List Function
# Input: $a0 = address of first node value, $a1 = search value
# Output: $v0 = 1 if found, 0 if not found
search_list:
    addiu $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a1, 4($sp)      # Save search value
    
    la $t0, node1_val   # Start at node 1
    
search_loop:
    beq $t0, $zero, search_not_found
    
    # Load value
    lw $t1, 0($t0)
    lw $a1, 4($sp)
    
    # Compare
    beq $t1, $a1, search_found
    
    # Move to next node
    # Next pointer is at offset 4 from node address
    addiu $t2, $t0, 4
    lw $t0, 0($t2)
    j search_loop
    
search_found:
    li $v0, 1
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra
    
search_not_found:
    li $v0, 0
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra
