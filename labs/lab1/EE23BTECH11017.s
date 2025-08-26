
addi x5, x0, 1
slli x5, x5, 28
ld x7, 0(x5)  # Load Q from 0x10000000
ld x8, 8(x5)  # Load M from 0x10000008

add x20, x0, x0      # q{-1} = 0
add x21, x0, x0      # A = 0
addi x22, x0, 64     # n = 64
add x10, x0, x7      # Init output reg

loop:
beq x22, x0, label1 # exit condition
andi x19, x10, 1  # get q{0}


beq x19, x0, q_0_is_zero    # Checks for {q{0}, q{-1}} == 0x
beq x20, x0, asubm          # Checks for {q{0}, q{-1}} == 10
beq x0, x0, shift_op        # Checks if 11

asubm:
sub x21, x21, x8       # A = A - M 
beq x0, x0, shift_op

q_0_is_zero:
beq x20, x0, shift_op 
add x21, x21, x8       # A = A + M
beq x0, x0, shift_op   # if q{-1} is not 0, add and proceed to shift


shift_op:
andi x18, x21, 1    # Store LSB of A
slli x18, x18, 63   # Shift to MSB Position
srai x21, x21, 1    # A = A >>> 1

add x20, x0, x19      # Copy q_0 to q{-1}
srli x10, x10, 1      # Right shift q
or x10, x10, x18      # Shift in the LSB of A into MSB of Q

addi x22, x22, -1  # decrement n
beq x0, x0, loop

label1:
sd x10, 50(x5) # Store back to 0x10000050


## Comments because I need to label the registers somehow.