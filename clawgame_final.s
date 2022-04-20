.text

# r2 is game active
# r3 is score register
# r4 is time remaining register
start: 
    addi $r3, $r0, 0 
    addi $r2, $r0, 1  # Set game active
    addi $r4, $r0, 40  # Set timer
    addi $r1, $r0, 1  # Store value 1
waiting: 
    nop
    nop
    nop
    nop
    nop
    nop
    j waiting
increment_score:
    blt $r2, $r1, waiting
    addi $r3, $r3, 1
    nop
    nop
    nop
    nop
    j waiting
decrement_timer:
    blt $r2, $r1, waiting
    blt $r4, $r1, time_out
    addi $r4, $r4, -1
    nop
    nop
    nop
    nop
    j waiting
time_out:
    addi $r2, $r0, 0  # Set game inactive
    nop
    nop
    nop
    nop
    j waiting
