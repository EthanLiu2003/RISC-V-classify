.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    li   t0, 1
    blt a2, t0, error36
    blt a3, t0, error37
    blt a4, t0, error37
    li t5, 0 #loop counter
    li t6, 0 #sum

   
loop_start:
    slli t0, a3, 2 #open space array 1
    mul t1, t5, t0
    add t1, a0, t1
    lw t2, 0(t1)
    slli t0, a4, 2 #open space array 2
    mul t1, t5, t0
    add t1, a1, t1
    lw t3, 0(t1)
    mul t4, t2, t3
    add t6, t6, t4
    addi t5, t5, 1
    beq  t5, a2, loop_end
    j loop_start
    


loop_end:
    mv a0, t6

    # Epilogue


    jr ra
error36:
    li   a0, 36
    j    exit
error37:
    li a0, 37
    j exit
