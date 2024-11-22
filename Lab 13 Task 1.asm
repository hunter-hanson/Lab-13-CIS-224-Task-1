.data
prompt: .asciiz "Enter the Fibonacci number index (n): "
result: .asciiz "The nth Fibonacci number is: "

.text
.globl main

main:
    # Print prompt
    li $v0, 4
    la $a0, prompt
    syscall

    # Read integer input
    li $v0, 5
    syscall
    move $a0, $v0  # Move input to $a0 for fibonacci function

    # Call fibonacci function
    jal fibonacci

    # Print result
    move $t0, $v0  # Save result
    li $v0, 4
    la $a0, result
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    # Exit program
    li $v0, 10
    syscall

fibonacci:
    # Base cases
    bgt $a0, 1, recursive_case
    move $v0, $a0
    jr $ra

recursive_case:
    # Allocate stack frame
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)

    # Save n
    move $s0, $a0

    # Calculate fib(n-1)
    addi $a0, $s0, -1
    jal fibonacci
    move $s1, $v0  # Save result of fib(n-1)

    # Calculate fib(n-2)
    addi $a0, $s0, -2
    jal fibonacci

    # Calculate fib(n) = fib(n-1) + fib(n-2)
    add $v0, $s1, $v0

    # Restore stack frame
    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12

    jr $ra