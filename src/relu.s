.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    li   t0, 1
    blt a0, t0, error
    li t1 0
    


loop_start:
    slli t2, t1, 2
    add t2, t2, a0
    lw t3 0(t2)
    li t4,0
    blt t3, t4, zero


loop_continue:
    sw   t3, 0(t2)
    addi t1, t1, 1
    beq  t1, a1, loop_end
    j loop_start
 zero:
    li   t3, 0
    j    loop_continue

loop_end:

    # Epilogue
    jr ra
error:
    li   a0, 36         
    j    exit
