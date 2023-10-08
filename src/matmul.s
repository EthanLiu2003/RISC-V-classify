.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    li t0 1
    blt a1, t0, error38
    blt a2, t0, error38
    blt a4, t0, error38
    blt a5, t0, error38
    bne a2, a4, error38
    

    # Prologue
    
    addi sp, sp, -44
    #store a0-a6 then 2 counters
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    li s7, 0 #counter1
    mv s9, a3 #store value of a3 before we change a3
outer_loop_start:
    bge s7, s1, outer_loop_end
    li s8, 0 #counter2


inner_loop_start:
    bge s8, s5, inner_loop_end
    
    #setting up for jal dot call
    add a0, x0, s0
    add a1, x0, s3
    add a2, x0, s2
    addi a3, x0, 1
    addi a4, s5, 0
    #call dot
    jal ra, dot
    #store result in pointer to matrix
    sw a0 0(s6)
    #increment result pointer by an integer (4 bytes)
    addi s6, s6, 4
    addi s3, s3, 4
    addi s8, s8, 1
    
    j inner_loop_start
    
    

inner_loop_end:
    #incremenet s7 counter by 1
    addi s7, s7, 1
    slli t1, s2, 2
    add s0, t1, s0
    mv s3, s9
    j outer_loop_start



outer_loop_end:
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


    # Epilogue
    jr ra

error38:
    li a0, 38         
    j exit