.data
.dword 1, 12, 24

.text
    #The following line initializes register x3 with 0x10000000 
    #so that you can use x3 for referencing various memory locations. 
    lui x3, 0x10000
    #your code starts here       

    add x10, x3, x0
    ld x4, 0(x3)         # Load number of pairs
    add x5, x0, x0       # initialise count register

    add x25, x0, x0      # initialise output register

    addi x31, x3, 0x200   # Set x31 to point to the output memory location

    input_loop: 
    beq x5, x4, end
        ld x21, 8(x10)   # Load first input
        ld x22, 16(x10)   # Load second input

        ori x23, x21, 0
        ori x24, x22, 0
        and x25, x23, x24
        beq x25, x0, make_zero  # If one of them is 0

        eda_loop:
            beq x22, x0, store_result
            div_loop:
                blt x21, x22, done
                sub x21, x21, x22
                j div_loop

            done: # Swap remainder (in x21) and Divisor (in x22)
                xor x21, x22, x21
                xor x22, x22, x21
                xor x21, x22, x21
            j eda_loop

            make_zero:
                add x21, x0, x0
            store_result:
            sd x21, 0(x31)
            addi x31, x31, 8

    addi x10, x10, 16    # Increment address for next iteration
    addi x5, x5, 1
    beq x0, x0, input_loop

    end:
    add x0, x0, x0

    #The final result should be in memory starting from address 0x10000200
    #The first dword location at 0x10000200 contains gcd of input11, input12
    #The second dword location from 0x10000200 contains gcd of input21, input22, and so on.