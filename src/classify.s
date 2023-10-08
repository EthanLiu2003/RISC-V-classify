.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp) 
    sw s6, 28(sp) 
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    
    #check for errors
    mv s0, a0
    mv s1, a1
    mv s2, a2
    li t0, 5
    bne s0, t0, incorrect_args
    
    # Read pretrained m0
    addi sp, sp, -24
    sw t0, 0(sp) #stores rows of m0
    sw t1, 4(sp) #stores cols of m0
    lw a0, 4(s1)
    add a1, sp, x0
    add a2, sp, x0
    addi a2, a2, 4
    jal ra, read_matrix
    #store in s3, a1, a2 point to the number of rows and columns
    mv s3, a0

    # Read pretrained m1
    sw t2, 8(sp) #stores rows of m1
    sw t3, 12(sp) # stores cols of m1
    lw a0, 8(s1)
    add a1, sp, x0
    add a2, sp, x0
    addi a1, sp, 8
    addi a2, sp, 12
    jal ra, read_matrix
    #store in s4
    mv s4, a0

    # Read input matrix
    sw t4, 16(sp) #stores rows of input
    sw t5, 20(sp) #stores cols of input
    lw a0, 12(s1)
    add a1, sp, x0
    add a2, sp, x0
    addi a1, sp, 16
    addi a2, sp, 20
    jal ra, read_matrix
    #store in s5
    mv s5, a0

    # Compute h = matmul(m0, input)
    #m0 pointer is stored in s3, input pointer is stored in s5
    li a0 0
    lw t0, 0(sp) #num rows of m0
    lw t5, 20(sp) #num cols of input
    mul a0, t0, t5
    li t2, 4
    mul a0, a0, t2
    jal ra, malloc
    beq a0, x0, malloc_error
    mv s6, a0
    
    lw t0, 0(sp) #m0 rows
    lw t1, 4(sp) #m0 cols
    lw t2, 16(sp) #input rows
    lw t3, 20(sp) #input cols
    mv a0, s3
    mv a3, s5
    addi a1, t0, 0
    addi a2, t1, 0
    addi a4, t2, 0
    addi a5, t3, 0
    addi a6, s6, 0
    jal ra, matmul

    # Compute h = relu(h)
    lw t0, 0(sp) #rows = num rows of m0
    lw t5, 20(sp) #cols = num cols of input
    mul a1, t0, t5
    addi a0, s6, 0
    jal ra, relu


    # Compute o = matmul(m1, h)
    #pointer to m1 is s4, pointer to h is s8
    lw t2, 8(sp) #num rows m1
    lw t5, 20(sp) #num cols of h = num cols of input
    mul a0, t2, t5
    li t2, 4
    mul a0, a0, t2
    jal ra, malloc
    beq a0, x0, malloc_error
    mv s7, a0
    
    lw t2, 8(sp) #number of rows of m1
    lw t3, 12(sp) #num cols of m1
    lw t0, 0(sp) #num rows of h = num rows of m0
    lw t5, 20(sp) #num cols of h = num cols of input
    addi a1, t2, 0
    addi a2, t3, 0
    addi a4, t0, 0
    addi a5, t5, 0
    addi a3, s6, 0
    addi a0, s4, 0
    addi a6, s7, 0
    jal ra, matmul

    # Write output matrix o
    lw a0, 16(s1)
    mv a1, s7
    lw t2, 8(sp) #num rows m1
    lw t5, 20(sp) #num cols of h = num cols of input
    addi a2, t2, 0
    addi a3, t5, 0
    jal ra, write_matrix

    # Compute and return argmax(o)
    lw t2, 8(sp) #num rows m1
    lw t5, 20(sp) #num cols of h = num cols of input
    mul a1, t2, t5
    addi a0, s7, 0
    jal ra, argmax
    mv s10, a0
    addi sp, sp, 24

    # If enabled, print argmax(o) and newline
    li t0, 1
    beq t0, s2, finish
    
print:
    mv a0, s10
    jal ra, print_int
    li a0, '\n'
    jal ra, print_char

finish:
    
    mv a0, s3
    jal ra, free

    mv a0, s4
    jal ra, free

    mv a0, s5
    jal ra, free

    mv a0, s6
    jal ra, free

    mv a0, s7
    jal ra, free
    
    mv a0, s10
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48
    jr ra
malloc_error:
    li a0 26
    j exit
incorrect_args:
    li a0 31
    j exit