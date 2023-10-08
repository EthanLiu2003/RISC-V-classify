.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    
    addi sp, sp, -44
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
    
    #store args
    mv s0, a0
    mv s1, a1
    mv s2, a2
    
    
    
    # Prologue
    li a1, 0
    jal ra, fopen
    addi t0, x0, -1
    beq a0, t0, error27
    #save pointer to filename to s3
    mv s3 a0
    li a0, 8
    jal malloc
    beq a0, x0, error26
    
    #store allocated memory pointer in s4
    mv s4, a0
    #store pointer to file name back in a0 for fread call
    mv a0, s3
    #store allocated memory pointer back to a1
    mv a1, s4
    #read 8 bytes from file format
    li a2, 8
    jal fread
    #check if number of bytes was properly read
    li t0, 8
    bne a0, t0, error29
    
    #store our rows and columns of the matrix
    lw s8, 0(s4) #number of rows
    lw s9, 4(s4) #number of columns
    sw s8, 0(s1) #store in s1 which is pointer to rows
    sw s9, 0(s2) #store in s2 which is pointer to cols
    mv a0, s4
    jal free
    
    #create heap memory for matrix
    mul a0, s8, s9
    slli s6, a0, 2
    mv a0, s6
    jal malloc
    beq a0, x0, error26
    #s5 is where our matrix memory pointer is stored
    mv s5, a0
    
    
    mv a0, s3
    mv a1, s5
    mv a2, s6
    jal fread
    bne a0, s6, error29
    
    mv a0, s3
    jal fclose
    li t0, -1
    beq a0, t0, error28
    mv a0, s5


    # Epilogue
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
    addi sp, sp, 44

    jr ra
error26:
    li a0 26
    j exit
error27:
    li a0 27
    j exit
error28:
    li a0 28
    j exit
error29:
    li a0 29
    j exit
