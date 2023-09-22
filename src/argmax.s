.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    li   t0, 1
    blt a1, t0, error
    li t1 0
    li t2 0x80000000
    li t3 0


loop_start:
    slli t4, t1, 2
    add t4, t4, a0
    lw t5, 0(t4)
    blt t5, t2, loop_continue
    
    mv t2, t5
    mv t3, t1


loop_continue:
    addi t1, t1, 1
    beq  t1, a1, loop_end
    j loop_start

loop_end:
    # Epilogue
    mv a0, t3

    jr ra
    
error:
    li   a0, 36         
    j    exit
