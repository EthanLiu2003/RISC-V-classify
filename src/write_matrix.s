.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -52
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
    mv s3, a3
    
    mv a1, s1 #hi
    
    #open with write permissions
    li a1, 1
    jal fopen
    li t0, -1
    #check for open errors
    beq a0, t0, error27
    #stores file descriptor in s4
    mv s4, a0
    
    #restore pointer to start of matrix in memory
    #mv a1, s1
#     addi a0, x0, 8
#     #malloc storage for the rows and columns of the matrix in memory
#     jal malloc
#     mv s5, a0
#     mv a1, s1 #hi
   
    sw s2, 44(sp)
    sw s3, 48(sp)
    addi a1, sp, 44
    li a2 2 #row and col values, 2 elements
    li a3 4 #each value is 4 bytes
    mv s7 a2
    mv a0, s4
    jal fwrite
    bne a0, s7, error30
    
    #mv a0, a1 # hi
#     mv a0, s5
#     jal ra, free
    
    #reset a0 to pointer to start of filename descriptor
    mv a0, s4
    #reset to pointer at start of matrix in memory
    mv a1, s1
    # addi a1, a1, 8 #move pointer forward 8 bytes to skip row and col values
    mul a2, s2, s3 # number of elements to write
    li s8, 0
    add s8, s8, a2 #store number of elements
    li a3, 4 #each integer is 4 bytes
    jal fwrite #hi
    bne s8, a0, error30
    
    mv a0, s4
    jal fclose
    li t5, -1
    beq a0, t5, error28
    
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
    addi sp, sp, 52


    # Epilogue


    jr ra
  
  
error27:
    li a0 27
    j exit
error28:
    li a0 28
    j exit
error30:
    li a0 30
    j exit
