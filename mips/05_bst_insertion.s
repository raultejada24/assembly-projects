# Binary Search Tree (BST) Implementation
# Demonstrates dynamic node allocation and recursive insertion
# Simulates malloc-like behavior for node creation
# MIPS Compatible with MARS Simulator

.data
    # Node structure: 12 bytes per node (value:4, left:4, right:4)
    heap: .space 10000              # Heap for node allocation
    heap_ptr: .word 0               # Current heap pointer
    
    insert_msg: .asciiz "Inserting: "
    inorder_msg: .asciiz "In-order traversal: "
    space: .asciiz " "
    newline: .asciiz "\n"
    root_ptr: .word 0               # Pointer to root node

.text
.globl main

main:
    # Insert values into BST
    li $a0, 50
    jal bst_insert
    
    li $a0, 30
    jal bst_insert
    
    li $a0, 70
    jal bst_insert
    
    li $a0, 20
    jal bst_insert
    
    li $a0, 40
    jal bst_insert
    
    li $a0, 60
    jal bst_insert
    
    li $a0, 80
    jal bst_insert
    
    # Print in-order traversal
    li $v0, 4
    la $a0, inorder_msg
    syscall
    
    lw $a0, root_ptr
    jal inorder_traversal
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Exit
    li $v0, 10
    syscall

# Allocate a new node
# Output: $v0 = pointer to new node
allocate_node:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, heap_ptr
    lw $v0, 0($t0)
    la $t1, heap
    add $v0, $v0, $t1
    
    # Initialize node
    sw $zero, 0($v0)    # value = 0
    sw $zero, 4($v0)    # left = NULL
    sw $zero, 8($v0)    # right = NULL
    
    # Update heap pointer
    lw $t2, 0($t0)
    addiu $t2, $t2, 12
    sw $t2, 0($t0)
    
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

# Insert value into BST
# Input: $a0 = value to insert
bst_insert:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, root_ptr
    beq $t0, $zero, insert_at_root
    
    move $a1, $t0
    jal insert_recursive
    
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
    
insert_at_root:
    jal allocate_node
    sw $a0, 0($v0)
    sw $v0, root_ptr
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

# Recursive insert
# Input: $a0 = value, $a1 = current node pointer
insert_recursive:
    addiu $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a1, 4($sp)
    
    lw $t0, 0($a1)      # Load node value
    
    ble $a0, $t0, insert_left
    
    # Insert right
    lw $t1, 8($a1)      # Load right pointer
    beq $t1, $zero, insert_right_new
    move $a1, $t1
    jal insert_recursive
    lw $a1, 4($sp)
    sw $v0, 8($a1)
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra
    
insert_right_new:
    jal allocate_node
    sw $a0, 0($v0)
    lw $a1, 4($sp)
    sw $v0, 8($a1)
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra
    
insert_left:
    lw $t1, 4($a1)      # Load left pointer
    beq $t1, $zero, insert_left_new
    move $a1, $t1
    jal insert_recursive
    lw $a1, 4($sp)
    sw $v0, 4($a1)
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra
    
insert_left_new:
    jal allocate_node
    sw $a0, 0($v0)
    lw $a1, 4($sp)
    sw $v0, 4($a1)
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra

# In-order traversal
# Input: $a0 = node pointer
inorder_traversal:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    beq $a0, $zero, traversal_done
    
    # Traverse left
    lw $a1, 4($a0)
    move $a0, $a1
    jal inorder_traversal
    
    # Print current node
    lw $a0, 4($sp)
    lw $a1, 0($a0)
    li $v0, 1
    move $a0, $a1
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # Traverse right
    lw $a0, 4($sp)
    lw $a1, 8($a0)
    move $a0, $a1
    jal inorder_traversal
    
traversal_done:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra
